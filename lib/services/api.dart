import "package:dio/dio.dart";

class API {
  final String endpoint = "https://sejenak.miomidev.com/api";
  late String login;
  late String register;
  late String jurnal;
  late String comunity;
  late String allPost;
  API() {
    login = "$endpoint/login";
    register = "$endpoint/register";
    jurnal = "$endpoint/journal";
    comunity = "$endpoint/comunity";
    allPost = "$endpoint/comunity/getPost";
  }
}

abstract class HttpClient {
  Future<Response> post(String url, {Map<String, dynamic>? data});
  Future<Response> get(String url, {Map<String, dynamic>? data});
  Future<Response> put(String url, {Map<String, dynamic>? data});
  Future<Response> delete(String url, {Map<String, dynamic>? data});
}

class HttpClientBuilder {
  late Dio _dio;
  String _authToken = '';
  HttpClientBuilder withDio(Dio dio) {
    _dio = dio;
    return this;
  }

  HttpClientBuilder withToken(String token) {
    _authToken = token;
    return this;
  }

  DioHttpClient build() {
    final client = DioHttpClient(_dio);
    client.authToken = _authToken;
    return client;
  }
}

class DioHttpClient implements HttpClient {
  final Dio _dio;
  late String authToken;
  DioHttpClient(this._dio);

  @override
  Future<Response> post(String url, {Map<String, dynamic>? data}) {
    print('token = $authToken');
    return authToken == ''
        ? _dio.post(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            }))
        : _dio.post(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $authToken"
            }));
  }

  @override
  Future<Response> get(String url, {Map<String, dynamic>? data}) {
    print('token = $authToken');

    return authToken == ''
        ? _dio.get(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            }))
        : _dio.get(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $authToken"
            }));
  }

  @override
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    return authToken == ''
        ? _dio.put(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            }))
        : _dio.put(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $authToken"
            }));
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    return authToken == ''
        ? _dio.delete(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            }))
        : _dio.delete(url,
            data: data,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $authToken"
            }));
  }
}
