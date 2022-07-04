class HttpPath {
  static const String signIn = '/auth/user/signin';
  static const String signout = '/mobile/signout';
  static const String checkSession = '/mobile/check-session';
  static const String signUpPhone = '/auth/user/signup';
  static const String signUpVerifyCode = '/auth/user/verify-code';
  static const String signUpRegister = '/auth/user/register';
  static const String changePassword = '/mobile/change/pass';
  static const String updateProfilePic = '/mobile/change/user-photo';
  static const String updateUserData = '/mobile/change/user-info';
  static const String monthlyReason = '/mobile/mood-tracker/monthly-reason';
  static const String moodTrackerLatest = '/mobile/mood-tracker/latest';
  static const String moodTrackerThen = '/mobile/mood-tracker/then';
  static const String monthlyStat = '/mobile/mood-tracker/monthly-stat';
  static const String badgeList = '/mobile/badge/list';
  static const String profileHabitCount = '/mobile/user-habit/count';
  static const String habitSkillList = '/mobile/skill/list';

  static const String param = '/auth/param';
  static const String getDevice = '/mobile/user-device';
  static const String insertDevice = '/register-device';
  static const String updateDevice = '/mobile/user-device';
  static const String chatbots = '/mobile/chatbots';
  static const String firstChat = '/mobile/first-chat';
  static const String continueChat = '/mobile/continue-chat';
  static const String userChats = '/mobile/user-chats';
  static const String msgOption = '/mobile/msg-option';
  static const String banners = '/mobile/banners';
  static const String testCategories = '/mobile/test-categories';
  static const String categoryTests = '/mobile/category-tests';
  static const String contentList = '/mobile/content/list';
  static const String highLightedContentList =
      '/mobile/highlighted-content/list';
  static const String contentTags = '/mobile/content/tags';

  static const String content = '/mobile/content';
  static const String psyTests = '/mobile/tests';
  static const String psyTest = '/mobile/test';
  static const String psyTestReview = '/mobile/test/review';

  static const String contentFilter = '/mobile/content/filter';
  static const String contentFirst = '/mobile/content/first';
  static const String contentThen = '/mobile/content/then';
  static const String contentLike = '/mobile/content/like';

  static const String psyTestQuestions = '/mobile/start/user-test';
  static const String psyTestAnswers = '/mobile/end/user-test';
  static const String psyTestResults = '/mobile/category/user-tests';
  static const String psyTestUserResults = '/mobile/user-tests';
  static const String habitCategories = '/mobile/habit/categories';
  static const String habits = '/mobile/habit/habits';
  static const String habitDateUserHabits = '/mobile/habit/date/user-habits';
  static const String habitCalendar = '/mobile/habit/calendar';
  static const String insertUserHabit = '/mobile/habit/user-habit';
  static const String updateUserHabit = '/mobile/habit/user-habit';
  static const String deleteUserHabit = '/mobile/habit/user-habit';
  static const String userHabitsByDate = '/mobile/habit/date/user-habits';
  static const String userHabitsByDates = '/mobile/habit/dates/user-habits';
  static const String skipUserHabit = '/mobile/skip-habit';
  static const String saveUserHabitProgress = '/mobile/habit/save-progress';
  static const String habitProgressListWithDate = '/mobile/habit/user-habit/progresses';
  static const String habitProgressListByDate = '/mobile/habit/user-habit/date/progress';
  static const String habitExpenseCategories = '/mobile/habit/user-habit/expense-categories';
  static const String habitFinanceTotalAmount = '/mobile/habit/user-habit/total-amount';
  static const String habitFinanceTotalAmountByDate = '/mobile/habit/user-habit/date/total-amount';
  static const String habitFeelingPieChart = '/mobile/details/feeling-pie-chart';
  static const String habitQuestion = '/mobile/habit/questions';
  static const String addHabitProgress =
      '/mobile/habit/user-habit/plan/progress';
  static const String updateHabitProgress =
      '/mobile/habit/user-habit/plan/progress';
  static const String deleteHabitProgress =
      '/mobile/habit/user-habit/plan/progress';
  static const String calendar = '/mobile/habit/calendar';
  static const String calendarDate = '/mobile/habit/date/user-habits';
  static const String unreadNotifCount = '/mobile/notifs/not-read';
  static const String readAllNotif = '/mobile/notifs/read-all';
  static const String firstNotifs = '/mobile/notifs/first';
  static const String nextNotifs = '/mobile/notifs/then';
  static const String deleteNotif = 'mobile/notifs/delete';
  static const String achievements = '/mobile/user/accomplishments';
  static const String rankList = '/mobile/rank/list';
  static const String changePhone = '/mobile/change/phone';
  static const String verifyPhone = '/mobile/verify/phone';
  static const String forgotPassword = '/auth/user/forgot-pass';
  static const String forgotPasswordChange = '/auth/user/change-pass';
  static const String dynamicHabitSettings = '/mobile/habit/settings';
  static const String getHabitProgressLog = '/mobile/user-habit/progress/log';
  static const String updateHabitProgressLog =
      '/mobile/user-habit/progress/log';
  static const String userHabitPlanCount = '/mobile/user-habit/plan/count';
  static const String sendFeedback = '/mobile/feed-back';
  static const String feedBackCatList = '/mobile/feed-back/categories';

  static const String cbChatBots = '/mobile/cb/chat-bots';
  static const String cbFirstChat = '/mobile/cb/first-chat';
  static const String cbContinueChat = '/mobile/cb/continue-chat';
  static const String cbMsgOption = '/mobile/cb/msg-option';
  static const String cbUserChats = '/mobile/cb/user-chats';

  static const String moodTrackerList = '/mobile/mood-tracker/list';
  static const String moodTrackerLast = '/mobile/mood-tracker/latest';
  static const String adviceVideo = '/mobile/advice-video';
  static const String tips = '/mobile/tips';
  static const String createHabit = '/mobile/habit';
  static const String tip = '/mobile/tip';

  /// All Habits
  static const String activeHabitFirst = '/mobile/user-habit/ongoing/first';
  static const String activeHabitThen = '/mobile/user-habit/ongoing/then';

  static const String completedHabitFirst = '/mobile/user-habit/over/first';
  static const String completedHabitThen = '/mobile/user-habit/over/then';

  static const String historyHabitFirst = '/mobile/user-habit/over/first';
  static const String historyHabitThen = '/mobile/user-habit/ongoing/then';

  /// Mood Tracker
  static const String moodTrackerQuestions = '/mobile/mood-tracker/start';
  static const String moodTrackerSave = '/mobile/mood-tracker/save';
}
