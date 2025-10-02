import "package:dio/dio.dart";

class API {
  static const String endpoint = "https://sejenak.miomi.dev/api";
  static const String endpointImage = "https://sejenak.miomi.dev/";
  // static const String endpoint = "http://192.168.5.10:8000/api";
  static const String login = "$endpoint/login";
  static const String googleAuth = "$endpoint/googleAuth";
  static const String register = "$endpoint/register";
  static const String jurnal = "$endpoint/journal";
  static const String comunity = "$endpoint/comunity";
  static const String konselor = "$endpoint/konselor";
  static const String allPost = "$endpoint/comunity/getPost";
  static const String verification = "$endpoint/verify-code";
  static const String resendCode = "$endpoint/resend-verification";
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
          connectTimeout: const Duration(seconds: 30), // Diperpanjang
          receiveTimeout: const Duration(seconds: 30), // Diperpanjang
        )) {
    // Tambahkan interceptor untuk logging dan error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 Sending ${options.method} request to ${options.uri}');
        print('📦 Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ Response received: ${response.statusCode}');
        print('📋 Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ Dio Error: ${e.type}');
        print('📝 Message: ${e.message}');
        print('🔍 Response: ${e.response?.data}');
        print('📊 Status: ${e.response?.statusCode}');
        return handler.next(e);
      },
    ));
  }

  factory DioHttpClient.getInstance() {
    return _instance;
  }

  /// **Set Token setelah login**
  void setToken(String token) {
    _authToken = token;
    _dio.options.headers["Authorization"] = "Bearer $token";
    print('🔑 Authentication token set');
  }

  /// **Clear Token saat logout**
  void clearToken() {
    _authToken = '';
    _dio.options.headers.remove("Authorization");
    print('🔒 Authentication token cleared');
  }

  /// **GET Request dengan error handling**
  @override
  Future<Response> get(String url, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.get(url, queryParameters: data, options: _getOptions());
    } on DioException catch (e) {
      _logDetailedError(e, url, 'GET');
      rethrow;
    }
  }

  /// **POST Request dengan error handling**
  @override
  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(url, data: data, options: _getOptions());
    } on DioException catch (e) {
      _logDetailedError(e, url, 'POST');
      rethrow;
    }
  }

  /// **PUT Request dengan error handling**
  @override
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(url, data: data, options: _getOptions());
    } on DioException catch (e) {
      _logDetailedError(e, url, 'PUT');
      rethrow;
    }
  }

  /// **DELETE Request dengan error handling**
  @override
  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.delete(url, data: data, options: _getOptions());
    } on DioException catch (e) {
      _logDetailedError(e, url, 'DELETE');
      rethrow;
    }
  }

  Options _getOptions() {
    return Options(
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (_authToken.isNotEmpty) "Authorization": "Bearer $_authToken"
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  void _logDetailedError(DioException e, String url, String method) {
    print('''
🚨 HTTP ERROR DETAILS
=====================
Request: $method $url
Error Type: ${e.type}
Message: ${e.message}
Status Code: ${e.response?.statusCode ?? 'N/A'}
Response Data: ${e.response?.data ?? 'No response data'}
Request Data: ${e.requestOptions.data}
    ''');
  }
}