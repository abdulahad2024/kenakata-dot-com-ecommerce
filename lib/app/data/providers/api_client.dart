import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiClient extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  Map<String, String> get _headers {
    final token = _storage.token;
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on SocketException {
      throw 'No Internet connection available.';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on SocketException {
      throw 'No Internet connection available.';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on SocketException {
      throw 'No Internet connection available.';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 20));
      return _processResponse(response);
    } on SocketException {
      throw 'No Internet connection available.';
    } catch (e) {
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    dynamic jsonResponseBody;
    try {
      jsonResponseBody = jsonDecode(response.body);
    } catch (_) {
      jsonResponseBody = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponseBody;
    } else {
      String message = 'An unexpected error occurred (${response.statusCode})';
      if (jsonResponseBody is Map && jsonResponseBody.containsKey('message')) {
        message = jsonResponseBody['message'].toString();
      } else if (jsonResponseBody is Map && jsonResponseBody.containsKey('error')) {
        message = jsonResponseBody['error'].toString();
      }
      throw message;
    }
  }
}
