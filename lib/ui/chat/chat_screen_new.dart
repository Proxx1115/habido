import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/option_type.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/ui/chat/cb_chat_container.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_model.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_poster.dart';
import 'package:habido_app/ui/chat/chat_screen_new_bloc.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/ui/psy_test/psy_test_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:photo_view/photo_view.dart';

import 'cb_chatbots/cb_poster_view.dart';
import 'cb_chatbots/cb_test.dart';
import 'cb_chatbots/cb_test_result.dart';

class ChatScreenNew extends StatefulWidget {
  final ChatScreenNewType? type;

  const ChatScreenNew({Key? key, this.type}) : super(key: key);

  @override
  State<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends State<ChatScreenNew> {
  StreamSubscription? bottomListener;
  late PageController _pageController;

  TextEditingController _chatInputController = TextEditingController();

  final _scrollController = ScrollController(initialScrollOffset: 0.0);
  final _scrollBarController = ScrollController(initialScrollOffset: 0.0);
  final _optionScrollController = ScrollController();
  var bloc = ChatScreenNewBloc();
  var isFirst = true;
  String _inputHintText = '';

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.4);
    bloc.type = widget.type!;
    bloc.cbChatHistory();
    bottomListener = bloc.bottomSubject.listen((value) {
      gotoBottom();
    });
    gotoBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<bool>(
          initialData: false,
          stream: bloc.reloadSubject.stream,
          builder: (context, snapshot) {
            return RefreshIndicator(
              onRefresh: () async {
                bloc.cbChatHistory();
              },
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          /// Time
                          if (bloc.chatList.isNotEmpty && Func.isNotEmpty(bloc.chatList.first.msgSentTime))
                            CustomText(
                              Func.toDateStr(Func.toDate(bloc.chatList.first.msgSentTime!)).replaceAll('-', '.'),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 15.0),
                              fontWeight: FontWeight.w500,
                              color: customColors.greyText,
                            ),

                          /// Chats
                          if (bloc.chatList.isNotEmpty)
                            for (int i = 0; i < bloc.chatList.length; i++) _chatItem(bloc.chatList[i]),

                          /// Typing
                          // if (state is ChatLoading) ChatLoader(),

                          if (widget.type == ChatScreenNewType.main)
                            StreamBuilder<List<CBChatBotsModel>>(
                                initialData: [],
                                stream: bloc.chatBotsSubject.stream,
                                builder: (context, chatBotSnapshot) {
                                  return Column(
                                    children: [
                                      chatBotSnapshot.data!.length > 1 ? _chatItem(pickOneOfChatBots()) : Container(),
                                      Container(
                                        color: Colors.white,
                                        height: chatBotSnapshot.data!.length > 1 ? MediaQuery.of(context).size.height * 0.1 : 0,
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(top: 10),
                                        child: Wrap(
                                          runSpacing: 1,
                                          spacing: 5,
                                          direction: Axis.horizontal,
                                          children: [
                                            for (int i = 0; i < chatBotSnapshot.data!.length; i++)
                                              InkWell(
                                                onTap: () {
                                                  bloc.chatbotId = chatBotSnapshot.data![i].cbId!;
                                                  bloc.chatBotsSubject.add([]);
                                                  bloc.cbFirstChat();
                                                  gotoBottom();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(color: customColors.greyBackground, borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    chatBotSnapshot.data![i].name.toString(),
                                                    style: TextStyle(fontFamily: FontAsset.FiraSansCondensed),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                        ],
                      ),
                    ),
                    if (_isOptionDrawable())
                      _isEmojiOption()
                          ? Column(
                              children: [
                                MoveInAnimation(
                                  delay: 2,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.topLeft,
                                      color: Colors.white,
                                      height: bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length != 0
                                          ? bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length > 4
                                              ? MediaQuery.of(context).size.height * 0.2
                                              : MediaQuery.of(context).size.height * 0.1
                                          : 0,
                                      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                                      child: RawScrollbar(
                                        controller: _scrollBarController,
                                        thumbColor: customColors.primary,
                                        thickness: 3,
                                        radius: Radius.circular(5),
                                        child: SingleChildScrollView(
                                          controller: _scrollBarController,
                                          child: Wrap(
                                            runSpacing: 1,
                                            spacing: 3,
                                            direction: Axis.horizontal,
                                            children: [
                                              for (int i = 0; i < bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length; i++)
                                                _optionItem(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList()[i])
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                                if (_hasInput(bloc.chatList.last.cbMsgOptions!)) _input(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() == 'input').first) else Container()
                              ],
                            )
                          : _emojiOptionList()
                  ],
                ),
              ),
            );
          },
        ),
        // StreamBuilder<bool>(
        //     initialData: false,
        //     stream: bloc.isShowSubject.stream,
        //     builder: (context, showSnapshot) {
        //       return Visibility(
        //         visible: !showSnapshot.data!,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           height: MediaQuery.of(context).size.height,
        //           color: customColors.primaryBackground,
        //           child: CustomLoader(),
        //         ),
        //       );
        //     })
      ],
    );
  }

  bool _isEmojiOption() {
    if (bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'emoji').isNotEmpty) return true;
    return false;
  }

  bool _isOptionDrawable() {
    if (bloc.chatList.isNotEmpty && bloc.chatList.last.cbMsgOptions != null) {
      if (bloc.chatList.last.cbMsgOptions!.length > 1)
        _inputHintText = 'Бусад';
      else
        _inputHintText = '';
      var selectedOptionCount = bloc.chatList.last.cbMsgOptions!.where((element) => element.isSelected == true).length;
      if (bloc.chatList.last.isEnd != true) {
        return true;
      } else if (selectedOptionCount == 0 && bloc.chatList.last.isEnd == true) {
        return true;
      }
    }
    return false;
  }

  Widget _emojiOptionList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      color: Colors.white,
      height: bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length > 4
          ? MediaQuery.of(context).size.height * 0.65
          : bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length * 70,
      child: RawScrollbar(
        controller: _scrollController,
        thumbColor: customColors.primary,
        thickness: 3,
        radius: Radius.circular(5),
        isAlwaysShown: true,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          padding: EdgeInsets.all(20),
          children: [
            for (int i = 0; i < bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length; i++)
              _emojiOption(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList()[i])
          ],
        ),
      ),
    );
  }

