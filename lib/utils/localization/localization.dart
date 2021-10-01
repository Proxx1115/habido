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

  static String get noData => 'Мэдээлэл олдсонгүй.';

  static String get errorOccurred => 'Алдаа гарлаа.';

  static String get success => 'Амжилттай';

  static String get failed => 'Амжилтгүй';

  static String get no => 'Үгүй';

  static String get yes => 'Тийм';

  static String get ok => 'Ok';

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

  static String get day => 'Хоног';

  static String get term => 'Хугацаа';

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

  ///
  /// Intro
  ///
  static String get introTitle1 => 'Happy';

  static String get introTitle2 => 'Habit';

  static String get introTitle3 => 'Do';

  static String get intro1 => 'Дадлаа тууштай бүртгэж     ';

  static String get intro2 => 'Сэтгэл зүйгээ удирдаж      ';

  static String get intro3 => 'Надтай хамт тасралтгүй хөгж';

  ///
  /// Login
  ///
  static String get login => 'Нэвтрэх';

  static String get hasAccount => 'Та бүртгэлтэй юу?';

  static String get signUp => 'Бүртгүүлэх';

  static String get phoneNumber => 'Утасны дугаар';

  static String get password => 'Нууц үг';

  static String get haveYouForgottenYourPassword => 'Нууц үг мартсан уу?';

  static String get resetPassword => 'Нууц үг сэргээх';

  static String get recover => 'Сэргээх';

  static String get logout => 'Гарах';

  static String get sureToLogout => 'Та гарахдаа итгэлтэй байна уу?';

  static String get sessionExpired => 'Холболт салсан байна. Дахин нэвтэрнэ үү.';

  ///
  /// Sign up
  ///
  static String get yourRegistration => 'Таны бүртгэл';

  static String get enterPhoneNumber => 'Та өөрийн утасны дугаараа оруулна уу.';

  static String get enterCode => 'Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу.';

  static String get enterProfile => 'Хувийн мэдээллээ оруулна уу.';

  static String get yourName => 'Таны нэр';

  static String get birthDate => 'Төрсөн огноо';

  static String get startDate => 'Эхлэх огноо';

  static String get endDate => 'Дуусах огноо';

  static String get gender => 'Хүйс';

  static String get iAgree => 'Би зөвшөөрч байна';

  static String get termsOfService => 'Үйлчилгээний нөхцөл';

  static String get readTerms => 'Та үйлчилгээний нөхцөлтэй танилцана уу.';

  static String get beginTogether => 'Хамтдаа аяллаа эхлүүлцгээе.';

  static String get createPassword => 'Нэвтрэх нууц үг үүсгэнэ үү.';

  static String get passwordRepeat => 'Нууц үг давтах';

  static String get passwordsDoesNotMatch => 'Нууц үгээ зөв давтан оруулна уу!';

  static String get oldPassword => 'Хуучин нууц үг';

  static String get lastName => 'Овог';

  static String get firstName => 'Нэр';

  static String get agreeTermCond1 =>
      'Хэрэглэгч нь 18 нас хүрээгүй тохиолдолд түүний эцэг, эх, асран хамгаалагч, харгалзан дэмжигчээс ';

  static String get agreeTermCond2 => '"Үйлчилгээний нөхцөл"';

  static String get agreeTermCond3 =>
      '-ийг зөвшөөрсөн тохиолдолд "Habido"-г ашиглах эрх нээгдэнэ. Үйлчилгээний нөхцөлийг зөвшөөрсөн эсэхийг баталгаажуулна уу.';

