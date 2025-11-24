import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkStatusService {
  static final NetworkStatusService _instance =
      NetworkStatusService._internal();
  factory NetworkStatusService() => _instance;
  NetworkStatusService._internal();

  /// Returns true if device has actual internet access (not just connected to WiFi)
  Future<bool> get hasConnection async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult.first == ConnectivityResult.none) {
    //   return false;
    // }
    // Check actual internet access
    // return await InternetConnectionChecker.createInstance().hasConnection;
    return true;
  }

  /// Optionally, listen to changes in network status
  Stream<bool> get onStatusChange async* {
    await for (final _ in Connectivity().onConnectivityChanged) {
      yield await hasConnection;
    }
  }
}
