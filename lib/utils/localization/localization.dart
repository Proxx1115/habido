import 'dart:async';
import 'package:flutter/material.dart';
import 'localization_helper.dart';

class LocaleKeys {
  static LocaleKeys? of(BuildContext context) {
    return Localizations.of<LocaleKeys>(context, LocaleKeys);
  }

  ///
  /// Global
  ///
  static String longText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis gravida nibh ac ultrices suscipit. Phasellus vel venenatis mauris. Praesent bibendum sed nulla nec imperdiet. Suspendisse potenti. Mauris ullamcorper purus eget velit condimentum, ut cursus ex vehicula. Sed tellus ex, suscipit nec dapibus sed, gravida quis mauris. Sed iaculis odio mi, ut maximus nibh pharetra a. Nunc et maximus orci. Donec eget semper sapien, nec ultricies magna. Maecenas semper feugiat nisi eget bibendum. Pellentesque sed turpis ullamcorper, malesuada justo ut, porta lectus. Integer tristique massa enim. Nam lacinia tempor nibh ac posuere.';

  static const String obscureChar = '*';

  static const String placeHolder = '[placeHolder]';

  static String get appName => 'HabiDo';

  static String get noData => 'Мэдээлэл олдсонгүй';

  static String get errorOccurred => 'Алдаа гарлаа';

  static String get success => 'Амжилттай';

  static String get failed => 'Амжилтгүй';

  static String get no => 'Үгүй';

  static String get yes => 'Тийм';

  static String get ok => 'Ok';

  static String get send => 'Илгээх';

  static String get help => 'Тусламж';

  static String get skip => 'Алгасах';

  static String get next => 'Дараах';

  static String get add => 'Нэмэх';

  static String get edit => 'Засах';

  static String get edit2 => 'Засварлах';

  static String get search => 'Хайх';

  static String get search2 => 'Хайлт';

  static String get continueTxt => 'Үргэлжлүүлэх';

  static String get back => 'Буцах';

  static String get connect => 'Холбох';

  static String get link => 'Холбоос';

  static String get choose => 'Сонгох';

  static String get save => 'Хадгалах';

  static String get detail => 'Дэлгэрэнгүй';

  static String get salary => 'Цалин';

  static String get reminder => 'Санамж';

  static String get status => 'Төлөв';

  static String get day => 'өдөр';

  static String get time => 'Хугацаа';

  static String get other => 'бусад';

  static String get copied => 'Хуулагдлаа';

  static String get write => 'Бичих';

  static String get warning => 'Анхааруулга';

  static String get notice => 'Мэдэгдэл';

  static String get comingSoon => 'Тун удахгүй';

  static String get male => 'Эрэгтэй';

  static String get female => 'Эмэгтэй';

  static String get done => 'Болсон';

  static String get cancel => 'Болих';

  static String get delete => 'Устгах';

  static String get thanks => 'Баярлалаа';

  static String get sureToDelete => 'Устгахдаа итгэлтэй байна уу?';

  static String get selectTime => 'Цаг сонгох';

  static String get today => 'Өнөөдөр';

  static String get tomorrow => 'Маргааш';

  static String get finish => 'Дуусгах';

  static String get notification => 'Мэдэгдэл';

  static String get day2 => 'гараг';

  static String get resendVerifyCode => 'Дахин код авах';

  static String get personalInfo => 'Хувийн мэдээлэл';

  static String get typeSomething => 'Type something...';

  static String get chooseYourQuestion => 'ТА АСУУЛТАА СОНГОНО УУ';

  ///
  /// Intro
  ///
  static String get introTitle1 => 'Дадал';

  static String get introTitle2 => 'Чатбот';

  static String get introTitle3 => 'Зөвлөмж';

  static String get introTitle4 => 'Сэтгэл зүйн тест';

  static List get intro1 => ["Дадлаа хэвшүүлэх, мэдэгдэл авах", "Явцаа хянах", "Өөрийн гаргасан үр дүн, статистикээ харах"];

