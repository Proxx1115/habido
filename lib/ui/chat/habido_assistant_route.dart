import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/models/msg_options.dart';
import 'package:habido_app/models/option_type.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class HabidoHelperRoute extends StatefulWidget {
  @override
  _HabidoAssistantRouteState createState() => _HabidoAssistantRouteState();
}

class _HabidoAssistantRouteState extends State<HabidoHelperRoute> {
  // UI
  final _habidoAssistantKey = GlobalKey<ScaffoldState>();

  // Data
  List<ChatResponse> _chatList = [];

  // Button thanks
  bool _visibleButtonThanks = false;

  @override
  void initState() {
    super.initState();

    BlocManager.chatBloc.add(GetFirstChatEvent(ChatType.onBoarding));
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
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ChatState state) {
    if (state is ChatSuccess) {
      _chatList.add(state.response);

      if (state.response.isEnd ?? false) {
        // Чат дууссан
        _visibleButtonThanks = true;
      } else if (state.response.msgOptions != null && state.response.msgOptions!.length > 0) {
        // Хариулт бөглөх
      } else {
        if (state.response.msgId != null) {
          // Дараагийн чатыг авах
          BlocManager.chatBloc.add(GetNextChatEvent(state.response.continueMsgId!));
        } else {
          // Дараагийн msgId олдоогүй
          showCustomDialog(
            context,
            child: CustomDialogBody(
              asset: Assets.error,
              text: LocaleKeys.noData,
              button1Text: LocaleKeys.ok,
            ),
          );
        }
      }
    } else if (state is ChatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          button1Text: LocaleKeys.ok,
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, ChatState state) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        key: _habidoAssistantKey,
        backgroundColor: customColors.primaryBackground,
        appBar: CustomAppBar(
          context,
          titleText: LocaleKeys.habidoAssistant,
          leadingAsset: null,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Chats
                for (int i = 0; i < _chatList.length; i++) _chatItem(i),

                /// Typing
                // if (state is ChatLoading) ChatLoader(),

                if (_visibleButtonThanks) _buttonThanks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatItem(int chatIndex) {
    if (_chatList[chatIndex].msgOptions != null && _chatList[chatIndex].msgOptions!.length > 0) {
      return Column(
        children: [
          /// Chat
          ChatContainer(
            child: CustomText(_chatList[chatIndex].msg, maxLines: 10),
          ),

          /// Options
          for (int j = 0; j < _chatList[chatIndex].msgOptions!.length; j++) _optionItem(chatIndex, j),
        ],
      );
    } else {
      return ChatContainer(
        child: CustomText(_chatList[chatIndex].msg, maxLines: 10),
      );
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

          // Get next chat
          if (!(chat.isEnd ?? false) && chat.continueMsgId != null) {
            BlocManager.chatBloc.add(GetNextChatEvent(chat.continueMsgId!));
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
      return HexColor.fromHex(option.optionColor ?? '#CBD0D7');
    } else {
      return customColors.iconGrey;
    }
  }

  Color _getOptionImageBackgroundColor(MsgOptions option) {
    if (Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? '#CBD0D7');
    } else {
      return customColors.iconGrey;
    }
  }

  Widget _buttonThanks() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      // asset: Assets.long_arrow_next,
      text: LocaleKeys.thanks,
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }
}