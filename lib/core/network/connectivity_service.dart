import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

class ConnectivityService {
  final Connectivity _connectivity = GetIt.I.get<Connectivity>();

  final List<ConnectivityResult> _connectedResult = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
  ];

  Future<bool> isConnected() async {
    final connectivity = await _connectivity.checkConnectivity();

    for (var element in connectivity) {
      if (_connectedResult.contains(element)) {
        return true;
      }
    }

    return false;
  }
}
