import 'dart:convert';
import 'package:habido_app/models/achievements_response.dart';
import 'package:habido_app/models/banners_response.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/content_list_response.dart';
import 'package:habido_app/models/habit_calendar_response.dart';
import 'package:habido_app/models/habit_categories_response.dart';
import 'package:habido_app/models/habit_expense_categories_response.dart';
import 'package:habido_app/models/habit_finance_total_amount_response.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/habit_progress_list_by_date_response.dart';
import 'package:habido_app/models/habit_progress_list_with_date_response.dart';
import 'package:habido_app/models/habit_progress_response.dart';
import 'package:habido_app/models/habit_question_response.dart';
import 'package:habido_app/models/habits_response.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/notif_list_response.dart';
import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/models/psy_test_answers_request.dart';
import 'package:habido_app/models/psy_test_questions_response.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/models/psy_test_results_response.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/models/rank_list_response.dart';
import 'package:habido_app/models/register_device_request.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/sign_up_request.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/models/psy_categories_response.dart';
import 'package:habido_app/models/unread_notif_count_response.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/models/user_data.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_list_response.dart';
import 'package:habido_app/models/user_habits_dates_response.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/models/verify_phone_request.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'api_helper.dart';
import 'http_utils.dart';
import 'http_path.dart';

class ApiManager {
  /// Authentication
  static Future<SignUpResponse> signUp(SignUpRequest request) async {
    return SignUpResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.signUp,
      objectData: request,
      hasAuthorization: false,
    ));
  }

  static Future<BaseResponse> updateProfilePic(UpdateProfilePictureRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.updateProfilePic,
      objectData: request,
      httpMethod: HttpMethod.put,
    ));
  }

  static Future<BaseResponse> updateUserData(UpdateUserDataRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.updateUserData,
      objectData: request,
      httpMethod: HttpMethod.put,
    ));
  }

  static Future<BaseResponse> verifyCode(VerifyCodeRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.verifyCode,
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
      path: HttpPath.signIn,
      headers: headers,
      objectData: request,
    ));
  }

  static Future<BaseResponse> logout() async {
    var res = BaseResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.signout),
    );

    print(res.code);

    return res;
  }

  static Future<UserData> getUserData() async {
    // Check session
    var res = UserData.fromJson(await httpUtils.sendRequest(
      path: HttpPath.checkSession,
      httpMethod: HttpMethod.get,
    ));

    if (res.code == ResponseCode.Success) globals.userData = res;

    return res;
  }

  static Future<BaseResponse> registerDevice(RegisterDeviceRequest request) async {
    var res = BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.registerDevice,
      objectData: request,
    ));

    if (res.code == ResponseCode.Success) {
      SharedPref.setRegisteredPushNotifToken(true);
    }

    return res;
  }

  static Future<BaseResponse> changePassword(ChangePasswordRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.changePassword,
      objectData: request,
    ));
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
        path: HttpPath.param,
        httpMethod: HttpMethod.get,
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
        path: HttpPath.banners,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  /// Chat bot
  static Future<ChatResponse> firstChat(ChatRequest request) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.firstChat,
        objectData: request,
      ),
    );
  }

  static Future<ChatResponse> continueChat(int msgId) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.continueChat + '?msgId=$msgId',
      ),
    );
  }

  static Future<ChatResponse> msgOption(int msgId, int optionId) async {
    return ChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.msgOption + '?msgId=$msgId&optionId=$optionId',
      ),
    );
  }

  /// Content - Blog
  static Future<ContentListResponse> contentList() async {
    return ContentListResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.contentList, httpMethod: HttpMethod.get),
    );
  }

  static Future<Content> content(int contentId) async {
    return Content.fromJson(
      await httpUtils.sendRequest(path: HttpPath.content + '/$contentId', httpMethod: HttpMethod.get),
    );
  }

  /// Psychology test
  static Future<PsyCategoriesResponse> psyCategories() async {
    return PsyCategoriesResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.testCategories, httpMethod: HttpMethod.get),
    );
  }

  static Future<PsyTestsResponse> psyTests(int testCatId) async {
    return PsyTestsResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.categoryTests + '?testCatId=$testCatId', httpMethod: HttpMethod.get),
    );
  }

  static Future<PsyTestQuestionsResponse> psyTestQuestions(int testId) async {
    return PsyTestQuestionsResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.psyTestQuestions + '?testId=$testId'),
    );
  }

  static Future<PsyTestResult> psyTestAnswers(PsyTestAnswersRequest request) async {
    return PsyTestResult.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.psyTestAnswers,
        objectData: request,
      ),
    );
  }

  static Future<PsyTestResultsResponse> psyTestResults() async {
    return PsyTestResultsResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.psyTestResults, httpMethod: HttpMethod.get),
    );
  }

  static Future<HabitCategoriesResponse> habitCategories() async {
    return HabitCategoriesResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.habitCategories, httpMethod: HttpMethod.get),
    );
  }

  static Future<HabitsResponse> habits(int catId) async {
    return HabitsResponse.fromJson(
      await httpUtils.sendRequest(path: HttpPath.habits + '?catId=$catId', httpMethod: HttpMethod.get),
    );
  }

  static Future<BaseResponse> insertUserHabit(UserHabit userHabit) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.insertUserHabit,
        objectData: userHabit,
      ),
    );
  }

  static Future<BaseResponse> updateUserHabit(UserHabit userHabit) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.updateUserHabit,
        objectData: userHabit,
        httpMethod: HttpMethod.put,
      ),
    );
  }

  static Future<UserHabitsDatesResponse> userHabitsByDates(String startDate, String endDate) async {
    return UserHabitsDatesResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.userHabitsByDates + '?startDate=$startDate&endDate=$endDate',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<UserHabitListResponse> userHabitsByDate(String date) async {
    return UserHabitListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.userHabitsByDate + '?date=$date',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitProgressResponse> saveUserHabitProgress(SaveUserHabitProgressRequest request) async {
    return HabitProgressResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.saveUserHabitProgress,
        objectData: request,
      ),
    );
  }

  static Future<HabitProgressListWithDateResponse> habitProgressListWithDate(int userHabitId) async {
    return HabitProgressListWithDateResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitProgressListWithDate + '?userHabitId=$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitProgressListByDateResponse> habitProgressListByDate(HabitProgressListByDateRequest request) async {
    return HabitProgressListByDateResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitProgressListByDate + '?userHabitId=${request.userHabitId}&dateTime=${request.dateTime}',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  // static const String habitExpenseCategories = '/mobile/habit/user-habit/expense-categories';
  // static const String habitFinanceTotalAmount = '/mobile/habit/user-habit/total-amount';

  static Future<HabitExpenseCategoriesResponse> habitExpenseCategories() async {
    return HabitExpenseCategoriesResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitExpenseCategories,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitFinanceTotalAmountResponse> habitFinanceTotalAmount(int userHabitId) async {
    return HabitFinanceTotalAmountResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitFinanceTotalAmount + '?userHabitId=$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitQuestionResponse> habitQuestions(int questionId) async {
    return HabitQuestionResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitQuestion + '?questionId=$questionId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<BaseResponse> addHabitProgress(HabitProgress request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.addHabitProgress,
        objectData: request,
      ),
    );
  }

  static Future<BaseResponse> updateHabitProgress(HabitProgress request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.updateHabitProgress,
        httpMethod: HttpMethod.put,
        objectData: request,
      ),
    );
  }

  static Future<BaseResponse> deleteHabitProgress(int progressId) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.deleteHabitProgress + '/$progressId',
        httpMethod: HttpMethod.delete,
      ),
    );
  }

  static Future<HabitCalendarResponse> calendar(String startDate, String endDate) async {
    return HabitCalendarResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.calendar + '?startDate=$startDate&endDate=$endDate',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<UserHabitListResponse> calendarDate(String date) async {
    return UserHabitListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.calendarDate + '?date=$date',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<UnreadNotifCountResponse> unreadNotifCount() async {
    return UnreadNotifCountResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.unreadNotifCount,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<NotifListResponse> firstNotifs() async {
    return NotifListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.firstNotifs,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<NotifListResponse> nextNotifs(int notifId) async {
    return NotifListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.nextNotifs + '/$notifId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<AchievementsResponse> achievements() async {
    return AchievementsResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.achievements,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<RankListResponse> rankList() async {
    return RankListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.rankList,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<BaseResponse> changePhone(ChangePhoneRequest request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.changePhone,
        httpMethod: HttpMethod.put,
        objectData: request,
      ),
    );
  }

  static Future<BaseResponse> verifyPhone(VerifyPhoneRequest request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.verifyPhone,
        objectData: request,
      ),
    );
  }
}
