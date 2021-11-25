import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/param_bloc.dart';
import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class TermsRoute extends StatefulWidget {
  const TermsRoute({Key? key}) : super(key: key);

  @override
  _TermsRouteState createState() => _TermsRouteState();
}

class _TermsRouteState extends State<TermsRoute> {
  // Param response
  List<TermsOfService>? _termsOfService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => BlocManager.paramBloc.add(GetParamEvent()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.paramBloc,
      child: BlocListener<ParamBloc, ParamState>(
        listener: _blocListener,
        child: BlocBuilder<ParamBloc, ParamState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ParamState state) {
    if (state is ParamSuccess) {
      if (state.response.termsOfService != null &&
          state.response.termsOfService!.length > 0) {
        _termsOfService = state.response.termsOfService;
      }
    } else if (state is ParamFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, ParamState state) {
    return (_termsOfService != null && _termsOfService!.length > 0)
        ? CustomScaffold(
            appBarTitle: LocaleKeys.termsOfService,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var el in _termsOfService!) _listItem(el),
                ],
              ),
            ),
          )
        : Container();
  }

  _listItem(TermsOfService termsOfService) {
    return StadiumContainer(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: InfoContainer(
        title: termsOfService.title ?? '',
        body: termsOfService.body ?? '',
      ),
    );
  }
}
