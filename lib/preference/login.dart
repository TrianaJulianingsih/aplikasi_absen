import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String loginKey = "login";
  static const String namaKey = "nama";
  static const String emailKey = "email";
  static const String userIdKey = "userId";
  
  static void saveLogin(int userId, String email, String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, true);
    await prefs.setInt(userIdKey, userId);
    await prefs.setString(namaKey, nama);
    await prefs.setString(emailKey, email);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static Future<String?> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(namaKey);
  }
  
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  // Tambahkan method setter untuk update data
  static Future<void> setNama(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(namaKey, nama);
  }

  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  static void removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
    await prefs.remove(userIdKey);
    await prefs.remove(namaKey);
    await prefs.remove(emailKey);
  }
}