  static List get intro2 => ["Мэдрэмжээ илэрхийлэх", "Асуудлаа хуваалцах", "Өөрт хэрэгтэй мэдээллийг авах"];

  static List get intro3 => ["Суралцах", "Хөгжих", "Шинжлэх ухаанаар баталгаажсан мэдээлэл авах"];

  static List get intro4 => ["Өөрийгөө илүү таньж мэдэх", "Ойлгох", "Зөвлөмж авах"];

  ///
  /// Login
  ///
  static String get login => 'Нэвтрэх';

  static String get loginWithSocial => 'Сошиал хаягаар нэвтрэх';

  static String get signUpWithSocial => 'Сошиал хаягаар бүртгүүлэх';

  static String get loginWithGoogle => 'Google-ээр нэвтрэх';

  static String get loginWithFb => 'Facebook-ээр нэвтрэх';

  static String get loginWithApple => 'Apple-аар нэвтрэх';

  static String get hasAccount => 'Та бүртгэлтэй юу?';

  static String get hasNotAccount => 'Та бүртгэлгүй юу?';

  static String get signUp => 'Бүртгүүлэх';

  static String get phoneNumber => 'Утасны дугаар эсвэл и-мэйл';

  static String get phone => 'Утас';

  static String get email => 'И-мэйл';

  static String get password => 'Нууц үг';

  static String get haveYouForgottenYourPassword => 'Нууц үг мартсан уу?';

  static String get resetPassword => 'Нууц үг сэргээх';

  static String get recover => 'Сэргээх';

  static String get logout => 'Гарах';

  static String get logoutFromApp => 'Аппликэйшнээс гарах';

  static String get sureToLogout => 'Та гарахдаа итгэлтэй байна уу?';

  static String get pleaseUpdateApp => 'Аппликэйшний шинэ хувилбар гарсан тул та update татна уу.';

  static String get sessionExpired => 'Холболт салсан байна. Дахин нэвтэрнэ үү.';

  static String get oauthWarning => 'Бид бүртгэлийн төрлөө шинэчлэж байгаа тул та дараах сонголтуудаас нэгийг сонгон баталгаажуулна уу';

  ///
  /// Sign up
  ///
  static String get yourRegistration => 'Таны бүртгэл';

  static String get enterPhoneNumber => 'Та өөрийн утасны дугаараа оруулна уу';

  static String get enterCode => 'Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу';

  static String get positive => 'Эерэг';
  static String get negative => 'Сөрөг';
  static String get totalRecorded => 'Нийт бүртгэсэн';

  static String get totalHabits => 'Нийт төлөвлөсөн';
  static String get completedHabits => 'Амжилттай хэвшүүлсэн';
  static String get uncompletedHabits => 'Эхэлсэн ч дуусгаагүй';
  static String get failedHabits => 'Хэрэгжүүлээгүй';

  static String get enterProfile => 'Хувийн мэдээллээ оруулна уу';

  static String get yourName => 'Таны нэр';

  static String get birthDate => 'Төрсөн огноо';

  static String get startDate => 'Хэзээ эхлэх';

  static String get endDate => 'Хэзээ дуусах';

  static String get gender => 'Хүйс';

  static String get iAgree => 'Би зөвшөөрч байна';

  static String get understand => 'Ойлголоо';

  static String get termsOfService => 'Үйлчилгээний нөхцөл';

  static String get readTerms => 'Та үйлчилгээний нөхцөлтэй танилцана уу';

  static String get beginTogether => 'Хамтдаа аяллаа эхлүүлцгээе';

  static String get createPassword => 'Нэвтрэх нууц үг үүсгэнэ үү';

  static String get passwordRepeat => 'Нууц үг давтах';

  static String get passwordsDoesNotMatch => 'Нууц үгээ зөв давтан оруулна уу!';

  static String get passwordsLengthNotValid => 'Нууц үг доод тал нь 8 тэмдэгт байх ёстой!';

