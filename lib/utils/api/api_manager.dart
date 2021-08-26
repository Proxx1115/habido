import 'dart:convert';
import 'package:habido_app/models/banners_response.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/category_tests_response.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/content_list_response.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/models/psy_test_answers_request.dart';
import 'package:habido_app/models/psy_test_questions_response.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/models/register_device_request.dart';
import 'package:habido_app/models/sign_up_request.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/models/psy_categories_response.dart';
import 'package:habido_app/models/user_data.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'api_helper.dart';
import 'http_utils.dart';
import 'api_routes.dart';

class ApiManager {
  /// Authentication
  static Future<SignUpResponse> signUp(SignUpRequest request) async {
    return SignUpResponse.fromJson(await httpUtils.sendRequest(
      path: ApiRoutes.signUp,
      objectData: request,
      hasAuthorization: false,
    ));
  }

  static Future<BaseResponse> verifyCode(VerifyCodeRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: ApiRoutes.verifyCode,
      objectData: request,
      hasAuthorization: false,
    ));
  }

  static Future<LoginResponse> login(LoginRequest request) async {
    Map<String, String> headers = ApiHelper.getHttpHeaders(hasAuthorization: false);
    headers.addAll(
      {"authorization": 'Basic ' + base64Encode(utf8.encode('${request.username}:${request.password}'))},
    );

    return LoginResponse.fromJson(await httpUtils.sendRequest(
      path: ApiRoutes.signIn,
      headers: headers,
      objectData: request,
    ));
  }

  static Future<BaseResponse> logout() async {
    var res = BaseResponse.fromJson(
      await httpUtils.sendRequest(path: ApiRoutes.signout),
    );

    print(res.code);

    return res;
  }

  static Future<UserData> getUserData() async {
    // Check session
    var res = UserData.fromJson(await httpUtils.sendRequest(
      path: ApiRoutes.checkSession,
      httpMethod: HttpMethod.Get,
    ));

    if (res.code == ResponseCode.Success) globals.userData = res;

    return res;
  }

  static Future<BaseResponse> registerDevice(RegisterDeviceRequest request) async {
    var res = BaseResponse.fromJson(await httpUtils.sendRequest(
      path: ApiRoutes.registerDevice,
      objectData: request,
    ));

    if (res.code == ResponseCode.Success) {
      SharedPref.setRegisteredPushNotifToken(true);
    }

    return res;
  }

  /// Param
  static Future<ParamResponse> param({
    bool fromCache = true,
  }) async {
    var res = ParamResponse()
      ..code = ResponseCode.Failed
      ..message = LocaleKeys.failed;

    if (fromCache && globals.param != null) {
      res = globals.param!;
    } else {
      res = ParamResponse.fromJson(await httpUtils.sendRequest(
        path: ApiRoutes.param,
        httpMethod: HttpMethod.Get,
        hasAuthorization: false,
      ));
    }

    if (res.code == ResponseCode.Success) {
      globals.param = res;
    }

    return res;
  }

  static Future<CustomBannersResponse> banners() async {
    return CustomBannersResponse.fromJson(
      await httpUtils.sendRequest(
        path: ApiRoutes.banners,
        httpMethod: HttpMethod.Get,
      ),
    );
  }

  /// Chat bot
  static Future<ChatResponse> firstChat(ChatRequest request) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: ApiRoutes.firstChat,
        objectData: request,
      ),
    );
  }

  static Future<ChatResponse> continueChat(int msgId) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: ApiRoutes.continueChat + '?msgId=$msgId',
      ),
    );
  }

  static Future<ChatResponse> msgOption(int msgId, int optionId) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: ApiRoutes.msgOption + '?msgId=$msgId&optionId=$optionId',
      ),
    );
  }

  /// Psychology test
  static Future<PsyCategoriesResponse> psyCategories() async {
    return PsyCategoriesResponse.fromJson(
      await httpUtils.sendRequest(path: ApiRoutes.testCategories, httpMethod: HttpMethod.Get),
    );
  }

  static Future<PsyTestsResponse> psyTests(int testCatId) async {
    return PsyTestsResponse.fromJson(
      await httpUtils.sendRequest(path: ApiRoutes.categoryTests + '?testCatId=$testCatId', httpMethod: HttpMethod.Get),
    );
  }

  static Future<PsyTestQuestionsResponse> psyTestQuestions(int testId) async {
    return PsyTestQuestionsResponse.fromJson(
      await httpUtils.sendRequest(path: ApiRoutes.psyTestQuestions + '?testId=$testId'),
    );
  }

  static Future<PsyTestResult> psyTestAnswers(PsyTestAnswersRequest request) async {
    return PsyTestResult.fromJson(
      await httpUtils.sendRequest(
        path: ApiRoutes.psyTestAnswers,
        objectData: request,
      ),
    );
  }

  /// Content - Blog
  static Future<ContentListResponse> contentList() async {
    return ContentListResponse.fromJson(
      await httpUtils.sendRequest(path: ApiRoutes.contentList, httpMethod: HttpMethod.Get),
    );
  }
}
