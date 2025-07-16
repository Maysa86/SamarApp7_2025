import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/language/controllers/language_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'common/controllers/theme_controller.dart';
import 'features/favourite/controllers/favourite_controller.dart';
import 'features/notification/domain/models/notification_body_model.dart';
import 'helper/address_helper.dart';
import 'helper/auth_helper.dart';
import 'helper/notification_helper.dart';
import 'helper/responsive_helper.dart';
import 'helper/route_helper.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'util/app_constants.dart';
import 'util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'features/home/widgets/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await runZonedGuarded(
    () async {
      if (ResponsiveHelper.isMobilePhone()) {
        HttpOverrides.global = MyHttpOverrides();
      }
      setPathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();

      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      if (GetPlatform.isWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDlViGIjbNjm3kTruIjndbem-Mu00SCj3U",
              authDomain: "samarapp-2024.firebaseapp.com",
              projectId: "samarapp-2024",
              storageBucket: "samarapp-2024.appspot.com",
              messagingSenderId: "465459152178",
              appId: "1:465459152178:web:cc6e1566d0dc00e3bc832b",
              measurementId: "G-87RD9TPJVL"),
        );
      } else if (GetPlatform.isAndroid) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyDdOEA2AVLRodFPen-qz0ThZFfPX-efL0I',
            appId: '1:465459152178:android:3c250e3f1e025eb3bc832b',
            messagingSenderId: '465459152178',
            projectId: 'samarapp-2024',
            storageBucket: 'samarapp-2024.appspot.com',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
      final sharedPreferences = await SharedPreferences.getInstance();
      Get.put(sharedPreferences);

      Map<String, Map<String, String>> languages = await di.init();

      NotificationBodyModel? body;
      try {
        if (GetPlatform.isMobile) {
          final RemoteMessage? remoteMessage =
              await FirebaseMessaging.instance.getInitialMessage();
          if (remoteMessage != null) {
            body = NotificationHelper.convertNotification(remoteMessage.data);
          }
          await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
          FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
        }
      } catch (_) {}

      if (ResponsiveHelper.isWeb()) {
        await FacebookAuth.instance.webAndDesktopInitialize(
          appId: "380903914182154",
          cookie: true,
          xfbml: true,
          version: "v15.0",
        );
      }
      runApp(MyApp(languages: languages, body: body));
    },
    (error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        parent.print(zone, line);
      },
    ),
    zoneValues: {'navigatorKey': 'navigatorKey'},
  );
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (AddressHelper.getUserAddressFromSharedPref() != null &&
          AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      if (!AuthHelper.isLoggedIn() &&
          !AuthHelper
              .isGuestLoggedIn() /*&& !ResponsiveHelper.isDesktop(Get.context!)*/) {
        await Get.find<AuthController>().guestLogin();
      }

      if ((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) &&
          Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    Get.find<SplashController>()
        .getConfigData(loadLandingData: GetPlatform.isWeb)
        .then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          if (Get.find<SplashController>().module != null) {
            await Get.find<FavouriteController>().getFavouriteList();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? dark() : light(),
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(widget.body),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1)),
                        child: Material(
                          child: Stack(children: [
                            widget!,
                            GetBuilder<SplashController>(
                                builder: (splashController) {
                              if (!splashController.savedCookiesData &&
                                  !splashController.getAcceptCookiesStatus(
                                      splashController.configModel != null
                                          ? splashController
                                              .configModel!.cookiesText!
                                          : '')) {
                                return ResponsiveHelper.isWeb()
                                    ? const Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CookiesView())
                                    : const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            })
                          ]),
                        ));
                  },
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