  static String get oldPassword => 'Хуучин нууц үг';

  static String get lastName => 'Овог';

  static String get firstName => 'Нэр';

  static String get agreeTermCond1 => 'Хэрэглэгч нь 18 нас хүрээгүй тохиолдолд түүний эцэг, эх, асран хамгаалагч, харгалзан дэмжигч нь ';

  static String get agreeTermCond2 => '"Үйлчилгээний нөхцөл"';

  static String get agreeTermCond3 =>
      '-ийг зөвшөөрсөн тохиолдолд "HabiDo"-г ашиглах эрх нээгдэнэ. Үйлчилгээний нөхцөлийг зөвшөөрсөн эсэхийг баталгаажуулна уу';

  static String get genderInfotext =>
      'HabiDo нь өөрийгөө эрэгтэй, эмэгтэй аль нэг хүйсэнд хамаатуулдаггүй, мөн хоёр ба түүнээс дээш жендерээр мэдэрдэг хүмүүсийг хүндэлдэг бөгөөд хоёр туйлт сонголт тулгаж байгаад уучлал хүсэж байна. Цаашид сайжруулах болохоо мэдэгдье.';

  /// Sign Up Question
  static String get signUpQuest1 => 'Таны хувьд юуг сайжруулмаар  байна вэ?';

  static List<String> get signUpQuest1Answers => [
        'Хувийн хөгжил',
        'Эрүүл мэнд',
        'Гэр бүл',
        'Дасгал хөдөлгөөн',
        'Ажлын бүтээмж',
        'Сэтгэл зүй',
        'Санхүү',
      ];

  static String get signUpQuest2 => 'Тууштай байдлаа хамтдаа үнэлээд нэг үзэх үү?';

  static List<String> get signUpQuest2Answers => [
        'Тууштай байж чаддаггүй',
        'Тийм ч тууштай биш',
        'Хааяадаа л',
        'Ихэнхдээ',
        'Зорьсондоо заавал хүрдэг',
      ];

  static String get signUpQuest3 => 'Мэдрэмж бүртгэх дадлаар аяллаа эхлүүлэх үү? ';

  static String get signUpQuest3Answer =>
      'Хосоороо болзож, хамт өнгөрөөх цаг тогтмол гаргах нь хосын харилцааг илүү ойр дотно болгож, хоорондын ойлголцлыг нэмэгдүүлнэ';

  static String get thanksHabiDo => 'Баярлалаа, HabiDo';

  static String get gonnaTryLater => 'Дараа туршиж үзнэ ээ';

  static String get signUpCompletedText => 'Баяр хүргэе, та HabiDo-тай хамт амьдралын чанараа сайжруулах аяллаа эхлүүллээ';
//
// static String get termCondNotFound => 'Вэб холбоос олдсонгүй';
//
// static String get passwordNew => 'Шинэ нууц үг';

// static String get regNo => 'Регистрийн дугаар';
//

  /// Home
  static String get home => 'Нүүр';

  static String get test => 'Тест';

  static String get habiDo => 'HabiDo';

  // static String get content => 'Контент';

  static String get advice => 'Зөвлөмж';

  static String get profile => 'Профайл';

  static String get myCorner => 'Миний булан';

  static String get hi => 'Сайн уу,';

  static String get shareHowYouFeel => 'Юу мэдэрч байгаагаа хуваалцах уу?';

  static String get wannaShareFeeling => 'Мэдрэмжээ хуваалцах уу?';

  static String get start => 'Эхлэх';

  static String get starting => 'Эхлүүлэх';

  static String get habitAdvice => 'Дадал хэвшүүлэх зөвлөмж';

  static String get habidoTip => 'HabiDo заавар';

  static String get noActivityYet => 'No activity yet';

  /// Habit new version
  static String get seeAllHabits => 'Бүх дадал харах';

  static String get allHabit => 'Бүх дадал';

