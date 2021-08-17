import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/first_chat_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HabidoHelperRoute extends StatefulWidget {
  @override
  _HabidoHelperRouteState createState() => _HabidoHelperRouteState();
}

class _HabidoHelperRouteState extends State<HabidoHelperRoute> {
  // UI
  final _habidoHelperKey = GlobalKey<ScaffoldState>();

  // Data
  FirstChatResponse? _firstChatResponse;

  @override
  void initState() {
    super.initState();

    BlocManager.chatBloc.add(GetFirstChatEvent());
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
    if (state is FirstChatSuccess) {
      _firstChatResponse = state.response;
    } else if (state is FirstChatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, ChatState state) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: state is ChatLoading,
        child: Scaffold(
          key: _habidoHelperKey,
          appBar: CustomAppBar(
            context,
            titleText: LocaleKeys.habidoHelper,
            leadingAsset: null,
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
            child: Column(
              children: [
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
