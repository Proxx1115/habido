import 'package:flutter/material.dart';
import 'package:habido_app/ui/auth/forgot_password/forgot_password_change_route.dart';
import 'package:habido_app/ui/auth/forgot_password/forgot_password_route.dart';
import 'package:habido_app/ui/auth/login_intro_route.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/ui/auth/login_route_2.dart';
import 'package:habido_app/ui/auth/personal_info.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up3_profile_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up1_phone_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up2_code_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up4_password_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up5_terms_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up6_success_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up_completed.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up_question_route.dart';
import 'package:habido_app/ui/auth/sign_up/sign_up_route.dart';
import 'package:habido_app/ui/auth/sign_up/term_detail_route.dart';
import 'package:habido_app/ui/auth/forgot_password/verify_password_route.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_poster_view.dart';
import 'package:habido_app/ui/chat/habido_assistant_route.dart';
import 'package:habido_app/ui/content/content_route.dart';
import 'package:habido_app/ui/content_v2/content_route_v2.dart';
import 'package:habido_app/ui/feeling/feeling_cause_route.dart';
import 'package:habido_app/ui/feeling/feeling_detail_route.dart';
import 'package:habido_app/ui/feeling/feeling_emoji_route.dart';
import 'package:habido_app/ui/feeling/feeling_main_route.dart';
import 'package:habido_app/ui/feeling/feeling_success_route.dart';
import 'package:habido_app/ui/global/coming_soon_route.dart';
import 'package:habido_app/ui/habit/habit_success_route.dart';
import 'package:habido_app/ui/habit/calendar/calendar_route.dart';
import 'package:habido_app/ui/habit/habit_list/habit_list_route.dart';
import 'package:habido_app/ui/habit/progress/habit_breath/habit_breath_route.dart';
import 'package:habido_app/ui/habit/progress/habit_feeling/habit_feeling_route.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/habit_finance_route.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/habit_finance_statement_route.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/total_expense_route.dart';
import 'package:habido_app/ui/habit/progress/habit_satisfaction/habit_satisfaction_route.dart';
import 'package:habido_app/ui/habit/progress/habit_timer/habit_timer_route.dart';
import 'package:habido_app/ui/habit/progress/habit_tree/habit_tree_route.dart';
import 'package:habido_app/ui/habit/progress/habit_water/habit_water_route.dart';
import 'package:habido_app/ui/habit/user_habit/user_habit_route.dart';
import 'package:habido_app/ui/habit_new/all_habits_route.dart';
import 'package:habido_app/ui/habit_new/habit_categories_v2/habit_categories_route_v2.dart';
import 'package:habido_app/ui/habit_new/habit_detail/feeling_note_list_route.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_income.dart';
import 'package:habido_app/ui/habit_new/habit_detail/satisfaction_note_list_route.dart';
import 'package:habido_app/ui/habit_new/habit_success_new_route.dart';
import 'package:habido_app/ui/habit_new/progress/habit_feeling/habit_feeling_answer_route_v2.dart';
import 'package:habido_app/ui/habit_new/user_habit_v2/user_habit_route_v2.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_count.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_expense.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_feeling.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_minute.dart';
import 'package:habido_app/ui/habit_new/habit_detail/habit_detail_with_satisfaction.dart';
import 'package:habido_app/ui/home/home_route.dart';
import 'package:habido_app/ui/home_new/advice_route_screen.dart';
import 'package:habido_app/ui/home_new/home_route.dart';
import 'package:habido_app/ui/home_new/tip_route/tip_route.dart';
import 'package:habido_app/ui/intro/intro_route.dart';
import 'package:habido_app/ui/notification/notification_route.dart';
import 'package:habido_app/ui/notification/notification_route_new.dart';
import 'package:habido_app/ui/profile/change_password_route.dart';
import 'package:habido_app/ui/profile/change_phone/bonus_point.dart';
import 'package:habido_app/ui/profile/change_phone/change_phone_route.dart';
import 'package:habido_app/ui/profile/change_phone/change_email_route.dart';
import 'package:habido_app/ui/profile/change_phone/verify_phone_route.dart';
import 'package:habido_app/ui/profile/faq_route.dart';
import 'package:habido_app/ui/profile/feedback_cat_list.dart';
import 'package:habido_app/ui/profile/feedback_route.dart';
import 'package:habido_app/ui/profile/help_route.dart';
import 'package:habido_app/ui/profile/terms_route.dart';
import 'package:habido_app/ui/profile/your_rank_route.dart';
import 'package:habido_app/ui/profile_v2/help_screen/faq_route_v2.dart';
import 'package:habido_app/ui/profile_v2/help_screen/feedback_route_v2.dart';
import 'package:habido_app/ui/profile_v2/help_screen/help_route_v2.dart';
import 'package:habido_app/ui/profile_v2/performance/sensitivityNotes.dart';
import 'package:habido_app/ui/profile_v2/profile_dashboard_v2.dart';
import 'package:habido_app/ui/profile_v2/user_info/UserInfoRouteNew.dart';
import 'package:habido_app/ui/psy_test/psy_categories/psy_categories_route.dart';
import 'package:habido_app/ui/psy_test/psy_intro_route.dart';
import 'package:habido_app/ui/psy_test/psy_test/psy_test_route.dart';
import 'package:habido_app/ui/psy_test/psy_test_result_route.dart';
import 'package:habido_app/ui/psy_test/psy_tests/psy_tests_route.dart';
import 'package:habido_app/ui/psy_test_v2/psy_intro_result_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_result_route_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_dashboard_v2/psy_test_dashboard_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_screen_v2/psy_test_route_v2.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'route_transitions.dart';

