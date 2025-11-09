// utils/user_session.dart
import 'package:telewehab/models/user_model.dart';

class UserSession {
  static String? accessToken;
  static String? refreshToken;
  static User? currentUser;

  static void saveSession(String access, String refresh, User user) {
    accessToken = access;
    refreshToken = refresh;
    currentUser = user;
  }

  static void clear() {
    accessToken = null;
    refreshToken = null;
    currentUser = null;
  }

  static bool get isLoggedIn => currentUser != null;

  static bool get isPatient => currentUser?.role == 2;
  static bool get isOperator => currentUser?.role == 1 || currentUser?.role == 3;
}
