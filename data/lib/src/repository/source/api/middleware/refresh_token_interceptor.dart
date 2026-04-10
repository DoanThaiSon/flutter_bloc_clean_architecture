import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../../../../data.dart';

@Injectable()
class RefreshTokenInterceptor extends QueuedInterceptorsWrapper {
  RefreshTokenInterceptor(
      this.appPreferences,
      this.refreshTokenService,
      this._noneAuthAppServerApiClient,
      );

  final AppPreferences appPreferences;
  final RefreshTokenApiService refreshTokenService;
  final NoneAuthAppServerApiClient _noneAuthAppServerApiClient;

  Completer<String>? _refreshCompleter;

  static const String _retryKey = 'refresh_token_retry';

  int get priority => BaseInterceptor.refreshTokenPriority;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final options = err.response?.requestOptions;
    if (err.response?.statusCode == HttpStatus.unauthorized &&
        options != null &&
        options.extra[_retryKey] != true) {

      if (_refreshCompleter != null) {
        try {
          final newToken = await _refreshCompleter!.future;
          await _retryRequest(
            options: options,
            handler: handler,
            newAccessToken: newToken,
          );
        } catch (e) {

          await appPreferences.clearCurrentUserData();
          handler.reject(
            DioException(
              requestOptions: options,
              error: e,
              type: DioExceptionType.badResponse,
            ),
          );
        }
        return;
      }


      _refreshCompleter = Completer<String>();

      try {
        final newToken = await _refreshToken();
        _refreshCompleter!.complete(newToken);


        await _retryRequest(
          options: options,
          handler: handler,
          newAccessToken: newToken,
        );
      } catch (e) {
        _refreshCompleter!.completeError(e);


        await appPreferences.clearCurrentUserData();

        handler.reject(
          DioException(
            requestOptions: options,
            error: e,
            type: DioExceptionType.badResponse,
          ),
        );
      } finally {
        _refreshCompleter = null;
      }
    } else {

      handler.next(err);
    }
  }

  void _putAccessToken({
    required Map<String, dynamic> headers,
    required String accessToken,
  }) {
    headers[ServerRequestResponseConstants.basicAuthorization] =
    '${ServerRequestResponseConstants.bearer} $accessToken';
  }

  Future<String> _refreshToken() async {
    final refreshToken = await appPreferences.refreshToken;

    if (refreshToken.isEmpty) {
      throw Exception('Refresh token is empty');
    }

    final refreshTokenResponse =
    await refreshTokenService.refreshToken(refreshToken);

    final String newAccessToken =
        refreshTokenResponse?.data?.accessToken?? '';
    final String newRefreshToken =
        refreshTokenResponse?.data?.refreshToken??'';

    if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
      throw Exception('Invalid refresh token response');
    }

    await Future.wait([
      appPreferences.saveAccessToken(newAccessToken),
      appPreferences.saveRefreshToken(newRefreshToken),
    ]);

    return newAccessToken;
  }

  Future<void> _retryRequest({
    required RequestOptions options,
    required ErrorInterceptorHandler handler,
    required String newAccessToken,
  }) async {
    options.extra[_retryKey] = true;

    _putAccessToken(headers: options.headers, accessToken: newAccessToken);

    try {
      final response = await _noneAuthAppServerApiClient.dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.reject(e);
      } else {
        handler.reject(DioException(requestOptions: options, error: e));
      }
    }
  }
}