class Routes {
  Routes() : routeObserver = RouteObserver<PageRoute>();

  /// Route Observer
  final RouteObserver<PageRoute> routeObserver;

  /// Route list
  static const comingSoon = 'comingSoon';
  static const splash = 'splash';
  static const intro = 'intro';
  static const loginIntro = '/loginIntro';
  static const login = '/login';
  static const login2 = '/login2';
  static const personalInfo = '/personalInfo';
  static const forgotPass = 'forgotPass';
  static const verifyPassword = 'verifyPassword';
  static const forgotPassChange = 'forgotPassChange';
  static const changePass = 'changePass';
  static const signUp = 'signUp';
  static const signUp1Phone = 'signUp1Phone';
  static const signUp2Code = 'signUp2Code';
  static const signUp3Profile = 'signUp3Profile';
  static const signUp4Password = 'signUp4Password';
  static const signUp5Terms = 'signUp4Terms';
  static const signUpQuestion = 'signUpQuestion';
  static const signUpCompleted = 'signUpCompleted';
  static const signUp6Success = 'signUp5Success';
  static const termDetail = 'termDetail';
  static const home = 'home';
  static const home_new = 'home_new';
  static const advice = 'advice';
  static const tip = 'tip';
  static const calendar = 'calendar';
  static const content = 'content';
  static const contentV2 = 'contentV2';

  static const habidoAssistant = 'habidoAssistant';
  static const changePhone = 'changePhone';
  static const changeEmail = 'changeEmail';
  static const verifyPhone = 'verifyPhone';
  static const psyTestsIntroResult = 'psyTestsIntroResult';
  static const psyCategories = 'psyCategories';
  static const psyTests = 'psyTests';
  static const testV2 = 'testV2';

  static const psyIntro = 'psyIntro';
  static const psyTest = 'psyTest';
  static const psyTestV2 = 'psyTestV2';

  static const psyTestResult = 'psyTestResult';
  static const psyTestResultV2 = 'psyTestResultV2';

  static const habitCategories = 'habitCategories';
  static const habitList = 'habitList';
  static const userHabit = 'userHabit';
  static const habitTimer = 'habitTimer';
  static const habitFeeling = 'habitFeeling';
  static const habitFeelingAnswer = 'habitFeelingAnswer';
  static const habitWater = 'habitWater';
  static const habitSatisfaction = 'habitSatisfaction';
  static const habitBreath = 'habitBreath';
  static const habitTree = 'habitTree';
  static const habitFinance = 'habitFinance';
  static const habitFinanceStmt = 'habitFinanceStmt';
  static const habitTotalExpense = 'habitTotalExpense';
  static const feelingMain = 'feelingMain';
  static const feelingEmoji = 'feelingEmoji';
  static const feelingCause = 'feelingCause';
  static const feelingDetail = 'feelingDetail';
  static const feelingSuccess = 'feelingSuccess';
  static const notif = 'notif';
  static const profile = 'profile';

