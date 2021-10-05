import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/models/chatbots_response.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/msg_options.dart';
import 'package:habido_app/models/option_type.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class ChatScreen extends StatefulWidget {
  final String chatType;

  const ChatScreen({Key? key, required this.chatType}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Data
  List<ChatResponse> _chatList = [];

  // List view
  ScrollController _scrollController = new ScrollController();

  // Button thanks
  bool _visibleButtonThanks = false;

  // Last chat
  bool _isLastChatBot = false;

  @override
  void initState() {
    super.initState();

    BlocManager.chatBloc.add(GetChatbotsEvent(widget.chatType));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: _blocListener,
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return AbsorbPointer(
              absorbing: state is ChatLoading,
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, SizeHelper.marginBottom),
                children: [
                  /// Time
                  if (_chatList.isNotEmpty && Func.isNotEmpty(_chatList.first.dateTime))
                    CustomText(
                      Func.toDateStr(Func.toDate(_chatList.first.dateTime!)).replaceAll('-', '.'),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 15.0),
                      fontWeight: FontWeight.w500,
                      color: customColors.greyText,
                    ),

                  /// Chats
                  for (int i = 0; i < _chatList.length; i++) _chatItem(i),

                  /// Typing
                  // if (state is ChatLoading) ChatLoader(),

                  /// Button thanks
                  _buttonThanks(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ChatState state) {
    if (state is GetChatbotsSuccess) {
      // ChatbotsResponse res = state.response;
      // if(res.isAssistantChatDone ?? false && res.) {
      // } else ()
    } else if (state is GetChatbotsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
        ),
      );
    } else if (state is GetChatSuccess) {
      ChatResponse chat = state.response;
      chat.visibleProfilePicture = true;

      _chatList.add(chat);

      if (state.chatIndex != null) {
        // print('Хариулт сонгосон');
        _chatList[state.chatIndex!].isOptionSelected = true;
      }

      if (chat.isEnd ?? false) {
        // print('Чат дууссан');
        if (widget.chatType == ChatType.onboarding) {
          _visibleButtonThanks = true;
        }
      } else if (chat.msgOptions != null && chat.msgOptions!.length > 0) {
        // print('Хариулт сонгох');
      } else {
        if (chat.msgId != null) {
          // print('Дараагийн чатыг авах');
          BlocManager.chatBloc.add(GetNextChatEvent(chat.continueMsgId!, _chatList.length - 1));
        } else {
          // print('Дараагийн msgId олдоогүй');
          showCustomDialog(
            context,
            child: CustomDialogBody(
              asset: Assets.error,
              text: LocaleKeys.noData,
              buttonText: LocaleKeys.ok,
            ),
          );
        }
      }

      // _scrollToBottom();
    } else if (state is GetChatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
        ),
      );
    } else if (state is ChatHistorySuccess) {
      _chatList = state.chatList ?? [];

      _setProfilePictureAndTimeHistory();
    } else if (state is ChatHistoryFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
        ),
      );
    }
  }

  Widget _chatItem(int chatIndex) {
    // if(_chatList[chatIndex].content != null) {
    //   return _contentItem(_chatList[chatIndex].content!);
    // }

    return Column(
      children: [
        (_chatList[chatIndex].content != null)
            ?

            /// Content
            _contentItem(_chatList[chatIndex].content!)
            :

            /// Bot chat
            ChatContainer(
                prefixAsset: _chatList[chatIndex].visibleProfilePicture
                    ? Assets.habido_assistant_png
                    : Assets.habido_assistant_empty,
                suffixTime:
                    _chatList[chatIndex].visibleProfilePicture ? Func.toTimeStr(_chatList[chatIndex].dateTime) : '',
                child: CustomText(_chatList[chatIndex].msg!, maxLines: 10),
              ),

        /// Selected option
        if (_chatList[chatIndex].selectedMsgOption != null)
          _selectedOptionItem(chatIndex, _chatList[chatIndex].selectedMsgOption!),

        /// Option
        if (_chatList[chatIndex].selectedMsgOption == null &&
            _chatList[chatIndex].msgOptions != null &&
            _chatList[chatIndex].msgOptions!.length > 0)
          for (int j = 0; j < _chatList[chatIndex].msgOptions!.length; j++) _optionItem(chatIndex, j),
      ],
    );
  }

  _setProfilePictureAndTimeHistory() {
    if (_chatList.isNotEmpty) {
      if (_chatList.length == 1) {
        if (_chatList.last.selectedMsgOption == null) {
          // 1 bot chat
          _chatList.last.visibleProfilePicture = true;
        }
      } else {
        for (int i = 1; i < _chatList.length - 1; i++) {
          try {
            if (i + 1 < _chatList.length) {
              // Has index
              if (_chatList[i].selectedMsgOption == null) {
                _chatList[i].visibleProfilePicture = false;
                _chatList[i + 1].visibleProfilePicture = true;
              } else {
                // print('human');
              }
            }
          } catch (e) {
            print(e);
          }
        }
      }
    }
  }

  Widget _optionItem(int chatIndex, int optionIndex) {
    var chat = _chatList[chatIndex];
    var option = chat.msgOptions![optionIndex];

    if (option.isVisible) {
      return ChatContainer(
        alignment: Alignment.centerRight,
        height: _optionHeight(chat.optionType),
        padding: _optionPadding(chat.optionType),
        borderRadius: _optionBorderRadius(option.habitCategoryPhotoLink),
        tweenStart: option.isSelected ? 0.0 : 30.0,
        tweenEnd: 0.0,
        delay: option.isSelected ? 0 : null,
        child: Row(
          children: [
            /// Icon
            if (Func.isNotEmpty(option.habitCategoryPhotoLink))
              Container(
                margin: EdgeInsets.only(right: 15.0),
                padding: EdgeInsets.all(15.0),
                height: _optionHeight(chat.optionType),
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
                  imageUrl: option.habitCategoryPhotoLink!,
                  // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                  fit: BoxFit.fill,
                ),
              ),

            /// Text
            Expanded(
              child: CustomText(option.text, maxLines: 10),
            ),

            /// Icon
            SvgPicture.asset(
              Assets.circle_check,
              color: _getOptionColor(option),
            ),
          ],
        ),
        onTap: () {
          // Already selected
          if (chat.isOptionSelected) return;

          // Remove unselected options
          for (int i = 0; i < chat.msgOptions!.length; i++) {
            if (i == optionIndex) {
              // Selected
              chat.msgOptions![i].isVisible = true;
              chat.msgOptions![i].isSelected = true;
            } else {
              // Unselected
              chat.msgOptions![i].isVisible = false;
              chat.msgOptions![i].isSelected = false;
            }
          }

          setState(() {
            // print('Selected option: $optionIndex');
          });

          // Save option
          if (!(chat.isEnd ?? false) && chat.continueMsgId != null && option.optionId != null) {
            BlocManager.chatBloc.add(SaveOptionEvent(chat.msgId!, option.optionId!, chatIndex));
          }
        },
      );
    } else {
      return Container();
    }
  }

  Widget _selectedOptionItem(int chatIndex, MsgOption msgOption) {
    var chat = _chatList[chatIndex];
    var option = msgOption;
    option.isSelected = true;

    return ChatContainer(
      alignment: Alignment.centerRight,
      height: _optionHeight(chat.optionType),
      padding: _optionPadding(chat.optionType),
      borderRadius: _optionBorderRadius(option.habitCategoryPhotoLink),
      tweenStart: 30.0,
      tweenEnd: 0.0,
      child: Row(
        children: [
          /// Icon
          if (Func.isNotEmpty(option.habitCategoryPhotoLink))
            Container(
              margin: EdgeInsets.only(right: 15.0),
              padding: EdgeInsets.all(15.0),
              height: _optionHeight(chat.optionType),
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
                imageUrl: option.habitCategoryPhotoLink!,
                // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                fit: BoxFit.fill,
              ),
            ),

          /// Text
          Expanded(
            child: CustomText(option.text, maxLines: 10),
          ),

          /// Icon
          SvgPicture.asset(
            Assets.circle_check,
            color: _getOptionColor(option),
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

  Color _getOptionColor(MsgOption option) {
    if (option.isSelected && Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }

  Color _getOptionImageBackgroundColor(MsgOption option) {
    if (Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }

  Widget _contentItem(Content content) {
    double width = MediaQuery.of(context).size.width * 0.6;

    return ChatContainer(
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
          CustomText(content.text, margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0), maxLines: 2),

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

  Widget _buttonThanks() {
    return CustomButton(
      text: LocaleKeys.thanks,
      visible: _visibleButtonThanks,
      style: CustomButtonStyle.secondary,
      margin: EdgeInsets.only(top: 25.0),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }

// _scrollToBottom() {
//   Future.delayed(const Duration(milliseconds: 1000), () {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       curve: Curves.easeOut,
//       duration: const Duration(milliseconds: 1000),
//     );
//
//     // setState(() {
//     //   _scrollController.animateTo(
//     //     _scrollController.position.maxScrollExtent,
//     //     curve: Curves.easeOut,
//     //     duration: const Duration(milliseconds: 1000),
//     //   );
//     // });
//   });
// }
}
