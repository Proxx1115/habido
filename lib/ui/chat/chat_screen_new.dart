import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:habido_app/ui/psy_test/psy_test_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
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
  late PageController _pageController, _pageControllerInst;

  TextEditingController _chatInputController = TextEditingController();

  final _scrollController = ScrollController();
  var bloc = ChatScreenNewBloc();
  var isFirst = true;
  List<CBMsgOption> inputOptionExcluded = [];

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    _pageControllerInst = PageController(viewportFraction: 0.45);
    bloc.type = widget.type!;
    bloc.cbChatHistory();
    bottomListener = bloc.bottomSubject.listen((value) {
      gotoBottom();
    });
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
                                  return Container(
                                    color: Colors.white,
                                    height: chatBotSnapshot.data!.length > 4 ? MediaQuery.of(context).size.height * 0.2 : chatBotSnapshot.data!.length * 60,
                                    padding: EdgeInsets.only(top: 10),
                                    child: ListView(
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
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(color: customColors.iconGrey, borderRadius: BorderRadius.circular(5)),
                                              child: Text(chatBotSnapshot.data![i].name.toString()),
                                            ),
                                          )
                                      ],
                                    ),
                                  );
                                }),
                        ],
                      ),
                    ),
                    if (_isOptionDrawable())
                      Column(
                        children: [
                          MoveInAnimation(
                            delay: 2,
                            child: Container(
                                color: Colors.white,
                                height: bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length > 4
                                    ? MediaQuery.of(context).size.height * 0.2
                                    : bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length * 60,
                                padding: EdgeInsets.only(top: 10),
                                child: (_isEmojiOption())
                                    ? ListView(
                                        children: [
                                          for (int i = 0; i < bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length; i++)
                                            _optionItem(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList()[i])
                                        ],
                                      )
                                    : GridView.count(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 15,
                                        crossAxisSpacing: 15,
                                        padding: EdgeInsets.all(20),
                                        children: [
                                          for (int i = 0; i < bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList().length; i++)
                                            _emojiOption(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() != 'input').toList()[i])
                                        ],
                                      )),
                          ),
                          _hasInput(bloc.chatList.last.cbMsgOptions!) ? _input(bloc.chatList.last.cbMsgOptions!.where((element) => element.optionType!.toLowerCase() == 'input').first) : Container()
                        ],
                      )
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
      var selectedOptionCount = bloc.chatList.last.cbMsgOptions!.where((element) => element.isSelected == true).length;
      if (bloc.chatList.last.isEnd != true) {
        return true;
      } else if (selectedOptionCount == 0 && bloc.chatList.last.isEnd == true) {
        return true;
      }
    }
    return false;
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
                        border: InputBorder.none,
                      ),
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
          _contentItem(cbChatResponse.content)
        else if (cbChatResponse.ownerType!.toLowerCase() == 'testanswer')
          _cbTestResult(cbChatResponse)
        else if (cbChatResponse.ownerType!.toLowerCase() == 'poster')
          _cbPoster(cbChatResponse.posters)
        else if (cbChatResponse.ownerType!.toLowerCase() == 'psytest')
          CBChatContainer(
              prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
              suffixTime: cbChatResponse.msgId == bloc.chatList.last.msgId ? Func.toTimeStr(cbChatResponse.msgSentTime) : '',
              width: MediaQuery.of(context).size.width * 0.7,
              child: HorizontalPsyTestCard(test: cbChatResponse.test))
        else
          CBChatContainer(
            prefixAsset: cbChatResponse.msgId == bloc.chatList.last.msgId ? Assets.habido_assistant_png : Assets.habido_assistant_empty,
            suffixTime: cbChatResponse.msgId == bloc.chatList.last.msgId ? Func.toTimeStr(cbChatResponse.msgSentTime) : '',
            child: CustomText(cbChatResponse.msg!, maxLines: 15, fontFamily: FontAsset.FiraSansCondensed),
          ),
        if (cbChatResponse.cbMsgOptions != null && cbChatResponse.cbMsgOptions!.length == 1 && cbChatResponse.cbMsgOptions!.first.isSelected == true)
          (cbChatResponse.ownerType!.toLowerCase() != 'posters') ? _selectedOptionItem(cbChatResponse.cbMsgOptions!.first) : _cbPoster(cbChatResponse.posters)
      ],
    );
  }

  Widget _optionItem(CBMsgOption option) {
    return CBChatContainer(
      width: MediaQuery.of(context).size.width * 0.8,
      color: 1,
      alignment: Alignment.center,
      height: _optionHeight(option.optionType),
      padding: _optionPadding(option.optionType),
      borderRadius: _optionBorderRadius(option.photoLink),
      tweenStart: option.isSelected! ? 0.0 : 30.0,
      tweenEnd: 0.0,
      delay: option.isSelected! ? 0 : null,
      child: Row(
        children: [
          /// Icon
          if (Func.isNotEmpty(option.photoLink))
            Container(
              margin: EdgeInsets.only(right: 15.0),
              padding: EdgeInsets.all(15.0),
              height: _optionHeight(option.optionType),
              decoration: BoxDecoration(
                color: _getOptionImageBackgroundColor(option),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(15.0),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: option.photoLink!,
                // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                fit: BoxFit.fill,
              ),
            ),

          /// Text
          Expanded(
            child: CustomText(option.text, maxLines: 10, fontFamily: FontAsset.FiraSansCondensed),
          )
        ],
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
            width: MediaQuery.of(context).size.width / 4,
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

  EdgeInsets? _optionPadding(String? optionType) {
    return (optionType == OptionType.Habit) ? EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0) : null;
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

  Color _getOptionImageBackgroundColor(CBMsgOption option) {
    if (Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }

  Widget _cbPoster(List<CBPoster>? posters) {
    return CBChatContainer(
      child: Container(
        height: MediaQuery.of(context).size.width / 3,
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
      ),
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