  static String get active => 'Идэвхтэй';

  static String get completed => 'Дууссан';

  static String get history => 'Түүх';

  static String get habitForYou => 'Танд зориулсан дадал';

  static String get readyToStartNewHabit => 'Дадал хэвшүүлэхэд бэлэн үү?';

  static String get planNewHabit => 'Шинэ дадал төлөвлөх';

  static String get startNewHabit => 'Шинэ дадал эхлүүлэх';

  static String get todaysHabit => 'Өнөөдрийн дадал';

  static String get activeHabitEmpty => 'Өө, идэвхтэй дадал байхгүй байна..';

  static String get completedHabitEmpty => 'Өө, хэрэгжүүлж дууссан дадал байхгүй байна…';

  static String get historyHabitEmpty => 'Өө, түүх байхгүй байна…';

  /// Showcase
  static String get showcaseAddHabit => 'Шинэ дадал үүсгэх';

  static String get showcasePsyTest => 'Сэтгэл зүйн тест бөглөх';

  static String get showcaseAssistant => 'HabiDo чатботтой ярилцаарай';

  static String get showcaseContent => 'Сонирхолтой нийтлэл унших';

  static String get showcaseProfile => 'Өөрийн гүйцэтгэлийг харах';

  static String get showcaseCalendar => 'Сар бүрийн төлөвлөгөө ба амжилтаа хараарай';

  static String get showcaseNotification => 'Сануулга харах';

  static String get showcaseHabitCategory => 'Өөртөө хэвшүүлэхийг хүсэж буй дадлын төрлийг сонгоно';

  static String get showcaseHabit => 'Сонгосон төрлөөс өөрийн хэвшүүлэх дадлыг сонгоно';

  static String get showcaseUserHabit => 'Сонгосон дадлынхаа төлөвлөгөөг гарган хадгална';

  static String get showcaseTimer => 'Тухайн дадлыг хэвшүүлэхдээ бүртгэл хийнэ';

  static String get showcaseSlidable => 'Нүүр хэсгээс өөрийн сонгосон дадлыг цуцлах болон засварлах боломжтой';

  /// Chat
  static String get chatbot => 'Чатбот';

  static String get habidoAssistant => 'HabiDo чатбот';

  static String get chatBotIdNotFound => 'HabiDo туслахын мэдээлэл олдсонгүй';

  /// Content
  static String get readMin => 'минут унших';

  static String get suggestedForYou => 'Танд санал болгох';

  /// Psychology test
  static String get psyTest => 'Сэтгэл зүйн тест';

  static String get myPsyTestResult => 'Миний үр дүн';

  static String get psyTestSuccess => 'Сэтгэл зүйн тест амжилттай';

  static String get psyStatus => 'Сэтгэл зүйн байдал';

  static String get doPsyTest => 'Сэтгэл зүйн тест бөглөх';

  static String get beginTest => 'Тест эхлэх';
  static String get beginTestV2 => 'Тест эхлүүлэх';

  static String get seeResult => 'Үр дүн харах';

  static String get thanksHabido => 'Баярлалаа, HabiDo';

  static String get doTest2 => 'Тест бөглөх';

  static String get psyTestHint1 => 'Та өөрийгөө ямар онцлогтойгоо мэддэг ч бүрэн итгэлгүй байгаа юм биш биз?';

  static String get psyTestHint2 => 'Та өөрийгөө бүрэн хүлээн зөвшөөрч, илүү таньж, алдаа дутагдалтайгаа нүүр тулж, засаж сайжруулж чадна';

  static String get psyTestHint3 => 'Тиймээс сэтгэл зүйн тестийг бөглөөд үзээрэй';

  static String get psyTestHint4 => 'Доорх товчийг дарж сэтгэл зүйн тестээ бөглөөрэй';

  static String get recommendedHabit => 'Танд санал болгож буй дадал';

  /// Habit
  static String get habit => 'Дадал';

  static String get habitName => 'Дадлын нэр';

