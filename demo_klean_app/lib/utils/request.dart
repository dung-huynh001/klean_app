import 'package:KleanApp/utils/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Request {
  final String _baseUrl = 'https://192.168.3.38:7127';

  Request();

  Future<dynamic> get(String endpoint, String? token) async {
    try {
      if (token != null && TokenService.isTokenValid(token) == false) {
        return;
      }
      final response =
          await http.get(_buildUri(endpoint), headers: _createHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during GET request: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic body, String? token) async {
    try {
      if (token != null && TokenService.isTokenValid(token) == false) {
        return;
      }
      final response = await http.post(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during POST request: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic body, String? token) async {
    try {
      if (token != null && TokenService.isTokenValid(token) == false) {
        return;
      }
      final response = await http.put(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during PUT request: $e');
    }
  }

  Future<dynamic> patch(String endpoint, dynamic body, String? token) async {
    try {
      if (token != null && TokenService.isTokenValid(token) == false) {
        return;
      }
      final response = await http.patch(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during PATCH request: $e');
    }
  }

  Future<dynamic> delete(String endpoint, dynamic body, String? token) async {
    try {
      if (token != null && TokenService.isTokenValid(token) == false) {
        return;
      }
      final response = await http.delete(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during DELETE request: $e');
    }
  }

  Map<String, String> _createHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String endpoint) {
    return Uri.parse('$_baseUrl/$endpoint');
  }

  dynamic _handleResponse(http.Response response) {
    return jsonDecode(response.body);
  }
}
