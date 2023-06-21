import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/remote/authentication_api.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._flutterSecureStorage,
    this._authenticationAPI,
  );

  final FlutterSecureStorage _flutterSecureStorage;
  final AuthenticationAPI _authenticationAPI;

  @override
  Future<User?> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _flutterSecureStorage.read(key: _key);

    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    final requestToken = await _authenticationAPI.createRequestToken();

    return requestToken.when((failure) {
      return Either.left(failure);
    }, (requestToken) async {
      final loginResult = await _authenticationAPI.createSessionWithLogin(
        username: username,
        password: password,
        requestToken: requestToken,
      );

      return loginResult.when(
        (failure) async => Either.left(failure),
        (newRequestToken) async {
          final sessionResult =
              await _authenticationAPI.createSession(newRequestToken);

          return sessionResult.when(
            (failure) async => Either.left(failure),
            (sessionId) async {
              await _flutterSecureStorage.write(key: _key, value: sessionId);
              return Either.right(User());
            },
          );
        },
      );
    });
  }

  @override
  Future<void> signOut() {
    return _flutterSecureStorage.delete(key: _key);
  }
}
