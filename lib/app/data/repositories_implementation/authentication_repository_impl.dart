import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _flutterSecureStorage;

  AuthenticationRepositoryImpl(
    this._flutterSecureStorage,
  );

  @override
  Future<User?> getUserData() {
    return Future.value(null);
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _flutterSecureStorage.read(key: _key);

    return sessionId != null;
  }
}
