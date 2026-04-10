import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../../../data.dart';

@LazySingleton()
class RefreshTokenApiService {
  RefreshTokenApiService(this._refreshTokenApiClient);

  final RefreshTokenApiClient _refreshTokenApiClient;

  Future<DataResponse<TokenAuthResponseData>?> refreshToken(
      String refreshToken) async {
    try {
      final response = await _refreshTokenApiClient
          .request<TokenAuthResponseData, DataResponse<TokenAuthResponseData>>(
        method: RestMethod.post,
        path: '/auth/refresh-token',
        body: {
          'refreshToken': refreshToken,
        },
        decoder: (json) =>
            TokenAuthResponseData.fromJson(json as Map<String, dynamic>),
      );

      return response;
    } catch (e) {
      if (e is RemoteException &&
          (e.kind == RemoteExceptionKind.serverDefined ||
              e.kind == RemoteExceptionKind.serverUndefined)) {
        throw const RemoteException(
            kind: RemoteExceptionKind.refreshTokenFailed);
      }

      rethrow;
    }
  }
}
