import 'package:dio/dio.dart';

Dio previous = Dio();
Dio refreshTokenDio = Dio();

String _baseUrl = 'http://192.168.1.200:5001/';
// String _baseUrl = 'http://192.169.1.168:5001/';

var API_BASE = Dio(BaseOptions(
  baseUrl: _baseUrl,
  connectTimeout: 10000,
  receiveTimeout: 8000,
))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Do something before request is sent
        print('REQUEST[${options.method}] => PATH: ${options.path}');

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Do something with response data
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioError err, handler) async {
        if (err.response != null) {
          switch (err.response!.statusCode) {
            case 400:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 401:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 403:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 404:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 408:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 409:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 500:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            case 503:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              break;
            default:
              print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              return;
          }
        } else {
          print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
          return;
        }
        return handler.next(err);
      },
    ),
  );
