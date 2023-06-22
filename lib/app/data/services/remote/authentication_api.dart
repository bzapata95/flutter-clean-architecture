import '../../../domain/either.dart';
import '../../../domain/failures/sign_in_failure/sign_in_failure.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode) {
        case 401:
          return Either.left(SignInFailureUnauthorized());
        case 404:
        case 400:
          return Either.left(SignInFailureNotFound());
        default:
          return Either.left(SignInFailureUnknown());
      }
    }
    if (failure.exception is NetworkException) {
      return Either.left(SignInFailureNetwork());
    }
    return Either.left(SignInFailureUnknown());
  }

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );

    return result.when(
        left: _handleFailure,
        right: (responseBody) {
          return Either.right(responseBody);
        });
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken
      },
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        final newRequestToken = json['request_token'];
        return newRequestToken;
      },
    );

    return result.when(
        left: _handleFailure,
        right: (responseBody) {
          return Either.right(responseBody);
        });
  }

  Future<Either<SignInFailure, String>> createSession(
      String requestToken) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      body: {
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['session_id'] as String;
      },
    );

    return result.when(
        left: _handleFailure,
        right: (sessionId) {
          return Either.right(sessionId);
        });
  }
}
