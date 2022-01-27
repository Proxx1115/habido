import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/models/option_type.dart';
import 'package:habido_app/ui/chat/cb_chat_container.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/chat_screen_new_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class ChatScreenNew extends StatefulWidget {
  final ChatScreenNewType? type;

  const ChatScreenNew({Key? key, this.type}) : super(key: key);

  @override
  State<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends State<ChatScreenNew> {
  StreamSubscription? bottomListener;

  final _scrollController = ScrollController();
  var bloc = ChatScreenNewBloc();

  @override
  void initState() {
    bloc.cbChatHistory();
    // bloc.cbChatbots();

    bottomListener = bloc.bottomSubject.listen((value) {
      gotoBottom();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.reloadSubject.stream,
      builder: (context, snapshot) {
        if (bloc.chatList.length == 0) return Container();
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
                      if (bloc.chatList.isNotEmpty &&
                          Func.isNotEmpty(bloc.chatList.first.msgSentTime))
                        CustomText(
                          Func.toDateStr(
                                  Func.toDate(bloc.chatList.first.msgSentTime!))
                              .replaceAll('-', '.'),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 15.0),
                          fontWeight: FontWeight.w500,
                          color: customColors.greyText,
                        ),

                      /// Chats
                      for (int i = 0; i < bloc.chatList.length; i++)
                        _chatItem(
                            bloc.chatList[i], i == bloc.chatList.length - 1),

                      /// Typing
                      // if (state is ChatLoading) ChatLoader(),

                      /// Button thanks
                      if (bloc.chatList[bloc.chatList.length - 1].isEnd! &&
                          widget.type == ChatScreenNewType.onboard)
                        _buttonThanks(),
                    ],
                  ),
                ),
                if (bloc.chatList.last.cbMsgOptions != null)
                  Container(
                    color: Colors.white,
                    height: bloc.chatList.last.cbMsgOptions!.length > 4
                        ? MediaQuery.of(context).size.height * 0.3
                        : bloc.chatList.last.cbMsgOptions!.length * 60,
                    padding: EdgeInsets.only(top: 10),
                    child: ListView(
                      children: [
                        for (int i = 0;
                            i < bloc.chatList.last.cbMsgOptions!.length;
                            i++)
                          _optionItem(
                              bloc.chatList.last.cbMsgOptions![i], false)
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chatItem(CBChatResponse cbChatResponse, bool isLast) {
    // if(_chatList[chatIndex].content != null) {
    //   return _contentItem(_chatList[chatIndex].content!);
    // }

    return Column(
      children: [
        CBChatContainer(
          prefixAsset: true
              ? Assets.habido_assistant_png
              : Assets.habido_assistant_empty,
          suffixTime: true ? Func.toTimeStr(cbChatResponse.msgSentTime) : '',
          child: CustomText(cbChatResponse.msg!,
              maxLines: 10, fontFamily: FontAsset.FiraSansCondensed),
        ),
        if (cbChatResponse.cbMsgOptions != null &&
            cbChatResponse.cbMsgOptions!.length == 1 &&
            !isLast)
          _selectedOptionItem(cbChatResponse.cbMsgOptions!.first, true)
      ],
    );
  }

  Widget _optionItem(CBMsgOption option, bool isSelected) {
    return CBChatContainer(
      color: 1,
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      height: _optionHeight(option.optionType),
      padding: _optionPadding(option.optionType),
      borderRadius: _optionBorderRadius(option.photoLink),
      tweenStart: isSelected ? 0.0 : 30.0,
      tweenEnd: 0.0,
      delay: isSelected ? 0 : null,
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
            child: CustomText(
              option.text,
              maxLines: 10,
              fontFamily: FontAsset.FiraSansCondensed,
            ),
          ),

          /// IconS
          SvgPicture.asset(
            Assets.circle_check,
            color: _getOptionColor(option, isSelected),
          ),
        ],
      ),
      onTap: () {
        if (isSelected) return;
        bloc.cbMsgOption(option);
        gotoBottom();
      },
    );
  }

  gotoBottom() {
    Timer(Duration(seconds: 1), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  Widget _selectedOptionItem(CBMsgOption option, bool isSelected) {
    return CBChatContainer(
      color: 2,
      alignment: Alignment.centerRight,
      height: _optionHeight(option.optionType),
      padding: _optionPadding(option.optionType),
      borderRadius: _optionBorderRadius(option.photoLink),
      tweenStart: 30.0,
      tweenEnd: 0.0,
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
            child: CustomText(
              option.text,
              maxLines: 10,
              color: Colors.white,
              fontFamily: FontAsset.FiraSansCondensed,
            ),
          ),

          /// Icon
          SvgPicture.asset(
            Assets.circle_check,
            color: _getOptionColor(option, isSelected),
          ),
        ],
      ),
    );
  }

  Widget _buttonThanks() {
    return CustomButton(
      text: LocaleKeys.thanks,
      visible: true,
      style: CustomButtonStyle.secondary,
      margin: EdgeInsets.only(top: 25.0, bottom: 10),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }

  double? _optionHeight(String? optionType) {
    return (optionType == OptionType.Habit) ? SizeHelper.boxHeight : null;
  }

  EdgeInsets? _optionPadding(String? optionType) {
    return (optionType == OptionType.Habit)
        ? EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0)
        : null;
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

  Color _getOptionColor(CBMsgOption option, bool isSelected) {
    if (isSelected && Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }

  Color _getOptionImageBackgroundColor(CBMsgOption option) {
    if (Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }
}

enum ChatScreenNewType { onboard, main }
