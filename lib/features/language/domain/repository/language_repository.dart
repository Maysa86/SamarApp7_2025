import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/api_client.dart';
import '../../../address/domain/models/address_model.dart';
import 'language_repository_interface.dart';
import '../../../../util/app_constants.dart';

class LanguageRepository implements LanguageRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LanguageRepository(
      {required this.apiClient, required this.sharedPreferences});

  @override
  AddressModel? getAddressFormSharedPref() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(
          jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    } catch (e) {
      log('Did not get shared Preferences address: $e');
    }
    return addressModel;
  }

  @override
  void updateHeader(AddressModel? addressModel, Locale locale, int? moduleId) {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      addressModel?.zoneIds,
      addressModel?.areaIds,
      locale.languageCode,
      moduleId,
      addressModel?.latitude,
      addressModel?.longitude,
    );
  }

  @override
  Locale getLocaleFromSharedPref() {
    return Locale(
        sharedPreferences.getString(AppConstants.languageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.countryCode) ??
            AppConstants.languages[0].countryCode);
  }

  @override
  void saveLanguage(Locale locale) {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  @override
  void saveCacheLanguage(Locale locale) {
    sharedPreferences.setString(
        AppConstants.cacheLanguageCode, locale.languageCode);
    sharedPreferences.setString(
        AppConstants.cacheCountryCode, locale.countryCode!);
  }

  @override
  Locale getCacheLocaleFromSharedPref() {
    return Locale(
        sharedPreferences.getString(AppConstants.cacheLanguageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.cacheCountryCode) ??
            AppConstants.languages[0].countryCode);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
