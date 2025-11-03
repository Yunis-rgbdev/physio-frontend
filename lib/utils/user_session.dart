import 'package:telewehab/models/user_model.dart';

class UserSession {
  static String? accessToken;
  static String? refreshToken;
  static User? user;

  static void saveSession(String access, String refresh, User userData) {
    accessToken = access;
    refreshToken = refresh;
    user = userData;
  }

  static void clearSession() {
    accessToken = null;
    refreshToken = null;
    user = null;
  }

  static bool get isLoggedIn => accessToken != null && user != null;
}
