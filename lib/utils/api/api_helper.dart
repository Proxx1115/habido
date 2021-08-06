import 'package:habido_app/utils/localization/localization.dart';
import '../func.dart';
import '../shared_pref.dart';

class ApiHelper {
  /// URI = scheme:[//authority]path[?query][#fragment]
  static const String baseUrl = 'http://192.168.2.21:8041/'; // Test
  // static const String baseUrl = 'http://zeelyapp.tanasoft.mn'; // Zeely

  static Map<String, String> getHttpHeaders({bool hasAuthorization = true}) {
    var headers = Map<String, String>();
    headers.addAll({
      "Connection": "Close",
      "Accept": "application/json",
      "Accept-Charset": "utf-8",
      "Content-Type": "application/json; charset=utf-8; ",
    });

    if (hasAuthorization && Func.isNotEmpty(SharedPref.getSessionToken())) {
      headers.addAll({"authorization": "Bearer " + SharedPref.getSessionToken()});
    }

    return headers;
  }

  static String getErrorMessage(int errCode, [Object? error]) {
    String message = "Алдаа гарлаа: $errCode";
    // print(error.message);

    switch (errCode) {
      case ResponseCode.Failed:
        message = 'Хүсэлт амжилтгүй.';
        break;

      case ResponseCode.RequestTimeout:
        message = 'Timeout';
        break;

      case ResponseCode.BadRequest:
        message = 'Интернэт холболтоо шалгана уу!';
        break;
    }
    return message;
  }
}

class ResponseField {
  static const code = 'code';
  static const message = 'message';
  static const data = 'data';

  static String getFailedDesc(String desc) {
    if (Func.isNotEmpty(desc)) {
      return desc;
    } else {
      return LocaleKeys.failed;
    }
  }
}

/// HTTP response codes
class ResponseCode {
  // 1xx Informational
  static const Continue = 100;

  // 2xx Success
  static const OK = 200; // Request is successfully completed.

  // 3xx Redirection
  static const MultipleChoices = 300;

  // 4xx Client error
  static const Failed = 4;
  static const NoData = 40;
  static const BadRequest = 400; // No internet
  static const Unauthorized = 401; // We could not recognize you.
  static const Forbidden = 403; // Access to the requested resource or action is forbidden.
  static const NotFound = 404; // The requested resource could not be found.
  static const RequestTimeout = 408;

  // 5xx Server error
  static const InternalServerError = 500; // We had a problem with our server. Try again later.
  static const ServiceUnavailable = 503; // We're temporarily offline for maintenance. Please try again later.

  /// Business response codes
  static const Success = 200;
  static const ChangePass = 91001008; // Нууц үгээ солино уу
  static const SerializeError = 999; // json serializeError
  static const SessionExpired = 91001018; // Нэвтэрнэ үү

}

class HttpMethod {
  static const POST = 'POST';
  static const GET = 'GET';
  static const PUT = 'PUT';
  static const DELETE = 'DELETE';
}
