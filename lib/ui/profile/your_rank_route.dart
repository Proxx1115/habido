import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class YourRankRoute extends StatefulWidget {
  const YourRankRoute({Key? key}) : super(key: key);

  @override
  _YourRankRouteState createState() => _YourRankRouteState();
}

class _YourRankRouteState extends State<YourRankRoute> {
  @override
  void initState() {
    BlocManager.userBloc.add(GetRankList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.yourRank,
      body: SingleChildScrollView(
        child: BlocProvider.value(
          value: BlocManager.userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: _blocListener,
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                // return (globals.userData != null && globals.userData!.rankId != null)
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is RankListSuccess) {
      print('');
    } else if (state is RankListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
