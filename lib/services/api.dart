import "package:dio/dio.dart";

class API {
  // static const String endpoint = "https://sejenak.miomidev.com/api";
  static const String endpoint = "http://192.168.1.4:8000/api";
  static const String login = "$endpoint/login";
  static const String googleAuth = "$endpoint/googleAuth";
  static const String register = "$endpoint/register";
  static const String jurnal = "$endpoint/journal";
  static const String comunity = "$endpoint/comunity";
  static const String allPost = "$endpoint/comunity/getPost";
}

abstract class HttpClient {
  Future<Response> post(String url, {Map<String, dynamic>? data});
  Future<Response> get(String url, {Map<String, dynamic>? data});
  Future<Response> put(String url, {Map<String, dynamic>? data});
  Future<Response> delete(String url, {Map<String, dynamic>? data});
}

class DioHttpClient implements HttpClient {
  static final DioHttpClient _instance = DioHttpClient._internal();
  final Dio _dio;
  String _authToken = '';

  DioHttpClient._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: API.endpoint,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  factory DioHttpClient.getInstance() {
    return _instance;
  }

  /// **Set Token setelah login**
  void setToken(String token) {
    _authToken = token;
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  /// **GET Request**
  @override
  Future<Response> get(String url, {Map<String, dynamic>? data}) {
    return _dio.get(url, queryParameters: data, options: _getOptions());
  }

  /// **POST Request**
  @override
  Future<Response> post(String url, {Map<String, dynamic>? data}) {
    return _dio.post(url, data: data, options: _getOptions());
  }

  /// **PUT Request**
  @override
  Future<Response> put(String url, {Map<String, dynamic>? data}) {
    return _dio.put(url, data: data, options: _getOptions());
  }

  /// **DELETE Request**
  @override
  Future<Response> delete(String url, {Map<String, dynamic>? data}) {
    return _dio.delete(url, data: data, options: _getOptions());
  }

  Options _getOptions() {
    return Options(headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (_authToken.isNotEmpty) "Authorization": "Bearer $_authToken"
    });
  }
}
