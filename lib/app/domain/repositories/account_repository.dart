import '../models/user/user.dart';

abstract class AccountRepository {
  Future<User?> getUserData();
}
