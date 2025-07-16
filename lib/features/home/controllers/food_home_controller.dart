import 'package:get/get.dart';

class FoodHomeController extends GetxController {
  bool isLoading = true;
  bool showSections = false;

  /// 🧹 امسح كل البيانات القديمة مباشرة
  void clearData() {
    isLoading = true;
    showSections = false;

    // امسح البيانات المخزنة هنا لو كنت تستخدم Lists أو Models
    // مثل: banners.clear(), categories.clear(), إلخ...

    update(); // تحديث الشاشة مباشرة بعد الحذف
  }

  /// 🔄 حمّل البيانات كلها مرة وحدة بعد الحذف
  Future<void> loadData() async {
    clearData(); // احذف البيانات قبل أي شيء

    try {
      // تحميل البيانات الرئيسية
      await _loadBanner();
      await _loadCategories();

      // تحميل البيانات الثانوية بعدهم
      await Future.wait([
        _loadBestItems(),
        _loadMostPopular(),
      ]);

      showSections = true;
    } catch (e) {
      print('❌ Error loading food home data: $e');
    }

    isLoading = false;
    update(); // تحديث الشاشة بعد انتهاء كل شيء
  }

  // dummy implementations لو مش موجودين:
  Future<void> _loadBanner() async {
    await Future.delayed(const Duration(milliseconds: 5));
  }

  Future<void> _loadCategories() async {
    await Future.delayed(const Duration(milliseconds: 5));
  }

  Future<void> _loadBestItems() async {
    await Future.delayed(const Duration(milliseconds: 5));
  }

  Future<void> _loadMostPopular() async {
    await Future.delayed(const Duration(milliseconds: 5));
  }
}
