import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/base_request.dart';
import '../func.dart';
import 'api_helper.dart';
import 'logger.dart';

/// Global api caller
ApiManager apiManager = ApiManager();

class ApiManager {
  Dio _client = Dio();
  final logger = Logger('Api');

  ApiManager() {
    init(url: ApiHelper.baseUrl, isInit: true);
  }

  /// Main HTTP request
  Future<dynamic> sendRequest({
    /// Base
    String url = ApiHelper.baseUrl,
    required String path,
    String httpMethod = HttpMethod.POST,
    Map<String, String>? headers,
    bool hasAuthorization = true,

    /// Data
    String dataType = DataType.Object,
    BaseRequest? objectData, //  POST - Class model
    dynamic dynamicData, // String, num
    Map<String, String>? queryParameters, // GET
  }) async {
    /// Response
    var requestOptions = RequestOptions(path: path);
    Response response = Response(requestOptions: requestOptions);
    Map<String, dynamic> responseData = initResponseData();

    logger.func = httpMethod;

    try {
      /// Headers
      if (headers == null) headers = ApiHelper.getHttpHeaders(hasAuthorization: hasAuthorization);
      _client.options.headers = headers;
      if (!hasAuthorization) _client.options.headers.remove("authorization");

      logger.log(s: 2, m: objectData?.toString(), m2: objectData?.toJson());

      /// Url
      _client.options.baseUrl = url;

      /// Request data
      dynamic requestBody;

      switch (dataType) {
        case DataType.Object:
          requestBody = objectData?.toJson();
          break;

        case DataType.Empty:
          requestBody = <Map<String, dynamic>>[]; // Empty list. Example: []
          break;

        case DataType.Int:
        case DataType.Str:
          requestBody = <dynamic>[]; // Dynamic list. Example: [11, "12"]
          if (dynamicData != null) requestBody.add(dynamicData);
          break;

        case DataType.List:
          var dataList = (dynamicData != null) ? dynamicData : []; // Dynamic list. Example: [11, "12"]
          requestBody = dataList;
          break;

        default:
          requestBody = (objectData != null) ? objectData.toJson() : <Map<String, dynamic>>[];
      }

      /// Send request
      switch (httpMethod) {
        case HttpMethod.GET:
          response = await _client.get(path, queryParameters: queryParameters);
          break;

        case HttpMethod.PUT:
        case HttpMethod.DELETE:
        case HttpMethod.POST:
        default:
          response = await _client.post(path, data: requestBody);
          break;
      }

      /// Response
      logger.log(s: 3, m: response);
      if (response.statusCode == ResponseCode.Success) {
        /// SUCCESS
        logger.log(s: 4);

        // Manage response
        responseData[ResponseField.code] = ResponseCode.Success;
        if (response.data == null) {
          // Empty
        } else if (response.data is String || response.data is int) {
          responseData[ResponseField.data] = response.data; // Str, int
        } else if (response.data is Map<String, dynamic>) {
          responseData.addAll(response.data); // JSON object
        } else {
          responseData[ResponseField.data] = response.data; // Other response, JSON array etc
        }
      } else {
        /// FAILED
        responseData[ResponseField.code] = ResponseCode.Failed;
        logger.log(s: 5, m: response);
      }

      response.data = responseData;
    } on DioError catch (error) {
      /// FAILED
      logger.log(s: 10, m: "DioError Exception: $error");
      responseData[ResponseField.code] = error.response?.statusCode;
      responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.Failed, error.message);

      if (error.type == DioErrorType.connectTimeout) {
        // Request timeout
        responseData[ResponseField.code] = ResponseCode.RequestTimeout;
        responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.RequestTimeout, error.message);
      } else if (error.response != null) {
        // Normal response
        response = error.response!;
        if (response.data != null && response.data is Map<String, dynamic>) {
          try {
            responseData[ResponseField.code] = error.response?.data['StatusCode'];
            responseData[ResponseField.message] = error.response?.data['Message'];
          } catch (e) {
            print(e);
          }
        }
      }

