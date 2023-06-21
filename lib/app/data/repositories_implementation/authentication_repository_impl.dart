import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/local/session_service.dart';
import '../services/remote/account_api.dart';
import '../services/remote/authentication_api.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._authenticationAPI,
    this._sessionService,
    this._accountAPI,
  );

  final AuthenticationAPI _authenticationAPI;
  final SessionService _sessionService;
  final AccountAPI _accountAPI;

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _sessionService.sessionId;

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
              await _sessionService.saveSessionId(sessionId);
              final user = await _accountAPI.getAccount(sessionId);
              if (user == null) {
                return Either.left(SignInFailure.unknown);
              }
              return Either.right(user);
            },
          );
        },
      );
    });
  }

  @override
  Future<void> signOut() {
    return _sessionService.signOut();
  }
}
