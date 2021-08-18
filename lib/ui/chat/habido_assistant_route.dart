import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/models/msg_options.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/app_bars.dart';
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
                if (state is ChatLoading) ChatLoader(),
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
    if (_chatList[chatIndex].msgOptions![optionIndex].isVisible) {
      var option = _chatList[chatIndex].msgOptions![optionIndex];

      return ChatContainer(
        alignment: Alignment.centerRight,
        tweenStart: 30.0,
        tweenEnd: 0.0,
        child: Row(
          children: [
            /// Icon

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
          for (int i = 0; i < _chatList[chatIndex].msgOptions!.length; i++) {
            if (i == optionIndex) {
              // Selected
              _chatList[chatIndex].msgOptions![i].isVisible = true;
              _chatList[chatIndex].msgOptions![i].isSelected = true;
            } else {
              // Unselected
              _chatList[chatIndex].msgOptions![i].isVisible = false;
              _chatList[chatIndex].msgOptions![i].isSelected = false;
            }
          }

          setState(() {
            print('Selected option: $optionIndex');
          });

          // Get next chat
          if (!(_chatList[chatIndex].isEnd ?? false) && _chatList[chatIndex].continueMsgId != null) {
            BlocManager.chatBloc.add(GetNextChatEvent(_chatList[chatIndex].continueMsgId!));
          }
        },
      );
    } else {
      return Container();
    }
  }

  Color _getOptionColor(MsgOptions option) {
    if (option.isSelected && Func.isNotEmpty(option.optionColor)) {
      return HexColor.fromHex(option.optionColor ?? '#CBD0D7');
    } else {
      return customColors.iconGrey;
    }
  }
}
