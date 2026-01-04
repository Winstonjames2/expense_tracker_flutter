import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> isConnected({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final connectivityResult = await Connectivity()
          .checkConnectivity()
          .timeout(timeout);
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false; // Timeout or other error
    }
  }
}
