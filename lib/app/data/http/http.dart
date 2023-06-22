import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../domain/either/either.dart';

part 'failure.dart';
part 'log.dart';
part 'parse_response_body.dart';

enum HttpMethod { get, post, patch, delete, put }

class Http {
  Http({
    required Client client,
    required String baseUrl,
    required String token,
  })  : _client = client,
        _token = token,
        _baseUrl = baseUrl;

  final String _baseUrl;
  final String _token;
  final Client _client;

  Future<Either<HttpFailure, T>> request<T>(
    String path, {
    required T Function(dynamic responseBody) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool useToken = true,
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTrace;
    try {
      if (useToken) {
        headers = {
          'Authorization': _token,
          ...headers,
        };
      }
      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );

      if (queryParameters.isNotEmpty) {
        url = url.replace(
          queryParameters: queryParameters,
        );
      }

      headers = {
        'content-type': 'application/json',
        ...headers,
      };
      late final Response response;

      final bodyString = jsonEncode(body);

      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body,
      };

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(
            url,
            headers: headers,
          );
          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
      }

      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);

      logs = {
        ...logs,
        'startTime': DateTime.now().toString(),
        'statusCode': statusCode,
        'responseBody': responseBody,
      };

      if (statusCode >= 200 && statusCode < 300) {
        print(responseBody);

        return Either.right(onSuccess(responseBody));
      }
      return Either.left(
        HttpFailure(
          statusCode: statusCode,
          data: responseBody,
        ),
      );
    } catch (e, s) {
      stackTrace = s;
      logs = {
        ...logs,
        'exception': e.runtimeType,
      };

      if (e is SocketException || e is ClientException) {
        logs = {
          ...logs,
          'exception': 'NetworkException',
        };
        return Either.left(
          HttpFailure(
            exception: NetworkException(),
          ),
        );
      }

      return Either.left(HttpFailure(exception: e));
    } finally {
      logs = {
        ...logs,
        'endTime': DateTime.now().toString(),
      };

      _printLogs(logs, stackTrace);
    }
  }
}