  /// userHabit
  static const allHabits = 'allHabits';
  static const habitDetailWithMinute = 'habitDetailWithMinute';
  static const habitDetailWithCount = 'habitDetailWithCount';
  static const habitDetailWithExpense = 'habitDetailWithExpense';
  static const habitDetailWithIncome = 'habitDetailWithIncome';
  static const habitDetailWithFeeling = 'habitDetailWithFeeling';
  static const habitDetailWithSatisfaction = 'habitDetailWithSatisfaction';
  static const feelingNotes = 'feelingNotes';
  static const satisfactionNotes = 'satisfactionNotes';

  static const userInfo = 'userInfo';
  static const sensitivityNotes = 'sensitivityNotes';
  static const psyTestList = 'psyTestList';
  static const yourRank = 'yourRank';
  static const habitSuccess = 'habitSuccess';
  static const habitSuccessNew = 'habitSuccessNew';
  static const help = 'help';
  static const helpV2 = 'helpV2';
  static const feedback = 'feedback';
  static const feedbackV2 = 'feedbackV2';
  static const feedbackCatList = 'feedbackCatList';
  static const faq = 'faq';
  static const faqV2 = 'faqV2';
  static const terms = 'terms';
  static const bonusPoint = 'bonusPoint';
  static const posterView = 'posterView';

  /// Routing
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Route<dynamic> route;