// static String get agreeTerms => 'Зөвшөөрөх';
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

  static String get content => 'Контент';

  static String get advice => 'Зөвлөмж';

  static String get profile => 'Профайл';

  static String get myCorner => 'Миний булан';

  /// Showcase
  static String get showcaseAddHabit => 'Шинэ дадал үүсгэхдээ энд дарна';

  static String get showcasePsyTest => 'Сэтгэл зүйн тест бөглөх';

  static String get showcaseAssistant => 'Туслахтай харилцаж, чиглүүлэг авах';

  static String get showcaseContent => 'Сонирхолтой нийтлэл унших';

  static String get showcaseProfile => 'Өөрийн гүйцэтгэлийг харах';

  static String get showcaseCalendar => 'Тухайн сард хийх дадлын төлөвлөгөөг харах';

  static String get showcaseNotification => 'Сануулга харах';

  static String get showcaseHabitCategory => 'Өөртөө хэвшүүлэхийг хүсэж буй дадлын төрлийг сонгоно.';

  static String get showcaseHabit => 'Сонгосон төрөл доторх дадлуудаас өөрийн хэрэгжүүлэхээр дадлыг сонгоно.';

  static String get showcaseUserHabit => 'Сонгосон дадлынхаа төлөвлөгөөг гарган бүртгэл үүсгэн хадгална.';

  static String get showcaseTimer => 'Тухайн дадлыг хэвшүүлэхдээ бүртгэл хийнэ.';

  static String get showcaseSlidable => 'Нүүр хэсгээс өөрийн сонгосон дадлыг цуцлах болон засварлах боломжтой.';

  /// Chat
  static String get habidoAssistant => 'Habido туслах';

  static String get chatBotIdNotFound => 'HabiDo туслахын мэдээлэл олдсонгүй';

  /// Content
  static String get readMin => 'минут унших';

  static String get suggestedForYou => 'Танд санал болгох';

  /// Psychology test
  static String get psyTest => 'Сэтгэл зүйн тест';

  static String get psyTestSuccess => 'Сэтгэл зүйн тест амжилттай';

  static String get psyStatus => 'Сэтгэл зүйн байдал';

  static String get doPsyTest => 'Сэтгэл зүйн тест бөглөх';

  static String get beginTest => 'Сорил эхлэх';

  static String get seeResult => 'Үр дүн харах';

  static String get thanksHabido => 'Баярлалаа, Habido';

  static String get doTest2 => 'Тест бөглөх';

  static String get psyTestHint1 => 'Та өөрийгөө ямар онцлогтойгоо мэддэг ч бүрэн итгэлгүй байгаа юм биш биз?';

  static String get psyTestHint2 =>
      'Та өөрийгөө бүрэн хүлээн зөвшөөрч, илүү таньж, алдаа дутагдалтайгаа нүүр тулж, засаж сайжруулж чадна';

  static String get psyTestHint3 => 'Тиймээс сэтгэлзүйн тестийг бөглөөд үзээрэй';

  static String get psyTestHint4 => 'Доорх товчыг дарж сэтгэлзүйн тестээ бөглөөрэй';

  /// Habit
  static String get habit => 'Дадал';

  static String get habitName => 'Дадлын нэр';

  static String get createHabit => 'Дадал үүсгэх';

  static String get ediHabit => 'Дадал засварлах';

  static String get sureToSkipHabit => 'Энэ удаад алгасах уу?';

  static String get daily => 'Өдөр бүр';

  static String get weekly => '7 хоног бүр';

  static String get monthly => 'Сар бүр';

  static String get mo => 'Да';

  static String get tu => 'Мя';

  static String get we => 'Лх';

  static String get th => 'Пү';

  static String get fr => 'Ба';

  static String get sa => 'Бя';

  static String get su => 'Ня';

  static String get addTime => 'Цаг нэмэх';

  static String get goal => 'Зорилго';

  static String get remind => 'Сануулах';

  static String get remindHabit => 'Дадал сануулах';

  static String get tip => 'Зөвлөмж';

  static String get whyNeed => 'Яагаад хэрэгтэй вэ?';

  static String get monthlyCalendar => 'Сарын төлөвлөгөө';

  static String get pleaseSelectEmoji => 'Та мэдрэмжээ сонгоно уу?';

  static String get emoji1 => 'Гунигтай байна';

  static String get emoji2 => 'Тааламжгүй байна';

  static String get emoji3 => 'Юу мэдэрч байгаагаа мэдэхгүй байна';

  static String get emoji4 => 'Тайван сайхан байна';

  static String get emoji5 => 'Маш их баяртай байна';

  static String get note => 'Тэмдэглэл';

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

  static String get pleaseSelectCategory => 'Ангилал сонгоно уу.';

  static String get selectCategory => 'Ангилал сонгох';

  static String get selectMeasure => 'Хэмжигдэхүүн сонгох';

  static String get breatheTake => 'Хамраараа амьсгал авах';

  static String get breatheHold => 'Амьсгал түгжих';

  static String get breatheExhale => 'Амаараа амьсгал гаргах';

  // static String get evaluation => 'Үнэлгээ';

  static String get howAreYouFeeling => 'Та хэр сэтгэл ханамжтай байсан бэ?';

  static String get pleasing => 'Тааламжтай';

  static String get notPleasing => 'Тааламжгүй';

  static String get addNew => 'Шинээр нэмэх';

  static String get pickColor => 'Өнгө сонгох';

  static String get pickShape => 'Дүрс сонгох';

  static String get validate12 => 'Уучлаарай, 12-оос доош насны хүн бүртгүүлэх боломжгүй.';

  static String get pleaseEnterStartDate => 'Эхлэх огноо сонгоно уу.';

  static String get pleaseEnterEndDate => 'Дуусах огноо сонгоно уу.';

  static String get pleaseSelectGoal => 'Зорилго сонгоно уу.';

  /// Profile
  static String get allTime => 'Бүх цаг үе';

  static String get progress => 'Гүйцэтгэл';

  static String get completedHabit => 'Хэвшсэн дадал';

  static String get myAchievements => 'Миний амжилт';

  static String get userInfo => 'Хэрэглэгчийн мэдээлэл';

  static String get yourRank => 'Таны зэрэглэл';

  static String get changePassword => 'Нууц үг солих';

  static String get pleaseEnterVerifyCode => 'Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу.';

  static String get biometricAuth => 'Биометрээр нэвтрэх';

  static String get biometricFailed => 'Биометрээр нэвтрэх үйлдэл амжилтгүй боллоо. Дахин оролдоно уу.';

  static String get changePhoneNumber => 'Утасны дугаар солих';
}

class FlutterBlocLocalizationsDelegate extends LocalizationsDelegate<LocaleKeys> {
  @override
  Future<LocaleKeys> load(Locale locale) => Future(() => LocaleKeys());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) => locale.languageCode.toLowerCase().contains(LanguageCode.en);
}
