// import 'package:flutter/material.dart';
// import 'package:habido_app/widgets/scaffold.dart';
//
// class HintRoute extends StatefulWidget {
//   const HintRoute({Key? key}) : super(key: key);
//
//   @override
//   _HintRouteState createState() => _HintRouteState();
// }
//
// class _HintRouteState extends State<HintRoute> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBarTitle: LocaleKeys.notification,
//       child: SingleChildScrollView(
//         padding: SizeHelper.paddingScreen,
//         child: BlocProvider.value(
//           value: BlocManager.notifBloc,
//           child: BlocListener<NotificationBloc, NotificationState>(
//             listener: _blocListener,
//             child: BlocBuilder<NotificationBloc, NotificationState>(
//               builder: (context, state) {
//                 return (_notifList != null && _notifList!.isNotEmpty)
//                     ? Column(
//                         children: List.generate(
//                           _notifList!.length,
//                           (index) => ListItemContainer(
//                             margin: EdgeInsets.only(bottom: 10.0),
//                             height: 70.0,
//                             leadingImageUrl: _notifList![index].photo,
//                             leadingBackgroundColor: HexColor.fromHex(_notifList![index].color ?? '#F4F6F8'),
//                             title: _notifList![index].title ?? '',
//                             body: _notifList![index].body,
//                             onPressed: () {
//                               // Navigator.pushNamed(context, Routes.psyIntro, arguments: {
//                               //   'psyTest': el,
//                               // });
//                             },
//                           ),
//                         ),
//                       )
//                     : Container();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _screen() {
//     return Container();
//   }
// }
