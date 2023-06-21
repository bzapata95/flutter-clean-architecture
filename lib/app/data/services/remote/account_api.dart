import '../../../domain/models/user.dart';
import '../../http/http.dart';

class AccountAPI {
  AccountAPI(this._http);

  final Http _http;

  Future<User?> getAccount(String sessionId) async {
    final result = await _http.request(
      '/account/11835556',
      queryParameters: {
        'session_id': sessionId,
      },
      onSuccess: (json) {
        return User.fromJson(json);
      },
    );

    return result.when((_) => null, (user) => user);
  }
}