      /// Session timeout
      try {
        if (error.response?.statusCode == ResponseCode.Unauthorized) {
          /// Session timeout
          // BlocManager.homeBloc.add(SessionExpiredEvent()); // todo test
        }
      } catch (e) {
        print(e);
      }
    } catch (error, stacktrace) {
      print(error);
      logger.log(s: 11, m: "Exception occured: $error stackTrace: $stacktrace");
      responseData[ResponseField.code] = ResponseCode.Failed;
      responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.Failed, error);
    } finally {
      response.data = responseData;
    }

    return response.data;
  }

  void init({
    required String url,
    bool isInit = false, // URL өөрчлөгдсөн бол client-ийг дахин тодорхойлно
  }) async {
    /// Main http client
    logger.func = "_internal";
    logger.log(s: 1);

    BaseOptions options = BaseOptions();
    options.baseUrl = ApiHelper.baseUrl; // + ApiHelper.basePath;
    options.contentType = Headers.jsonContentType; //ContentType.parse("application/json");
    //options.contentType= ContentType.parse("application/x-www-form-urlencoded");
    options.headers = await ApiHelper.getHttpHeaders();
//      _client.httpClientAdapter

    _client = Dio(options);
    _client.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));

    // Дараах алдааг засав
    //I/flutter (29083): DioError [DioErrorType.DEFAULT]: HandshakeException: Handshake error in client (OS Error:
    //I/flutter (29083): 	CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate(handshake.cc:354))
    (_client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Map<String, dynamic> initResponseData() {
    return Map<String, dynamic>()
      ..putIfAbsent(ResponseField.code, () => ResponseCode.Failed)
      ..putIfAbsent(ResponseField.message, () => '')
      ..putIfAbsent(ResponseField.data, () => null);
  }

  Future<Response> simpleHttpRequest({
    required String url,
    // BaseRequest requestData,
    // String httpMethod = HttpMethod.Get,
    // String dataType = DataType.Object,
    // Map<String, String> headers,
    // Map<String, String> queryParameter,
    bool hasSessionToken = true,
    dynamic data,
  }) async {
    /// Response
    var requestOptions = RequestOptions(path: '');
    Response response = Response(requestOptions: requestOptions);

    // assert(requestData != null);
    logger.func = 'simpleHttpRequest';

    Map<String, dynamic> responseData = initResponseData();

    try {
      BaseOptions options = BaseOptions();
      options.baseUrl = url;
      options.contentType = Headers.jsonContentType;

      // options.headers = Map<String, dynamic>();
      // options.headers.addAll({
      //   "Connection": "Close",
      //   "Accept": "application/json",
      //   "Accept-Charset": "utf-8",
      //   "Content-Type": "application/json; charset=utf-8; ",
      // });
      // CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate(handshake.cc:354)
      Dio client = Dio(options);
      client.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));
      (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
      client = Dio(options);
      client.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(requestBody: true, responseBody: true));

      /// Send request
      response = await client.get('');

      /// Response
      logger.log(s: 3, m: response);
      if (response.statusCode == ResponseCode.Success) {
        /// SUCCESS
        logger.log(s: 4);

        // Manage response
        responseData[ResponseField.code] = ResponseCode.Success;
        if (response.data == null) {
          // Empty
        } else if (response.data is String || response.data is int) {
          responseData[ResponseField.data] = response.data; // Str, int
        } else if (response.data is Map<String, dynamic>) {
          responseData.addAll(response.data); // JSON object
        } else {
          responseData[ResponseField.data] = response.data; // Other response, JSON array etc
        }
      } else {
        /// FAILED
        responseData[ResponseField.code] = ResponseCode.Failed;
        logger.log(s: 5, m: response);
      }

      response.data = responseData;
    } on DioError catch (error) {
      /// FAILED
      logger.log(s: 10, m: "DioError Exception: $error");
      responseData[ResponseField.code] = error.response?.statusCode;
      responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.Failed, error.message);

      if (error.type == DioErrorType.connectTimeout) {
        // Request timeout
        responseData[ResponseField.code] = ResponseCode.RequestTimeout;
        responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.RequestTimeout, error.message);
      } else if (error.response != null) {
        // Normal response
        response = error.response!;
        if (response.data != null && response.data is Map<String, dynamic>) {
          try {
            responseData[ResponseField.code] = error.response?.data['StatusCode'];
            responseData[ResponseField.message] = error.response?.data['Message'];
          } catch (e) {
            print(e);
          }
        }
      }

      /// Logout
      try {
        if (error.response?.statusCode == ResponseCode.Unauthorized) {
          /// Session timeout
          // BlocManager.homeBloc.add(SessionExpiredEvent()); // todo test
        }
      } catch (e) {
        print(e);
      }
    } catch (error, stacktrace) {
      print(error);
      logger.log(s: 11, m: "Exception occured: $error stackTrace: $stacktrace");
      responseData[ResponseField.code] = ResponseCode.Failed;
      responseData[ResponseField.message] = ApiHelper.getErrorMessage(ResponseCode.Failed, error);
    } finally {
      response.data = responseData;
    }

    return response.data;
  }
}

/// HTTP request-ийн дамжуулах өгөгдлийн төрөл
class DataType {
  static const String Object = 'Object'; // Class model
  static const String Empty = 'Empty';
  static const String Str = 'Str';
  static const String Int = 'Int';
  static const String List = 'List';
}