  static String get createHabit => 'Дадал үүсгэх';

  static String get createNewHabit => 'Шинэ дадал үүсгэх';

  static String get ediHabit => 'Дадал засварлах';

  static String get sureToSkipHabit => 'Энэ удаад алгасах уу?';

  static String get daily => 'Өдөр бүр';

  static String get reflectionsOftheDay => 'Өдрийн эргэцүүлэл';

  static String get weekly => '7 хоног бүр';

  static String get monthly => 'Сар бүр';

  static String get thisMonth => 'Энэ сар';

  static String get mo => 'Да';

  static String get tu => 'Мя';

  static String get we => 'Лх';

  static String get th => 'Пү';

  static String get fr => 'Ба';

  static String get sa => 'Бя';

  static String get su => 'Ня';

  static String get addTime => 'Цаг нэмэх';

  static String get goal => 'Зорилт';

  static String get remind => 'Сануулах';

  static String get remindHabit => 'Дадал сануулах';

  static String get tip => 'Зөвлөмж';

  static String get whyNeed => 'Яагаад хэрэгтэй вэ?';

  static String get monthlyCalendar => 'Сарын төлөвлөгөө';

  static String get pleaseSelectEmoji => 'Та мэдрэмжээ сонгоно уу?';

  /// old emoji
  static String get recapDayEmoji1 => 'Гунигтай байна';

  static String get recapDayEmoji2 => 'Тааламжгүй байна';

  static String get recapDayEmoji3 => 'Юу мэдэрч байгаагаа мэдэхгүй байна';

  static String get recapDayEmoji4 => 'Тайван сайхан байна';

  static String get recapDayEmoji5 => 'Маш их баяртай байна';

  static String get emoji1 => 'Гайхалтай';

  static String get emoji2 => 'Дажгүй шүү';

  static String get emoji3 => 'Мэдэхгүй ээ';

  static String get emoji4 => 'Тааламжгүй';

  static String get emoji5 => 'Онцгүй ээ';

  static String get notNoted => 'Тэмдэглээгүй';

  static String get happyEmoji => 'Баяр хөөртэй';

  static String get frustratedEmoji => 'Бухимдсан';

  static String get surprisedEmoji => 'Гайхширсан';

  static String get lonelyEmoji => 'Ганцаардсан';

  static String get sadEmoji => 'Гунигтай';

  static String get underPressureEmoji => 'Дарамттай';

  static String get unknownEmoji => 'Мэдэхгүй';

  static String get optimisticEmoji => 'Өөдрөг';

  static String get confidentEmoji => 'Өөртөө итгэлтэй';

  static String get worriedEmoji => 'Санаа зовсон';

  static String get panickedEmoji => 'Сандарсан';

  static String get satisfiedEmoji => 'Сэтгэл ханамжтай';

  static String get emotionlessEmoji => 'Сэтгэл хөдлөлгүй';

  static String get calmEmoji => 'Тайван';

  static String get thankfulEmoji => 'Талархсан';

  static String get anxiousEmoji => 'Түгшүүртэй';

  static String get angryEmoji => 'Ууртай';

  static String get lovedEmoji => 'Хайрлагдсан';

  static String get energeticEmoji => 'Эрч хүчтэй';

  static String get tiredEmoji => 'Ядарсан';

  /// NEW

  static String get happyEmoji_new => 'Баяр хөөртэй';

  static String get frustratedEmoji_new => 'Бухимдсан';

  static String get surprisedEmoji_new => 'Гайхширсан';

  static String get lonelyEmoji_new => 'Ганцаардсан';

  static String get sadEmoji_new => 'Гунигтай';

  static String get underPressureEmoji_new => 'Дарамттай';

  static String get unknownEmoji_new => 'Мэдэхгүй';

  static String get optimisticEmoji_new => 'Өөдрөг';

  static String get confidentEmoji_new => 'Өөртөө итгэлтэй';

