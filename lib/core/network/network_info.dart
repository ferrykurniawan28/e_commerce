import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return _isConnected(connectivityResult);
  }

  @override
  Stream<List<ConnectivityResult>> get connectivityStream {
    return connectivity.onConnectivityChanged;
  }

  bool _isConnected(List<ConnectivityResult> results) {
    // Check if any of the connectivity results indicate a connection
    return results.any((result) => result != ConnectivityResult.none);
  }
}
