import 'package:flutter/material.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/widgets/buttons.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Login'),
            Btn(
              context: context,
              text: 'LOGIN',
              onPressed: () async {
                var res = await ApiRouter.login(LoginRequest(username: '88989800', password: '123456'));
                print(res.code);
                print(res.token);
              },
            ),
          ],
        ),
      ),
    );
  }
}