  static String get worriedEmoji_new => 'Санаа зовсон';

  static String get panickedEmoji_new => 'Сандарсан';

  static String get satisfiedEmoji_new => 'Сэтгэл ханамжтай';

  static String get emotionlessEmoji_new => 'Сэтгэл хөдлөлгүй';

  static String get calmEmoji_new => 'Тайван';

  static String get thankfulEmoji_new => 'Талархсан';

  static String get anxiousEmoji_new => 'Түгшүүртэй';

  static String get angryEmoji_new => 'Ууртай';

  static String get lovedEmoji_new => 'Хайрлагдсан';

  static String get energeticEmoji_new => 'Эрч хүчтэй';

  static String get tiredEmoji_new => 'Ядарсан';

  /// new
  static String get powerfulEmoji_new => 'Эрч хүчтэй';
  static String get encouragingEmoji_new => 'Урам зоригтой';
  static String get relaxedEmoji_new => 'Амарсан';
  static String get proudEmoji_new => 'Бахархсан';

  ///

  static String get note => 'Тэмдэглэл';

  static String get seeAllNote => 'Бүх тэмдэглэл харах';

  static String get writeNote => 'Тэмдэглэл хөтлөх';

  static String get writeConclusion => 'Дүгнэлт бичих';

  static String get totalSavings => 'Нийт хуримтлал';

  static String get totalExpense => 'Нийт зардал';

  static String get expense => 'Зардал';

  static String get total => 'Нийт';

  static String get addSavings => 'Хуримтлал нэмэх';

  static String get editSavings => 'Хуримтлал засварлах';

  static String get editExpense => 'Зардал засварлах';

  static String get addExpense => 'Зардал нэмэх';

  static String get enterAmount => 'Мөнгөн дүн оруулах';

  static String get congratulations => 'Танд баяр хүргэе';

  static String get pleaseSelectCategory => 'Ангилал сонгоно уу';

  static String get selectCategory => 'Ангилал сонгох';

  static String get selectMeasure => 'Хэмжигдэхүүн сонгох';

  static String get breatheTake => 'Хамраараа амьсгал авах';

  static String get breatheHold => 'Амьсгал түгжих';

  static String get breatheExhale => 'Амаараа амьсгал гаргах';

  // static String get evaluation => 'Үнэлгээ';

  static String get howAreYouFeeling => 'Та хэр сэтгэл ханамжтай байна бэ?';

  static String get feelingAtTheTime => 'Сэтгэл санаа хэр байна даа?';

  static String get pleasing => 'Тааламжтай';

  static String get notPleasing => 'Тааламжгүй';

  static String get addNew => 'Шинээр нэмэх';

  static String get newPsyTest => 'Шинэ';

  static String get toEvaluate => 'Үнэлгээ өгөх';

  static String get pickColor => 'Өнгө сонгох';

  static String get pickShape => 'Дүрс сонгох';

  static String get validate12 => 'Уучлаарай, 12-оос доош насны хүн бүртгүүлэх боломжгүй';

  static String get validate12UserProfile => 'Уучлаарай, 12-оос доош насруу өөрчлөх боломжгүй!';

  static String get pleaseEnterStartDate => 'Эхлэх огноо сонгоно уу';

  static String get pleaseEnterEndDate => 'Дуусах огноо сонгоно уу';

  static String get pleaseSelectGoal => 'Зорилго сонгоно уу';

  static String get answerOneOfThoseQuestion => 'Асуултуудаас нэгийг сонгон хариулаарай';

  /// User Habit Detail
  static String get execution => 'Гүйцэтгэл';

  static String get totalPlans => 'Нийт төлөвлөгөөт';

  static String get completedPlans => 'Амжилттай гүйцэтгэсэн';

  static String get skipPlans => 'Алгассан';

  static String get uncompletedPlans => 'Хэрэгжүүлээгүй';

  static String get giveUp => 'Бууж өгөх';