  Widget _input(CBMsgOption inputOption) {
    return MoveInAnimation(
      duration: 200,
      delay: 4,
      child: Column(
        children: [
          HorizontalLine(),
          Container(
            height: 62,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      color: customColors.greyBackground,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: TextField(
                      autofocus: true,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: _inputHintText, hintStyle: TextStyle(fontWeight: FontWeight.w300, fontFamily: FontAsset.FiraSansCondensed), contentPadding: EdgeInsets.only(left: 10)),
                      controller: _chatInputController,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    onPressed: () {
                      bloc.cbMsgOption(inputOption, input: _chatInputController.text);
                      inputOption.text = _chatInputController.text;
                      _chatInputController.clear();
                      gotoBottom();
                    },
                    icon: SvgPicture.asset(
                      Assets.chat_input_send,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _chatItem(CBChatResponse cbChatResponse) {
    return Column(
      children: [
        if (cbChatResponse.ownerType!.toLowerCase() == 'content')
          CBChatContainer(
              prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
              suffixTime: Func.toTimeStr(cbChatResponse.msgSentTime),
              width: MediaQuery.of(context).size.width * 0.7,
              child: HorizontalContentCard(content: cbChatResponse.content!))
        else if (cbChatResponse.ownerType!.toLowerCase() == 'testanswer')
          _cbTestResult(cbChatResponse)
        else if (cbChatResponse.ownerType!.toLowerCase() == 'poster')
          _cbPoster(cbChatResponse.posters)
        else if (cbChatResponse.ownerType!.toLowerCase() == 'psytest')
          CBChatContainer(
              prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
              suffixTime: Func.toTimeStr(cbChatResponse.msgSentTime),
              width: MediaQuery.of(context).size.width * 0.7,
              child: HorizontalPsyTestCard(
                test: cbChatResponse.test,
                testResult: cbChatResponse.testResult ?? null,
              ))
        else if (cbChatResponse.ownerType!.toLowerCase() == 'habit')
          CBChatContainer(
              prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
              suffixTime: Func.toTimeStr(cbChatResponse.msgSentTime),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.09,
              padding: EdgeInsets.zero,
              child: ListItemContainer(
                leadingImageUrl: cbChatResponse.habit!.photo,
                title: cbChatResponse.habit!.name ?? '',
                height: MediaQuery.of(context).size.height,
                leadingBackgroundColor: (cbChatResponse.habit!.color != null) ? HexColor.fromHex(cbChatResponse.habit!.color!) : null,
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName(Routes.home));
                  Navigator.pushNamed(context, Routes.userHabit, arguments: {
                    'screenMode': ScreenMode.New,
                    'habit': cbChatResponse.habit,
                    'title': LocaleKeys.createHabit,
                  });
                },
              ))
        else
          CBChatContainer(
            prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
            suffixTime: cbChatResponse.msgSentTime != null ? Func.toTimeStr(cbChatResponse.msgSentTime) : null,
            child: CustomText(cbChatResponse.msg!, maxLines: 15, fontFamily: FontAsset.FiraSansCondensed),
          ),
        if (cbChatResponse.cbMsgOptions != null && cbChatResponse.cbMsgOptions!.length == 1 && cbChatResponse.cbMsgOptions!.first.isSelected == true)
          (cbChatResponse.ownerType!.toLowerCase() != 'posters') ? _selectedOptionItem(cbChatResponse.cbMsgOptions!.first) : _cbPoster(cbChatResponse.posters),
        if (cbChatResponse.isEnd == true && ((cbChatResponse.hasOption == true && cbChatResponse.cbMsgOptions!.where((element) => element.isSelected == true).length > 0) || cbChatResponse.hasOption == false))
          Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5), child: HorizontalLine())
      ],
    );
  }

  CBChatResponse pickOneOfChatBots() {
    String arbitron = 'Оройн мэнд';
    var hour = DateTime.now().hour;
    if (hour < 12 && hour >= 6) {
      arbitron = 'Өглөөний мэнд';
    } else if (hour >= 12 && hour < 17) {
      arbitron = 'Өдрийн мэнд';
    }
    return CBChatResponse(ownerType: 'Text', msg: '$arbitron, Юуны талаар ярилцмаар байна?', continueMsgId: 0, isEnd: false, hasOption: false, isFirst: false, cbId: 0, msgId: 0, msgSentTime: DateTime.now().toString());
  }

  Widget _optionItem(CBMsgOption option) {
    return CBChatContainer(
      isOption: true,
      color: 1,
      width: MediaQuery.of(context).size.width * 0.3,
      // alignment: Alignment.center,
      borderRadius: _optionBorderRadius(option.photoLink),
      tweenStart: option.isSelected! ? 0.0 : 30.0,
      tweenEnd: 0.0,
      delay: option.isSelected! ? 0 : null,
      child: CustomText(
        option.text,
        maxLines: 10,
        fontFamily: FontAsset.FiraSansCondensed,
        fontWeight: FontWeight.w500,
      ),
      onTap: () {
        if (option.isSelected!) return;
        bloc.cbMsgOption(option);
        gotoBottom();
      },
    );
  }

  Widget _emojiOption(CBMsgOption option) {
    return InkWell(
      onTap: () {
        if (option.isSelected!) return;
        bloc.cbMsgOption(option);
        gotoBottom();
      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4.2,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: customColors.primaryBorder,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(5),
                topRight: Radius.circular(15),
              ),
              color: customColors.whiteBackground,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CachedNetworkImage(
                    height: 36,
                    width: 36,
                    imageUrl: option.photoLink!,
                    // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Container(),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  option.text ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: FontAsset.FiraSansCondensed,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasInput(List<CBMsgOption> options) {
    bool hasInput = false;
    options.forEach((element) {
      if (element.optionType!.toLowerCase() == 'input') hasInput = true;
    });
    return hasInput;
  }

  gotoBottom() {
    Timer(Duration(seconds: 1), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.easeInOut).then((value) {
        if (isFirst == true) {
          bloc.isShowSubject.add(true);
          isFirst = false;
        }
      });
    });
  }

  Widget _selectedOptionItem(CBMsgOption option) {
    return CBChatContainer(
      color: 2,
      alignment: Alignment.centerRight,
      height: _optionHeight(option.optionType),
      tweenStart: 30.0,
      tweenEnd: 0.0,
      child: Row(
        children: [
          /// Text
          Expanded(
            child: CustomText(
              option.text,
              maxLines: 10,
              color: Colors.white,
              fontFamily: FontAsset.FiraSansCondensed,
            ),
          ),
        ],
      ),
    );
  }

  double? _optionHeight(String? optionType) {
    return (optionType == OptionType.Habit) ? SizeHelper.boxHeight : null;
  }

  BorderRadius? _optionBorderRadius(String? imageLink) {
    return Func.isNotEmpty(imageLink)
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          )
        : null;
  }

  Widget _cbPoster(List<CBPoster>? posters) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      height: MediaQuery.of(context).size.width / 2.5,
      width: double.infinity,
      child: PageView.builder(
          itemCount: posters!.length,
          pageSnapping: true,
          controller: _pageController,
          padEnds: false,
          itemBuilder: (context, pagePosition) {
            return Container(
              margin: EdgeInsets.only(right: 9),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.posterView, arguments: {'posters': posters, 'currentIndex': pagePosition});
                  },
                  child: CachedNetworkImage(
                    imageUrl: posters[pagePosition].link!,
                    // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Container(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _cbTestResult(CBChatResponse cbChatResponse) {
    return CBChatContainer(
      prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
      suffixTime: cbChatResponse.msgId == bloc.chatList.last.msgId ? Func.toTimeStr(cbChatResponse.msgSentTime) : '',
      child: Column(
        children: [
          CustomText(
            cbChatResponse.cbTestResult!.resultText,
            maxLines: 10,
            fontFamily: FontAsset.FiraSansCondensed,
            fontWeight: FontWeight.w600,
          ),
          CustomText(cbChatResponse.cbTestResult!.description, maxLines: 20, fontFamily: FontAsset.FiraSansCondensed),
        ],
      ),
    );
  }

  Widget _contentItem(Content? content) {
    if (content == null) return Container();

    double width = MediaQuery.of(context).size.width * 0.6;
    return CBChatContainer(
      padding: EdgeInsets.zero,
      width: width,
      onTap: () {
        Navigator.pushNamed(context, Routes.content, arguments: {
          'content': content,
          'routeBuilder': 'SlideRightRouteBuilder',
        });
      },
      child: Column(
        children: [
          /// Image
          if (Func.isNotEmpty(content.contentPhoto))
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: content.contentPhoto!,
                fit: BoxFit.fill,
                width: width,
                placeholder: (context, url) => Container(
                  height: width * 0.66,
                  child: CustomLoader(),
                ),
                errorWidget: (context, url, error) => Container(),
              ),
            ),

          /// Title
          CustomText(
            content.title,
            margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),

          /// Body
          CustomText(content.intro, margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0), maxLines: 2),

          if (content.readTime != null)
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Clock icon
                  SvgPicture.asset(Assets.clock),

                  /// Read time
                  Expanded(
                    child: CustomText('${content.readTime} ${LocaleKeys.readMin}', margin: EdgeInsets.only(left: 7.0)),
                  ),
                ],
              ),
            ),

          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

enum ChatScreenNewType { onboard, main }
