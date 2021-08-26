import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_test_question.dart';
import 'package:habido_app/ui/psy_test/psy_test/psy_test_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyTestRoute extends StatefulWidget {
  final PsyTest psyTest;

  const PsyTestRoute({
    Key? key,
    required this.psyTest,
  }) : super(key: key);

  @override
  _PsyTestRouteState createState() => _PsyTestRouteState();
}

class _PsyTestRouteState extends State<PsyTestRoute> {
  // UI
  final _psyTestKey = GlobalKey<ScaffoldState>();
  late PsyTestBloc _psyTestBloc;

  // Data
  int? _testId;
  int? _userTestId;
  List<PsyTestQuestion>? _questionList;

  @override
  void initState() {
    super.initState();
    _psyTestBloc = PsyTestBloc();
    _psyTestBloc.add(GetPsyTestQuestionsEvent(widget.psyTest.testId ?? -99));
  }

  @override
  void dispose() {
    _psyTestBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _psyTestKey,
      appBarTitle: widget.psyTest.name,
      body: BlocProvider.value(
        value: _psyTestBloc,
        child: BlocListener<PsyTestBloc, PsyTestState>(
          listener: _blocListener,
          child: Container(
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

  void _blocListener(BuildContext context, PsyTestState state) {
    if (state is PsyQuestionsSuccess) {
      _testId = state.response.testId;
      _userTestId = state.response.userTestId;
      _questionList = state.response.questionList;
    } else if (state is PsyQuestionsFailed) {
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
