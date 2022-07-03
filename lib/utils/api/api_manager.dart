import 'dart:convert';
import 'package:habido_app/models/achievements_response.dart';
import 'package:habido_app/models/active_habit_response.dart';
import 'package:habido_app/models/addOauth.dart';
import 'package:habido_app/models/advice_video_response.dart';
import 'package:habido_app/models/badge_response.dart';
import 'package:habido_app/models/banners_response.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/habit_total_amount_by_date_request.dart';
import 'package:habido_app/models/mood_tracker_monthly_stat_response.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/models/chat_history_response.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chatbots_response.dart';
import 'package:habido_app/models/completed_habit_response.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/content_list_response.dart';
import 'package:habido_app/models/content_list_response_v2.dart';
import 'package:habido_app/models/content_tags_response.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/feedback_category_list_response.dart';
import 'package:habido_app/models/forgot_password_change_request.dart';
import 'package:habido_app/models/forgot_password_request.dart';
import 'package:habido_app/models/forgot_password_response.dart';
import 'package:habido_app/models/habit_calendar_response.dart';
import 'package:habido_app/models/habit_categories_response.dart';
import 'package:habido_app/models/habit_expense_categories_response.dart';
import 'package:habido_app/models/habit_finance_total_amount_response.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/habit_progress_list_by_date_response.dart';
import 'package:habido_app/models/habit_progress_list_with_date_response.dart';
import 'package:habido_app/models/mood_tracker_latest_response.dart';
import 'package:habido_app/models/mood_tracker_last_list.dart';
import 'package:habido_app/models/mood_tracker_list_response.dart';
import 'package:habido_app/models/history_habit_response.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/models/oauthResponse.dart';
import 'package:habido_app/models/profile_habit_count.dart';
import 'package:habido_app/models/psy_test_response_v2.dart';
import 'package:habido_app/models/psy_test_results_response2.dart';
import 'package:habido_app/models/psy_test_review.dart';
import 'package:habido_app/models/send_feedback_request.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/models/tip%20category.dart';
import 'package:habido_app/models/skill_list_response.dart';
import 'package:habido_app/models/tip_response.dart';
import 'package:habido_app/models/test_info_result_response.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/models/user_habit_progress_log.dart';
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
import 'package:habido_app/models/rank_list_response.dart';
import 'package:habido_app/models/user_device.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/sign_up_phone_request.dart';
import 'package:habido_app/models/sign_up_phone_response.dart';
import 'package:habido_app/models/psy_categories_response.dart';
import 'package:habido_app/models/sign_up_verify_code_request.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/models/unread_notif_count_response.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/models/user_data.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_list_response.dart';
import 'package:habido_app/models/user_habit_response.dart';
import 'package:habido_app/models/user_habits_dates_response.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/models/verify_phone_request.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_history_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option_request.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'api_helper.dart';
import 'http_utils.dart';
import 'http_path.dart';