    switch (settings.name) {
      case Routes.splash:
        route = NoTransitionRoute(IntroRoute(), settings);
        break;

      case Routes.intro:
        route = FadeRouteBuilder(IntroRoute(), settings);
        break;

      case Routes.loginIntro:
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1600),
          pageBuilder: (_, __, ___) => LoginIntroRoute(),
        );
        break;

      case Routes.login:
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1600),
          pageBuilder: (_, __, ___) => LoginRoute(),
        );
        break;

      case Routes.login2:
        route = SlideRightRouteBuilder(LoginRoute2(), settings);
        break;

      case Routes.personalInfo:
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1600),
          pageBuilder: (_, __, ___) => PersonalInfo(),
        );
        break;

      case Routes.signUp:
        route = SlideRightRouteBuilder(SignUpRoute(), settings);
        break;

      case Routes.signUp1Phone:
        route = SlideRightRouteBuilder(SignUp1PhoneRoute(), settings);
        break;

      case Routes.signUp2Code:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp2CodeRoute(
            signUpRegisterRequest: _getValueByKey(args, 'signUpRegisterRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp3Profile:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp3ProfileRoute(
            signUpRegisterRequest: _getValueByKey(args, 'signUpRegisterRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp4Password:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp4PasswordRoute(
            signUpRegisterRequest: _getValueByKey(args, 'signUpRegisterRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp5Terms:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp5TermsRoute(
            signUpRegisterRequest: _getValueByKey(args, 'signUpRegisterRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUpQuestion:
        route = FadeRouteBuilder(SignUpQuestionRoute(), settings);
        break;

      case Routes.signUpCompleted:
        route = FadeRouteBuilder(SignUpCompletedRoute(), settings);
        break;

      case Routes.signUp6Success:
        var args = settings.arguments as Map;
        route = FadeRouteBuilder(
          SignUp6SuccessRoute(
            verifyCodeRequest: _getValueByKey(args, 'signUpRegisterRequest'),
          ),
          settings,
        );
        break;

      case Routes.termDetail:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          TermDetailRoute(
            termsOfService: _getValueByKey(args, 'termsOfService'),
          ),
          settings,
        );
        break;

      case Routes.forgotPass:
        route = SlideRightRouteBuilder(ForgotPasswordRoute(), settings);
        break;

      case Routes.verifyPassword:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          VerifyPasswordRoute(
            phoneNumber: _getValueByKey(args, 'phoneNumber'),
            userId: _getValueByKey(args, 'userId'),
          ),
          settings,
        );
        break;

      case Routes.forgotPassChange:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          ForgotPasswordChangeRoute(
            userId: _getValueByKey(args, 'userId'),
            phoneNumber: _getValueByKey(args, 'phoneNumber'),
            code: _getValueByKey(args, 'code'),
          ),
          settings,
        );
        break;

      case Routes.changePass:
        route = SlideRightRouteBuilder(ChangePasswordRoute(), settings);
        break;

      case Routes.home:
        route = FadeRouteBuilder(HomeRoute(), settings);
        break;

      case Routes.home_new:
        var args;
        if (settings.arguments != null) args = settings.arguments as Map;
        route = FadeRouteBuilder(
            HomeRouteNew(
              initialIndex: _getValueByKey(args, 'initialIndex') ?? 2,
            ),
            settings);
        break;

      case Routes.advice:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          AdviceRoute(
            adviceVideo: _getValueByKey(args, 'adviceVideo'),
          ),
          settings,
        );
        break;

      case Routes.tip:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            TipRoute(
              tipCategoryId: _getValueByKey(args, 'tipCategoryId'),
              categoryName: _getValueByKey(args, 'categoryName'),
            ),
            settings);
        break;

      case Routes.calendar:
        route = FadeRouteBuilder(CalendarRoute(), settings);
        break;

      case Routes.habidoAssistant:
        route = FadeRouteBuilder(HabidoAssistantRoute(), settings);
        break;

      case Routes.changePhone:
        route = SlideRightRouteBuilder(ChangePhoneRoute(), settings);
        break;

      case Routes.changeEmail:
        route = SlideRightRouteBuilder(ChangeEmailRoute(), settings);
        break;

      case Routes.verifyPhone:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          VerifyPhoneRoute(
            phoneNumber: _getValueByKey(args, 'phoneNumber'),
          ),
          settings,
        );
        break;

      case Routes.psyTestsIntroResult:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            PsyIntroResultV2(
              test: _getValueByKey(args, 'test'),
            ),
            settings);
        break;

      case Routes.testV2:
        route = SlideRightRouteBuilder(PsyTestRouteV2(), settings);
        break;

      case Routes.psyCategories:
        route = SlideBottomRouteBuilder(PsyCategoriesRoute(), settings);
        break;

      case Routes.psyTests:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyTestsRoute(
            psyCategory: _getValueByKey(args, 'psyCategory'),
          ),
          settings,
        );
        break;

      case Routes.psyIntro:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyIntroRoute(
            psyTest: _getValueByKey(args, 'psyTest'),
          ),
          settings,
        );
        break;

      case Routes.psyTest:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyTestRoute(
            psyTest: _getValueByKey(args, 'psyTest'),
          ),
          settings,
        );
        break;

      // case Routes.psyTestV2:
      //   var args = settings.arguments as Map;
      //   route = SlideRightRouteBuilder(
      //     PsyTestRoute(
      //       testInfo: _getValueByKey(args, 'psyTest'),
      //     ),
      //     settings,
      //   );
      //   break;

      case Routes.psyTestResult:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyTestResultRoute(
            psyTestResult: _getValueByKey(args, 'psyTestResult'),
          ),
          settings,
        );
        break;

      case Routes.psyTestResultV2:
        var args = settings.arguments as Map;

        route = SlideRightRouteBuilder(
          // PsyTestResultRoute(
          //   psyTestResult: _getValueByKey(args, 'psyTestResult'),
          // ),
          PsyTestResultRouteV2(
            isActiveAppBar: true,
            testName: _getValueByKey(args, 'testName'),
            testId: _getValueByKey(args, 'testId'),
            testResult: _getValueByKey(args, 'testResult'),
          ),
          settings,
        );
        break;

      case Routes.content:
        var args = settings.arguments as Map;
        var routeBuilder = _getValueByKey(args, 'routeBuilder');
        if (routeBuilder == 'SlideRightRouteBuilder') {
          route = SlideRightRouteBuilder(
            ContentRoute(
              content: _getValueByKey(args, 'content'),
            ),
            settings,
          );
        } else {
          route = PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (_, __, ___) => ContentRoute(
              content: _getValueByKey(args, 'content'),
            ),
          );
        }

        break;

      case Routes.contentV2:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            ContentRouteV2(
              contentId: _getValueByKey(args, 'contentId'),
            ),
            settings);
        break;

      case Routes.habitCategories:
        route = SharedPref.getShowcaseHasShown(ShowcaseKeyName.habitCategory)
            ? SlideRightRouteBuilder(HabitCategoriesRouteV2(), settings)
            : FadeRouteBuilder(HabitCategoriesRouteV2(), settings);
        break;

      case Routes.habitList:
        var args = settings.arguments as Map;
        route = SharedPref.getShowcaseHasShown(ShowcaseKeyName.habit)
            ? SlideRightRouteBuilder(
                HabitListRoute(
                  habitCategory: _getValueByKey(args, 'habitCategory'),
                ),
                settings,
              )
            : FadeRouteBuilder(
                HabitListRoute(
                  habitCategory: _getValueByKey(args, 'habitCategory'),
                ),
                settings,
              );
        break;

      case Routes.allHabits:
        route = SlideRightRouteBuilder(AllHabitsRoute(), settings);
        break;

      /// UserHabit Detail
      case Routes.habitDetailWithMinute:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithMinuteRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.habitDetailWithCount:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithCountRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.habitDetailWithExpense:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithExpenseRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.habitDetailWithIncome:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithIncomeRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.habitDetailWithFeeling:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithFeelingRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.habitDetailWithSatisfaction:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            HabitDetailWithSatisfactionRoute(
              userHabit: _getValueByKey(args, 'userHabit'),
              isActive: _getValueByKey(args, 'isActive'),
              refreshHabits: _getValueByKey(args, 'refreshHabits'),
            ),
            settings);
        break;

      case Routes.feelingNotes:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            FeelingNoteListRoute(
              userHabitId: _getValueByKey(args, 'userHabitId'),
            ),
            settings);
        break;

      case Routes.satisfactionNotes:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            SatisfactionNoteListRoute(
              userHabitId: _getValueByKey(args, 'userHabitId'),
            ),
            settings);
        break;

      /// ~~~~~~~~~~~~~~
      case Routes.userHabit:
        var args = settings.arguments as Map;
        route = SharedPref.getShowcaseHasShown(ShowcaseKeyName.userHabit)
            ? SlideRightRouteBuilder(
                UserHabitRouteV2(
                  screenMode: _getValueByKey(args, 'screenMode'),
                  title: _getValueByKey(args, 'title'),
                  habit: _getValueByKey(args, 'habit'),
                  userHabit: _getValueByKey(args, 'userHabit'),
                  habitTemplate: _getValueByKey(args, 'habitTemplate'),
                  habitId: _getValueByKey(args, 'habitId'),
                  customHabitSettings: _getValueByKey(args, 'customHabitSettings'),
                ),
                settings,
              )
            : FadeRouteBuilder(
                UserHabitRouteV2(
                  screenMode: _getValueByKey(args, 'screenMode'),
                  title: _getValueByKey(args, 'title'),
                  habit: _getValueByKey(args, 'habit'),
                  userHabit: _getValueByKey(args, 'userHabit'),
                  habitTemplate: _getValueByKey(args, 'habitTemplate'),
                  habitId: _getValueByKey(args, 'habitId'),
                  customHabitSettings: _getValueByKey(args, 'customHabitSettings'),
                ),
                settings,
              );
        break;

      case Routes.habitTimer:
        var args = settings.arguments as Map;
        route = SharedPref.getShowcaseHasShown(ShowcaseKeyName.timer)
            ? SlideRightRouteBuilder(
                HabitTimerRoute(
                  userHabit: _getValueByKey(args, 'userHabit'),
                  callBack: _getValueByKey(args, 'callBack'),
                ),
                settings,
              )
            : FadeRouteBuilder(
                HabitTimerRoute(
                  userHabit: _getValueByKey(args, 'userHabit'),
                  callBack: _getValueByKey(args, 'callBack'),
                ),
                settings,
              );
        break;

      case Routes.habitFeeling:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFeelingRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitFeelingAnswer:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFeelingAnswerRouteV2(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitWater:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitWaterRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitSatisfaction:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitSatisfactionRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitBreath:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitBreathRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitTree:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitTreeRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitFinance:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFinanceRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            isActive: _getValueByKey(args, 'isActive'),
            refreshHabits: _getValueByKey(args, 'refreshHabits'),
            callBack: _getValueByKey(args, 'callBack'),
          ),
          settings,
        );
        break;

      case Routes.habitFinanceStmt:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFinanceStatementRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.habitTotalExpense:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitTotalExpenseRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
            isActive: _getValueByKey(args, 'isActive'),
            refreshHabits: _getValueByKey(args, 'refreshHabits'),
          ),
          settings,
        );
        break;

      case Routes.feelingMain:
        route = SlideRightRouteBuilder(FeelingMainRoute(), settings);
        break;

      case Routes.feelingEmoji:
        dynamic args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            FeelingEmojiRoute(
              moodTrackerQuestionResponse: _getValueByKey(args, 'moodTrackerQuestionResponse'),
              selectedFeelingData: _getValueByKey(args, 'selectedFeelingData'),
            ),
            settings);
        break;

      case Routes.psyTestResult:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyTestResultRoute(
            psyTestResult: _getValueByKey(args, 'psyTestResult'),
          ),
          settings,
        );
        break;

      case Routes.feelingCause:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            FeelingCauseRoute(
              selectedFeelingData: _getValueByKey(args, 'selectedFeelingData'),
              moodTrackerQuestionResponse: _getValueByKey(args, 'moodTrackerQuestionResponse'),
            ),
            settings);
        break;

      case Routes.feelingDetail:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            FeelingDetailRoute(
              selectedFeelingData: _getValueByKey(args, 'selectedFeelingData'),
              selectedCauses: _getValueByKey(args, 'selectedCauses'),
              moodTrackerQuestionResponse: _getValueByKey(args, 'moodTrackerQuestionResponse'),
            ),
            settings);
        break;

      case Routes.feelingSuccess:
        var args = settings.arguments as Map;
        route = NoTransitionRoute(
          FeelingSuccessRoute(
            callback: _getValueByKey(args, 'callback'),
          ),
          settings,
        );
        break;

      case Routes.notif:
        route = SlideRightRouteBuilder(NotificationRouteNew(), settings);
        break;

      case Routes.profile:
        route = SlideRightRouteBuilder(ProfileScreenV2(), settings);
        break;

      case Routes.userInfo:
        route = SlideRightRouteBuilder(UserInfoRouteNew(), settings);
        break;

      case Routes.psyTestList:
        route = SlideRightRouteBuilder(PsyTestDashboardV2(), settings);
        break;

      case Routes.yourRank:
        route = SlideRightRouteBuilder(YourRankRoute(), settings);
        break;

      case Routes.habitSuccess:
        var args = settings.arguments as Map;
        route = NoTransitionRoute(
          HabitSuccessRoute(
            habitProgressResponse: _getValueByKey(args, 'habitProgressResponse'),
            primaryColor: _getValueByKey(args, 'primaryColor'),
            callback: _getValueByKey(args, 'callback'),
          ),
          settings,
        );
        break;

      case Routes.habitSuccessNew:
        var args = settings.arguments as Map;
        route = NoTransitionRoute(
          HabitSuccessRouteNew(
            callback: _getValueByKey(args, 'callback'),
          ),
          settings,
        );
        break;

      case Routes.help:
        route = SlideRightRouteBuilder(HelpRoute(), settings);
        break;

      case Routes.helpV2:
        route = SlideRightRouteBuilder(HelpRouteV2(), settings);
        break;

      case Routes.feedback:
        route = SlideRightRouteBuilder(FeedbackRoute(), settings);
        break;

      case Routes.feedbackV2:
        route = SlideRightRouteBuilder(FeedbackRouteV2(), settings);
        break;

      case Routes.sensitivityNotes:
        route = SlideRightRouteBuilder(SensitivityNotes(), settings);
        break;

      case Routes.feedbackCatList:
        route = SlideRightRouteBuilder(FeedBackCategoryListRoute(), settings);
        break;

      case Routes.faq:
        route = SlideRightRouteBuilder(FaqRoute(), settings);
        break;

      case Routes.faqV2:
        route = SlideRightRouteBuilder(FaqRouteV2(), settings);
        break;

      case Routes.terms:
        route = SlideRightRouteBuilder(TermsRoute(), settings);
        break;

      case Routes.posterView:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
            PosterView(
              posters: _getValueByKey(args, 'posters'),
              currentIndex: _getValueByKey(args, 'currentIndex'),
            ),
            settings);
        break;

      case Routes.bonusPoint:
        route = SlideRightRouteBuilder(BonusPointRoute(), settings);
        break;
      case Routes.comingSoon:
      default:
        route = NoTransitionRoute(ComingSoonRoute(), settings);
        break;
    }

    return route;
  }

  _getValueByKey(Map<dynamic, dynamic>? args, String key) {
    try {
      return args != null ? args[key] : null;
    } catch (e) {
      print(e);
    }

    return null;
  }
}