  /// Feeling
  static String get howsYourDay => 'Өнөөдөр хэрхэн өнгөрч байна даа?';

  static String get whatCausesThisFeeling => 'Энэ мэдрэмж юунаас болоод үүсэж байна вэ?';

  static String get shareFeelingMore => 'Мэдрэмжээ дэлгэрэнгүй хуваалцвал';
  static String get tyForSharingFeeling => 'Сэтгэл зүйдээ анхаарсан танд баярлалаа.';

  /// Feeling Causes
  static String get family => 'Гэр бүл';
  static String get relationship => 'Хосын харилцаа';
  static String get children => 'Хүүхэд';
  static String get friends => 'Найз нөхөд';
  static String get work => 'Ажил';
  static String get school => 'Сургууль, хичээл';
  static String get health => 'Эрүүл мэнд';
  static String get mentalHealth => 'Сэтгэл зүй';
  static String get sleep => 'Нойр';
  static String get mySelf => 'Өөрөөсөө болж';
  static String get finance => 'Санхүү';

  static String get feelingDetailIntro => 'Мэдрэмжээ илэрхийлэн бичих нь өөрийгөө хөндлөнгөөс анзаарахад тустай шүү';
  static String get feelingDetailHint => 'Би өнөөдөр...';

  /// Profile

  static String get performance => 'Үзүүлэлт';

  static String get moodCalendarInfo =>
      'Өдрийн мэдрэмжийн ерөнхий төлвийг тухайн өдөр тэмдэглэсэн нийт мэдрэмжийн дундажаар тооцоолж, өнгөөр ялган харуулж байгаа юм. Мэдрэмжийн календарын өнгө тод ногооноос бүдэг ногоон руу уусах бөгөөд, эерэг мэдрэмжийг (Гайхалтай) хамгийн тод өнгөөр, сөрөг мэдрэмжийг(Онцгүй) бүдэг өнгөөр илэрхийлж, бусад мэдрэмжүүдийг (Дажгүй, Мэдэхгүй, Тааламжгүй) өнгийн уусалттайгаар илэрхийлж байгаа.';

  static String get badge => 'Тэмдэг';

  static String get ability => 'Чадвар';

  static String get myProcess => 'Миний явц';

  static String get myFeeling => 'Миний мэдрэмж';

  static String get allTime => 'Бүх цаг үе';

  static String get progress => 'Үйлдэл';

  static String get completedHabit => 'Хэвшсэн дадал';

  static String get completedHabit2 => 'Хэвшүүлж буй дадал';

  static String get completedHabit3 => 'Хэвшүүлсэн дадал';

  static String get myAchievements => 'Миний амжилт';

  static String get userInfo => 'Хэрэглэгчийн мэдээлэл';

  static String get yourRank => 'Таны зэрэглэл';

  static String get changePassword => 'Нууц үг солих';

  static String get pleaseEnterVerifyCode => 'Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу';

  static String get biometricAuth => 'Царай/хурууны хээ ашиглан нэвтрэх';

  static String get biometricFailed => 'Биометрээр нэвтрэх үйлдэл амжилтгүй боллоо. Дахин оролдоно уу';

  static String get changePhoneNumber => 'Утасны дугаар солих';

  static String get changeEmailNumber => 'И-мэйл хаяг солих';

  static String get pleaseSelectPicture => 'Зургаа сонгоно уу';

  static String get camera => 'Камер';

  static String get gallery => 'Зургийн сан';

  static String get feedback => 'Санал хүсэлт';

  static String get feedbackHint => 'HabiDo-тай холбоотой санал, сэтгэгдлээ бидэнд илгээгээрэй';

  static String get faq => 'Түгээмэл асуулт, хариулт';
}

class FlutterBlocLocalizationsDelegate extends LocalizationsDelegate<LocaleKeys> {
  @override
  Future<LocaleKeys> load(Locale locale) => Future(() => LocaleKeys());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) => locale.languageCode.toLowerCase().contains(LanguageCode.en);
}
