// import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class TestRoute extends StatefulWidget {
//   static const PREFERENCES_IS_FIRST_LAUNCH_STRING = "PREFERENCES_IS_FIRST_LAUNCH_STRING";
//
//   @override
//   _TestRouteState createState() => _TestRouteState();
// }
//
// class _TestRouteState extends State<TestRoute> {
//   GlobalKey _one = GlobalKey();
//   // BuildContext myContext;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback(
//             (_) {
//           _isFirstLaunch().then((result){
//             if(result)
//               ShowCaseWidget.of(myContext).startShowCase([_one]);
//           });
//         }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ShowCaseWidget(
//       // onFinish: ,
//         builder:
//         Builder(builder: (context) {
//           myContext = context;
//           return Scaffold(
//             floatingActionButton: Showcase(
//               key: _one,
//               title: 'Title',
//               description: 'Desc',
//               child: InkWell(
//                   onTap: () {},
//                   child: FloatingActionButton(
//                       onPressed: () {
//                         print("floating");
//                       }
//                   )
//               ),
//             ),
//           );
//         }));
//   }
//
//   Future<bool> _isFirstLaunch() async{
//     final sharedPreferences = await SharedPreferences.getInstance();
//     bool isFirstLaunch = sharedPreferences.getBool(TestRoute.PREFERENCES_IS_FIRST_LAUNCH_STRING) ?? true;
//
//     if(isFirstLaunch)
//       sharedPreferences.setBool(TestRoute.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
//
//     return isFirstLaunch;
//   }
// }