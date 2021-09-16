import 'package:flutter/material.dart';
import 'package:habido_app/ui/auth/forgot_pass_route.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/ui/auth/sign_up3_profile_route.dart';
import 'package:habido_app/ui/auth/sign_up1_phone_route.dart';
import 'package:habido_app/ui/auth/sign_up2_code_route.dart';
import 'package:habido_app/ui/auth/sign_up4_terms_route.dart';
import 'package:habido_app/ui/auth/sign_up5_success_route.dart';
import 'package:habido_app/ui/auth/term_detail_route.dart';
import 'package:habido_app/ui/chat/habido_assistant_route.dart';
import 'package:habido_app/ui/content/content_route.dart';
import 'package:habido_app/ui/global/coming_soon_route.dart';
import 'package:habido_app/ui/habit/habit_success_route.dart';
import 'package:habido_app/ui/habit/calendar/calendar_route.dart';
import 'package:habido_app/ui/habit/habit_categories/habit_categories_route.dart';
import 'package:habido_app/ui/habit/habit_list/habit_list_route.dart';
import 'package:habido_app/ui/habit/progress/habit_feeling/habit_feeling_route.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/habit_finance_route.dart';
import 'package:habido_app/ui/habit/progress/habit_satisfaction/habit_satisfaction_route.dart';
import 'package:habido_app/ui/habit/progress/habit_timer/habit_timer_route.dart';
import 'package:habido_app/ui/habit/progress/habit_water/habit_water_route.dart';
import 'package:habido_app/ui/habit/user_habit/user_habit_route.dart';
import 'package:habido_app/ui/home/home_route.dart';
import 'package:habido_app/ui/intro/intro_route.dart';
import 'package:habido_app/ui/notification/notif_route.dart';
import 'package:habido_app/ui/profile/your_rank_route.dart';
import 'package:habido_app/ui/profile/user_info_route.dart';
import 'package:habido_app/ui/psy_test/psy_categories/psy_categories_route.dart';
import 'package:habido_app/ui/psy_test/psy_intro_route.dart';
import 'package:habido_app/ui/psy_test/psy_test/psy_test_route.dart';
import 'package:habido_app/ui/psy_test/psy_test_result_route.dart';
import 'package:habido_app/ui/psy_test/psy_tests/psy_tests_route.dart';
import 'route_transitions.dart';

class Routes {
  Routes() : routeObserver = RouteObserver<PageRoute>();

  /// Route Observer
  final RouteObserver<PageRoute> routeObserver;

  /// Route list
  static const comingSoon = 'comingSoon';
  static const splash = 'splash';
  static const intro = 'intro';
  static const login = '/login';
  static const forgotPass = 'forgotPass';
  static const signUp1Phone = 'signUp1Phone';
  static const signUp2Code = 'signUp2Code';
  static const signUp3Profile = 'signUp3Profile';
  static const signUp4Terms = 'signUp4Terms';
  static const signUp5Success = 'signUp5Success';
  static const termDetail = 'termDetail';
  static const home = 'home';
  static const calendar = 'calendar';
  static const content = 'content';
  static const habidoAssistant = 'habidoAssistant';
  static const psyCategories = 'psyCategories';
  static const psyTests = 'psyTests';
  static const psyIntro = 'psyIntro';
  static const psyTest = 'psyTest';
  static const psyTestResult = 'psyTestResult';
  static const habitCategories = 'habitCategories';
  static const habitList = 'habitList';
  static const userHabit = 'userHabit';
  static const habitTimer = 'habitTimer';
  static const habitFeeling = 'habitFeeling';
  static const habitWater = 'habitWater';
  static const habitSatisfaction = 'habitSatisfaction';
  static const habitFinance = 'habitFinance';
  static const notif = 'notif';
  static const userInfo = 'userInfo';
  static const yourRank = 'yourRank';
  static const habitSuccess = 'habitSuccess';

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

      case Routes.login:
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1600),
          pageBuilder: (_, __, ___) => LoginRoute(),
        );
        break;

      case Routes.signUp1Phone:
        route = SlideRightRouteBuilder(SignUp1PhoneRoute(), settings);
        break;

      case Routes.signUp2Code:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp2CodeRoute(
            verifyCodeRequest: _getValueByKey(args, 'verifyCodeRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp3Profile:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp3ProfileRoute(
            verifyCodeRequest: _getValueByKey(args, 'verifyCodeRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp4Terms:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          SignUp4TermsRoute(
            verifyCodeRequest: _getValueByKey(args, 'verifyCodeRequest'),
          ),
          settings,
        );
        break;

      case Routes.signUp5Success:
        var args = settings.arguments as Map;
        route = FadeRouteBuilder(
          SignUp5SuccessRoute(
            verifyCodeRequest: _getValueByKey(args, 'verifyCodeRequest'),
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
        route = SlideRightRouteBuilder(ForgotPassRoute(), settings);
        break;

      case Routes.home:
        route = FadeRouteBuilder(HomeRoute(), settings);
        break;

      case Routes.calendar:
        route = FadeRouteBuilder(CalendarRoute(), settings);
        break;

      case Routes.habidoAssistant:
        route = FadeRouteBuilder(HabidoAssistantRoute(), settings);
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

      case Routes.psyTestResult:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          PsyTestResultRoute(
            psyTestResult: _getValueByKey(args, 'psyTestResult'),
          ),
          settings,
        );
        break;

      case Routes.content:
        var args = settings.arguments as Map;
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => ContentRoute(
            content: _getValueByKey(args, 'content'),
          ),
        );
        break;

      case Routes.habitCategories:
        route = SlideBottomRouteBuilder(HabitCategoriesRoute(), settings);
        break;

      case Routes.habitList:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitListRoute(
            habitCategory: _getValueByKey(args, 'habitCategory'),
          ),
          settings,
        );
        break;

      case Routes.userHabit:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          UserHabitRoute(
            title: _getValueByKey(args, 'title'),
            habit: _getValueByKey(args, 'habit'),
          ),
          settings,
        );
        break;

      case Routes.habitTimer:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitTimerRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.habitFeeling:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFeelingRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.habitWater:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitWaterRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.habitSatisfaction:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitSatisfactionRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.habitFinance:
        var args = settings.arguments as Map;
        route = SlideRightRouteBuilder(
          HabitFinanceRoute(
            userHabit: _getValueByKey(args, 'userHabit'),
          ),
          settings,
        );
        break;

      case Routes.notif:
        route = SlideRightRouteBuilder(NotifRoute(), settings);
        break;

      case Routes.userInfo:
        route = SlideRightRouteBuilder(UserInfoRoute(), settings);
        break;

      case Routes.yourRank:
        route = SlideRightRouteBuilder(YourRankRoute(), settings);
        break;

      case Routes.habitSuccess:
        var args = settings.arguments as Map;
        route = SlideBottomRouteBuilder(
          HabitSuccessRoute(
            title: _getValueByKey(args, 'title'),
            text: _getValueByKey(args, 'text'),
            primaryColor: _getValueByKey(args, 'primaryColor'),
            callback: _getValueByKey(args, 'callback'),
          ),
          settings,
        );

        break;

      case Routes.comingSoon:
      default:
        route = NoTransitionRoute(ComingSoonRoute(), settings);
        break;
    }

    return route;
  }

  _getValueByKey(Map<dynamic, dynamic> args, String key) {
    try {
      return args[key];
    } catch (e) {
      print(e);
    }

    return null;
  }
}