class ApiManager {
  /// Authentication
  static Future<SignUpPhoneResponse> signUpPhone(
      SignUpPhoneRequest request) async {
    return SignUpPhoneResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.signUpPhone,
      objectData: request,
      hasAuthorization: false,
    ));
  }

  static Future<BaseResponse> signUpVerifyCode(
      SignUpVerifyCodeRequest request) async {
    var res = BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.signUpVerifyCode,
      objectData: request,
      hasAuthorization: false,
    ));

    print('test');

    return res;
  }

  static Future<BaseResponse> signUpRegister(
      SignUpRegisterRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.signUpRegister,
      objectData: request,
      hasAuthorization: false,
    ));
  }

  static Future<LoginResponse> login(LoginRequest request) async {
    Map<String, String> headers =
        ApiHelper.getHttpHeaders(hasAuthorization: false);
    headers.addAll(
      {
        "authorization": 'Basic ' +
            base64Encode(utf8.encode('${request.username}:${request.password}'))
      },
    );

    return LoginResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.signIn,
      headers: headers,
      objectData: request,
    ));
  }

  static Future<BaseResponse> addOauth(AddOauth request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.addOauth,
      objectData: request,
    ));
  }

  static Future<OAuthResponse> userOauth2(AddOauth request) async {
    return OAuthResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.userOauth2,
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

  static Future<BaseResponse> insertDeviceInfo(UserDevice userDevice) async {
    var res = BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.insertDevice,
      objectData: userDevice,
    ));

    if (res.code == ResponseCode.Success) {
      SharedPref.setPushNotifTokenRegistered(true);
    }

    return res;
  }

  static Future<BaseResponse> updateUserDevice(UserDevice userDevice) async {
    var res = BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.updateDevice,
      objectData: userDevice,
      httpMethod: HttpMethod.put,
    ));

    return res;
  }

  static Future<UserDevice> getUserDevice(String deviceId) async {
    var res = UserDevice.fromJson(await httpUtils.sendRequest(
      path: HttpPath.getDevice + '?deviceId=$deviceId',
      httpMethod: HttpMethod.get,
    ));

    return res;
  }

  static Future<BaseResponse> changePassword(
      ChangePasswordRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.changePassword,
      objectData: request,
    ));
  }

  /// User
  static Future<BaseResponse> updateProfilePic(
      UpdateProfilePictureRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.updateProfilePic,
      objectData: request,
      httpMethod: HttpMethod.put,
    ));
  }

  static Future<BaseResponse> updateUserData(
      UpdateUserDataRequest request) async {
    return BaseResponse.fromJson(await httpUtils.sendRequest(
      path: HttpPath.updateUserData,
      objectData: request,
      httpMethod: HttpMethod.put,
    ));
  }

  /// Profile New
  static Future<MoodTrackerMonthlyReasonResponse> monthlyReason(
      int year, int month) async {
    return MoodTrackerMonthlyReasonResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.monthlyReason + '?year=$year&month=$month',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<MoodTrackerLatestResponse> moodTrackerLatest() async {
    return MoodTrackerLatestResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.moodTrackerLatest, httpMethod: HttpMethod.get),
    );
  }

  static Future<MoodTrackerLatestResponse> moodTrackerThen(
      int userFeelingId) async {
    return MoodTrackerLatestResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.moodTrackerThen + '/$userFeelingId',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<MoodTrackerMonthlyStatResponse> moodTrackerMonthlyStat(
      int year, int month) async {
    return MoodTrackerMonthlyStatResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.monthlyStat + '?year=$year&month=$month',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<BadgeListResponse> badgeList() async {
    return BadgeListResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.badgeList, httpMethod: HttpMethod.get),
    );
  }

  static Future<ProfileHabitCount> profileHabitCount() async {
    return ProfileHabitCount.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.profileHabitCount, httpMethod: HttpMethod.get),
    );
  }

  static Future<SkillListResponse> skillList() async {
    return SkillListResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.habitSkillList, httpMethod: HttpMethod.get),
    );
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
  static Future<ChatbotsResponse> chatbots() async {
    return ChatbotsResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.chatbots,
        httpMethod: HttpMethod.get,
      ),
    );
  }

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

  static Future<ChatHistoryResponse> chatHistory(int cbId) async {
    return ChatHistoryResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.userChats + '?cbId=$cbId',
        httpMethod: HttpMethod.get,
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

  // cb chat bot service
  // ----------------------------------
  /// Chat bot
  static Future<CBChatBotsResponse> cbChatbots() async {
    return CBChatBotsResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.cbChatBots,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<CBChatResponse> cbFirstChat(ChatRequest request) async {
    return CBChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.cbFirstChat,
        objectData: request,
      ),
    );
  }

  static Future<CBChatResponse> cbContinueChat(int msgId) async {
    return CBChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.cbContinueChat + '?msgId=$msgId',
      ),
    );
  }

  static Future<CBChatHistoryResponse> cbChatHistory(int pid, int psize) async {
    return CBChatHistoryResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.cbUserChats + '?pid=$pid&psize=$psize',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<CBChatResponse> cbMsgOption(CBMsgOptionRequest request) async {
    return CBChatResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.cbMsgOption,
        objectData: request,
      ),
    );
  }
  // ----------------------------------

  /// Content - Blog
  static Future<ContentListResponse> contentList() async {
    return ContentListResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.contentList, httpMethod: HttpMethod.get),
    );
  }

  static Future<Content> content(int contentId) async {
    return Content.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.content + '/$contentId', httpMethod: HttpMethod.get),
    );
  }

  /// Psychology test List
  static Future<PsyTestsV2Response> psyTestList() async {
    return PsyTestsV2Response.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTests, httpMethod: HttpMethod.get),
    );
  }

  static Future<TestInfoResultResponse> psyTest(int testId) async {
    return TestInfoResultResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTest + '/$testId', httpMethod: HttpMethod.get),
    );
  }

  /// PSY TEST REVIEW
  static Future<BaseResponse> psyTestReview(PsyTestReview request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTestReview, objectData: request),
    );
  }

  /// Content - Blog V2
  static Future<ContentListResponseV2> highLightedContentList() async {
    return ContentListResponseV2.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.highLightedContentList, httpMethod: HttpMethod.get),
    );
  }

  static Future<ContentV2> contentV2(int contentId) async {
    return ContentV2.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.content + '/$contentId', httpMethod: HttpMethod.get),
    );
  }

  static Future<ContentTagsResponse> contentTags() async {
    return ContentTagsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.contentTags, httpMethod: HttpMethod.get),
    );
  }

  static Future<ContentListResponseV2> contentFilter(
      String name, int pid, int pSize) async {
    return ContentListResponseV2.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.contentFilter + '?Name=$name&Pid=$pid&Psize=$pSize',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<ContentListResponseV2> contentFirst(
      String name, String searchText) async {
    return ContentListResponseV2.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.contentFirst + '?name=$name&searchText=$searchText',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<ContentListResponseV2> contentThen(
      String name, String searchText, int contentId) async {
    return ContentListResponseV2.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.contentThen +
              '?name=$name&searchText=$searchText&contentId=$contentId',
          httpMethod: HttpMethod.get),
    );
  }

  /// Content Like
  static Future<BaseResponse> contentLike(int contentId) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.contentLike + '?contentId=$contentId',
      ),
    );
  }

  /// Psychology test
  static Future<PsyCategoriesResponse> psyCategories() async {
    return PsyCategoriesResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.testCategories, httpMethod: HttpMethod.get),
    );
  }

  static Future<PsyTestsResponse> psyTests(int testCatId) async {
    return PsyTestsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.categoryTests + '?testCatId=$testCatId',
          httpMethod: HttpMethod.get),
    );
  }

  static Future<PsyTestQuestionsResponse> psyTestQuestions(int testId) async {
    return PsyTestQuestionsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTestQuestions + '?testId=$testId'),
    );
  }

  static Future<PsyTestResult> psyTestAnswers(
      PsyTestAnswersRequest request) async {
    return PsyTestResult.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.psyTestAnswers,
        objectData: request,
      ),
    );
  }

  static Future<PsyTestResultsResponse> psyTestResults() async {
    return PsyTestResultsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTestResults, httpMethod: HttpMethod.get),
    );
  }

  static Future<PsyUserTestResultsResponse> psyTestUserResults() async {
    return PsyUserTestResultsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.psyTestUserResults, httpMethod: HttpMethod.get),
    );
  }

  static Future<HabitCategoriesResponse> habitCategories() async {
    return HabitCategoriesResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.habitCategories, httpMethod: HttpMethod.get),
    );
  }

  static Future<CustomHabitSettingsResponse> dynamicHabitSettings() async {
    return CustomHabitSettingsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.dynamicHabitSettings, httpMethod: HttpMethod.get),
    );
  }

  static Future<HabitsResponse> habits(int catId) async {
    return HabitsResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.habits + '?catId=$catId', httpMethod: HttpMethod.get),
    );
  }

  static Future<UserHabitResponse> insertUserHabit(UserHabit userHabit) async {
    return UserHabitResponse.fromJson(
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

  static Future<BaseResponse> deleteUserHabit(int userHabitId) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.deleteUserHabit + '/$userHabitId',
        httpMethod: HttpMethod.delete,
      ),
    );
  }

  static Future<UserHabitsDatesResponse> userHabitsByDates(
      String startDate, String endDate) async {
    return UserHabitsDatesResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.userHabitsByDates +
            '?startDate=$startDate&endDate=$endDate',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<BaseResponse> skipUserHabit(
      SkipUserHabitRequest request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
          path: HttpPath.skipUserHabit, objectData: request),
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

  static Future<HabitProgressResponse> saveUserHabitProgress(
      SaveUserHabitProgressRequest request) async {
    return HabitProgressResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.saveUserHabitProgress,
        objectData: request,
      ),
    );
  }

  static Future<HabitProgressListWithDateResponse> habitProgressListWithDate(
      int userHabitId) async {
    return HabitProgressListWithDateResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitProgressListWithDate + '?userHabitId=$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitProgressListByDateResponse> habitProgressListByDate(
      HabitProgressListByDateRequest request) async {
    return HabitProgressListByDateResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitProgressListByDate +
            '?userHabitId=${request.userHabitId}&dateTime=${request.dateTime}',
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

  static Future<HabitFinanceTotalAmountResponse> habitFinanceTotalAmount(
      int userHabitId) async {
    return HabitFinanceTotalAmountResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitFinanceTotalAmount + '?userHabitId=$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HabitFinanceTotalAmountResponse> habitFinanceTotalAmountByDate(
      HabitTotalAmountByDateRequest request) async {
    return HabitFinanceTotalAmountResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.habitFinanceTotalAmountByDate +
            '?userHabitId=${request.userHabitId}&startDate=${request.startDate}&lastDate=${request.lastDate}',
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

  static Future<HabitCalendarResponse> calendar(
      String startDate, String endDate) async {
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

  static Future<BaseResponse> readAllNotif() async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.readAllNotif,
        httpMethod: HttpMethod.put,
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

  static Future<BaseResponse> DeleteNotif(int notifId) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.deleteNotif + '/$notifId',
        httpMethod: HttpMethod.delete,
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

  static Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordRequest request) async {
    return ForgotPasswordResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.forgotPassword,
        objectData: request,
      ),
    );
  }

  static Future<ForgotPasswordResponse> forgotPasswordChange(
      ForgotPasswordChangeRequest request) async {
    return ForgotPasswordResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.forgotPasswordChange,
        objectData: request,
      ),
    );
  }

  static Future<UserHabitProgressLog> getHabitProgressLog(
      int userHabitId) async {
    return UserHabitProgressLog.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.getHabitProgressLog + '/$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<BaseResponse> updateHabitProgressLog(
      UserHabitProgressLog habitProgressLog) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.updateHabitProgressLog,
        objectData: habitProgressLog,
      ),
    );
  }

  /// new
  static Future<UserHabitPlanCount> getUserHabitPlanCount(
      int userHabitId) async {
    return UserHabitPlanCount.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.userHabitPlanCount + '/$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<BaseResponse> sendFeedback(SendFeedbackRequest request) async {
    return BaseResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.sendFeedback,
        objectData: request,
      ),
    );
  }

  static Future<FeedBackCategoryListResponse> feedBackCategories() async {
    return FeedBackCategoryListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.feedBackCatList,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  /// Home
  static Future<MoodTrackerListResponse> getMoodTracker() async {
    return MoodTrackerListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.moodTrackerList,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<MoodTrackerLastListResponse> getMoodTrackerLast() async {
    return MoodTrackerLastListResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.moodTrackerLast,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<AdviceVideoResponse> getAdviceVideo() async {
    return AdviceVideoResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.adviceVideo,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<TipResponse> getTips() async {
    return TipResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.tips,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<TipCategory> getTipById(int categoryTipId) async {
    return TipCategory.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.tip + '/$categoryTipId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  /// All Habits
  static Future<ActiveHabitResponse> getActiveHabitFirst() async {
    return ActiveHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.activeHabitFirst,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<ActiveHabitResponse> getActiveHabitThen(int userHabitId) async {
    return ActiveHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.activeHabitThen + '/$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<CompletedHabitResponse> getCompletedHabitFirst() async {
    return CompletedHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.completedHabitFirst,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<ActiveHabitResponse> getCompletedHabitThen(
      int userHabitId) async {
    return ActiveHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.completedHabitThen + '/$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<HistoryHabitResponse> getHistoryHabitFirst() async {
    return HistoryHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.historyHabitFirst,
        httpMethod: HttpMethod.get,
      ),
    );
  }

  static Future<ActiveHabitResponse> getHistoryHabitThen(
      int userHabitId) async {
    return ActiveHabitResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.historyHabitThen + '/$userHabitId',
        httpMethod: HttpMethod.get,
      ),
    );
  }

  /// Mood Tracker
  static Future<MoodTrackerQuestionResponse> getMoodTrackerQuestion() async {
    return MoodTrackerQuestionResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.moodTrackerQuestions,
      ),
    );
  }

  static Future<MoodTrackerQuestionResponse> saveMoodTracker(
      MoodTrackerSaveRequest answer) async {
    return MoodTrackerQuestionResponse.fromJson(
      await httpUtils.sendRequest(
        path: HttpPath.moodTrackerSave,
        objectData: answer,
      ),
    );
  }

  // static Future<BaseResponse> updsateUserDevice(UserDevice userDevice) async {
  //   var res = BaseResponse.fromJson(await httpUtils.sendRequest(
  //     path: HttpPath.updateDevice,
  //     objectData: userDevice,
  //     httpMethod: HttpMethod.put,
  //   ));

  //   return res;
  // }
}
