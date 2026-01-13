import 'package:flutter/foundation.dart';

/// Helper class untuk select datasource berdasarkan platform
/// Web = Remote Datasource
/// Non-Web (Mobile/Desktop) = Local Datasource
class PlatformDataSelector<TLocal, TRemote> {
  final TLocal localDatasource;
  final TRemote remoteDatasource;

  PlatformDataSelector({required this.localDatasource, required this.remoteDatasource});

  /// Execute method dengan platform detection
  /// Web = execute webAction
  /// Non-Web = execute localAction
  Future<T> execute<T>({
    required Future<T> Function(TRemote remote) webAction,
    required Future<T> Function(TLocal local) localAction,
  }) async {
    if (kIsWeb) {
      return await webAction(remoteDatasource);
    } else {
      return await localAction(localDatasource);
    }
  }

  /// Get current datasource based on platform
  dynamic get current => kIsWeb ? remoteDatasource : localDatasource;

  /// Check if running on web
  bool get isWeb => kIsWeb;
}
