import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/param_bloc.dart';
import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FaqRoute extends StatefulWidget {
  const FaqRoute({Key? key}) : super(key: key);

  @override
  _FaqRouteState createState() => _FaqRouteState();
}

class _FaqRouteState extends State<FaqRoute> {
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();
  String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    BlocManager.paramBloc.add(GetParamEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.paramBloc,
      child: BlocListener<ParamBloc, ParamState>(
        listener: (context, state) {
          if (state is ParamSuccess) {
            _url = state.response.faqLink;
          } else if (state is ParamFailed) {
            showCustomDialog(
              context,
              isDismissible: false,
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
        },
        child: BlocBuilder<ParamBloc, ParamState>(
          builder: (context, state) {
            return CustomScaffold(
              loading: state is ParamLoading,
              appBarTitle: LocaleKeys.faq,
              child: Func.isNotEmpty(_url) ? _webViewer() : Container(),
            );
          },
        ),
      ),
    );
  }

  Widget _webViewer() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      child: Container(
        padding: SizeHelper.screenPadding,
        child: WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _loading = false;
            });
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message.message),
        ));
      },
    );
  }
}
