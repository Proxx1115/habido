import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/psy_category.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'psy_tests_bloc.dart';

class PsyTestsRoute extends StatefulWidget {
  final PsyCategory psyCategory;

  const PsyTestsRoute({Key? key, required this.psyCategory}) : super(key: key);

  @override
  _PsyTestsRouteState createState() => _PsyTestsRouteState();
}

class _PsyTestsRouteState extends State<PsyTestsRoute> {
  // UI
  final _categoryTestsKey = GlobalKey<ScaffoldState>();
  late PsyTestBloc _categoryTestsBloc;

  // Data
  Content? _content;
  List<PsyTest>? _psyTestList;

  @override
  void initState() {
    _categoryTestsBloc = PsyTestBloc();
    _categoryTestsBloc.add(GetPsyTestsEvent(widget.psyCategory.testCatId ?? -99));
    super.initState();
  }

  @override
  void dispose() {
    _categoryTestsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _categoryTestsKey,
      appBarTitle: widget.psyCategory.name,
      body: BlocProvider.value(
        value: _categoryTestsBloc,
        child: BlocListener<PsyTestBloc, PsyTestState>(
          listener: _blocListener,
          child: BlocBuilder<PsyTestBloc, PsyTestState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  padding: SizeHelper.paddingScreen,
                  child: Column(
                    children: <Widget>[
                      /// Content
                      if (_content != null) HorizontalContentCard(content: _content!),

                      // /// Psy test list
                      // if (_psyTestList != null && _psyTestList!.length > 0)
                      //   for (var el in _psyTestList!) _testCategoryItem(el),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PsyTestState state) {
    if (state is PsyTestsSuccess) {
      _content = state.psyTestsResponse.content;
      _psyTestList = state.psyTestsResponse.psyTestList;
    } else if (state is PsyTestsFailed) {
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

  Widget _testCategoryItem(PsyTest psyTest) {
    return Container();
    // return CategoryContainer(
    //   imageUrl: testCategory.photo,
    //   backgroundColor: testCategory.color,
    //   text: testCategory.name! + 'asdasd',
    //   onPressed: () {
    //     Navigator.pushNamed(context, Routes.testCategories);
    //   },
    // );
  }
}
