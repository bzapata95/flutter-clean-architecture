abstract class ConnectivityRepository {
  Future<void> initialize();
  bool get hasInternetConnection;
  Stream<bool> get onInternetChanged;
}
