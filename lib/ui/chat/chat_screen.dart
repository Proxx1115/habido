import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chat_type.dart';
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

  @override
  void initState() {
    super.initState();




    BlocManager.chatBloc.add(GetFirstChatEvent(widget.chatType));
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
                // reverse: true, // todo test
                padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, SizeHelper.marginBottom),
                children: [
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
    if (state is ChatSuccess) {
      _chatList.add(state.response);

      if (state.chatIndex != null) {
        print('Хариулт сонгосон');
        _chatList[state.chatIndex!].isOptionSelected = true;
      }

      if (state.response.isEnd ?? false) {
        print('Чат дууссан');
        if (widget.chatType == ChatType.onBoarding) {
          _visibleButtonThanks = true;
        }
      } else if (state.response.msgOptions != null && state.response.msgOptions!.length > 0) {
        print('Хариулт сонгох');
      } else {
        if (state.response.msgId != null) {
          print('Дараагийн чатыг авах');
          BlocManager.chatBloc.add(GetNextChatEvent(state.response.continueMsgId!, _chatList.length - 1));
        } else {
          print('Дараагийн msgId олдоогүй');
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
    } else if (state is ChatFailed) {
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

  _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );

      // setState(() {
      //   _scrollController.animateTo(
      //     _scrollController.position.maxScrollExtent,
      //     curve: Curves.easeOut,
      //     duration: const Duration(milliseconds: 1000),
      //   );
      // });
    });
  }

  Widget _chatItem(int chatIndex) {
    return Column(
      children: [
        (_chatList[chatIndex].content != null)
            ?

            /// Content
            _contentItem(_chatList[chatIndex].content!)
            :

            /// Bot chat
            ChatContainer(
                child: CustomText(_chatList[chatIndex].msg, maxLines: 10),
              ),

        /// User chat - Options
        if (_chatList[chatIndex].msgOptions != null && _chatList[chatIndex].msgOptions!.length > 0)
          for (int j = 0; j < _chatList[chatIndex].msgOptions!.length; j++) _optionItem(chatIndex, j),
      ],
    );
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
            print('Selected option: $optionIndex');
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

  Color _getOptionColor(MsgOptions option) {
    if (option.isSelected && Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? ColorCodes.ghostGrey);
    } else {
      return customColors.iconGrey;
    }
  }

  Color _getOptionImageBackgroundColor(MsgOptions option) {
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
      style: CustomButtonStyle.Secondary,
      margin: EdgeInsets.only(top: 25.0),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }
}
