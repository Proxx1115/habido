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

  static String get appName => 'Habido';

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

  static String get search => 'Хайх';

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

  static String get delete => 'Устгах';

  static String get thanks => 'Баярлалаа';

  static String get sureToDelete => 'Устгахдаа итгэлтэй байна уу?';

  ///
  /// Intro
  ///
  static String get intro1 => 'Дадлаа тууштай бүртгэ';

  static String get intro2 => 'Сэтгэл зүйгээ удирд';

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

  static String get gender => 'Хүйс';

  static String get iAgree => 'Би зөвшөөрч байна';

  static String get termsOfService => 'Үйлчилгээний нөхцөл';

  static String get readTerms => 'Та үйлчилгээний нөхцөлтэй танилцана уу.';

  static String get beginTogether => 'Хамтдаа аяллаа эхлүүлцгээе.';

  static String get createPassword => 'Нэвтрэх нууц үг үүсгэнэ үү.';

  static String get passwordRepeat => 'Нууц үг давтах';

  static String get passwordsDoesNotMatch => 'Нууц үгээ зөв давтан оруулна уу!';

// static String get lastName => 'Овог';

// static String get firstName => 'Нэр';

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

  static String get assistant => 'Туслах';

  static String get content => 'Контент';

  static String get profile => 'Профайл';

  /// Settings

  /// Chat
  static String get habidoAssistant => 'Habido туслах';

  static String get chatBotIdNotFound => 'Habido туслахын мэдээлэл олдсонгүй';

  /// Content
  static String get readMin => 'min read';

  /// Psychology test
  static String get psyTest => 'Сэтгэл зүйн тест';
}

class FlutterBlocLocalizationsDelegate extends LocalizationsDelegate<LocaleKeys> {
  @override
  Future<LocaleKeys> load(Locale locale) => Future(() => LocaleKeys());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) => locale.languageCode.toLowerCase().contains(LanguageCode.en);
}
