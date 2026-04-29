import 'dart:async';

class ApiService {
  // محاكاة لعملية ربط مع قاعدة بيانات أو واجهة برمجة تطبيقات
  Future<String> connectAndFetch() async {
    await Future.delayed(const Duration(seconds: 2));
    return "تم الربط بنجاح واستلام البيانات!";
  }
}
