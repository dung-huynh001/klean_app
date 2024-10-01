import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Map<String, dynamic>? decodingToken(String token) {
    Map<String, dynamic>? decodedToken = JwtDecoder.tryDecode(token);
    Map<String, dynamic>? result = {};
    if (decodedToken != null) {
      decodedToken.forEach((key, value) {
        if (key.contains('claims/nameidentifier')) {
          result['nameidentifier'] = value;
        } else if (key.contains('claims/name')) {
          result['username'] = value;
        } else if (key.contains('claims/role')) {
          result['role'] = value;
        } else {
          result[key] = value;
        }
      });
      return result;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getTokenData() async {
    String? token = await getToken() ?? "";
    return decodingToken(token);
  }

  static bool isTokenValid(String token) {
    return decodingToken(token) != null && JwtDecoder.isExpired(token) == false;
  }
}
