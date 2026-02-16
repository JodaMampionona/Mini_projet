import 'package:dio/dio.dart';

// api
const apiAuthority = 'http://192.168.108.237:8000';
const apiPrefix = '/';

// http utils
final dio =
    Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          baseUrl: '$apiAuthority$apiPrefix',
          headers: {
            Headers.contentTypeHeader: 'application/json',
            'User-Agent': 'beTax/1.0',
          },
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print(
              'REQUEST[${options.method}] => PATH: ${options.path} param : ${options.queryParameters}',
            );
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            return handler.next(response);
          },
          onError: (err, handler) {
            print(
              'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
            );
            return handler.next(err);
          },
        ),
      );
