import 'package:injectable/injectable.dart';

import 'package:shared/shared.dart';
import '../../../../../../../data.dart';

@Injectable()
class JsonObjectErrorResponseMapper extends BaseErrorResponseMapper<Map<String, dynamic>> {
  @override
  ServerError mapToServerError(Map<String, dynamic>? data) {
    // Hỗ trợ cả 2 format:
    // 1. {"error": {"status_code": 422, "error_code": "...", "message": "..."}}
    // 2. {"statusCode": 422, "message": "..."}
    final hasErrorWrapper = data?['error'] != null;
    
    return ServerError(
      generalServerStatusCode: hasErrorWrapper 
          ? data?['error']?['status_code'] as int?
          : data?['statusCode'] as int?,
      generalServerErrorId: hasErrorWrapper
          ? data?['error']?['error_code'] as String?
          : data?['errorCode'] as String?,
      generalMessage: hasErrorWrapper
          ? data?['error']?['message'] as String?
          : data?['message'] as String?,
    );
  }
}
