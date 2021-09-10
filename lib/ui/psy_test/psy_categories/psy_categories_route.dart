import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'psy_category_bloc.dart';

class PsyCategoriesRoute extends StatefulWidget {
  const PsyCategoriesRoute({Key? key}) : super(key: key);

  @override
  _PsyCategoriesRouteState createState() => _PsyCategoriesRouteState();
}

class _PsyCategoriesRouteState extends State<PsyCategoriesRoute> {
  // UI
  final _psyCategoryKey = GlobalKey<ScaffoldState>();
  late PsyCategoryBloc _psyCategoryBloc;

  // Data
  List<PsyCategory>? _psyCategoryList;

  @override
  void initState() {
    _psyCategoryBloc = PsyCategoryBloc();
    _psyCategoryBloc.add(GetPsyCategoriesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _psyCategoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _psyCategoryBloc,
      child: BlocListener<PsyCategoryBloc, PsyCategoryState>(
        listener: _blocListener,
        child: BlocBuilder<PsyCategoryBloc, PsyCategoryState>(
          builder: (context, state) {
            return CustomScaffold(
              scaffoldKey: _psyCategoryKey,
              appBarTitle: LocaleKeys.psyTest,
              child: (_psyCategoryList != null && _psyCategoryList!.isNotEmpty)
                  ? GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(SizeHelper.padding),
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      children: List.generate(
                        _psyCategoryList!.length,
                        (index) => _testCategoryItem(_psyCategoryList![index]),
                      ),
                    )
                  : Container(),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PsyCategoryState state) {
    if (state is PsyCategoriesSuccess) {
      _psyCategoryList = state.psyCategoryList;
    } else if (state is PsyCategoriesFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _testCategoryItem(PsyCategory psyCategory) {
    return FadeInAnimation(
      child: GridItemContainer(
        imageUrl: psyCategory.photo,
        backgroundColor: psyCategory.color,
        text: psyCategory.name ?? '',
        onPressed: () {
          Navigator.pushNamed(context, Routes.psyTests, arguments: {
            'psyCategory': psyCategory,
          });
        },
      ),
    );
  }
}
