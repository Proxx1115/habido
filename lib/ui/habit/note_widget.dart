import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class NoteWidget extends StatelessWidget {
  final UserHabit userHabit;
  final EdgeInsets? margin;

  const NoteWidget({Key? key, required this.userHabit, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: margin,
      padding: SizeHelper.boxPadding,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final _noteController = TextEditingController();
              _noteController.text = userHabit.userNote ?? '';

              showCustomDialog(
                context,
                isDismissible: true,
                child: GestureDetector(
                  onTap: () {
                    Func.hideKeyboard(context);
                  },
                  child: CustomDialogBody(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _noteController,
                          alwaysVisibleSuffix: false,
                          hintText: LocaleKeys.note,
                          maxLines: 5,
                          autofocus: true,
                        ),
                        CustomButton(
                          text: LocaleKeys.save,
                          onPressed: () {
                            var userHabit = this.userHabit;
                            userHabit.userNote = _noteController.text;
                            BlocManager.userHabitBloc.add(UpdateUserHabitEvent(userHabit));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                /// Title
                Expanded(
                  child: CustomText(LocaleKeys.note, fontWeight: FontWeight.w500),
                ),

                /// Edit button
                SvgPicture.asset(Assets.edit),
              ],
            ),
          ),

          /// Divider
          HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Body
          CustomText(userHabit.userNote, maxLines: 10),
        ],
      ),
    );
  }
}

// class NoteWidget extends StatefulWidget {
//   final UserHabit userHabit;
//   final EdgeInsets? margin;
//
//   const NoteWidget({Key? key, required this.userHabit, this.margin}) : super(key: key);
//
//   @override
//   _NoteWidgetState createState() => _NoteWidgetState();
// }
//
// class _NoteWidgetState extends State<NoteWidget> {
//   // final _noteController = TextEditingController();
//
//   @override
//   void initState() {
//     // _noteController.text = widget.userHabit.userNote ?? '';
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StadiumContainer(
//       margin: widget.margin,
//       padding: SizeHelper.boxPadding,
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () {
//               final _noteController = TextEditingController();
//               _noteController.text = widget.userHabit.userNote ?? '';
//
//               showCustomDialog(
//                 context,
//                 isDismissible: true,
//                 child: GestureDetector(
//                   onTap: () {
//                     Func.hideKeyboard(context);
//                   },
//                   child: CustomDialogBody(
//                     height: 350.0,
//                     buttonText: LocaleKeys.save,
//                     onPressedButton: () {
//                       var userHabit = widget.userHabit;
//                       userHabit.userNote = _noteController.text;
//                       BlocManager.userHabitBloc.add(UpdateUserHabitEvent(widget.userHabit));
//                     },
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           controller: _noteController,
//                           alwaysVisibleSuffix: false,
//                           hintText: LocaleKeys.note,
//                           maxLines: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: Row(
//               children: [
//                 /// Title
//                 Expanded(
//                   child: CustomText(LocaleKeys.note, fontWeight: FontWeight.w500),
//                 ),
//
//                 /// Edit button
//                 SvgPicture.asset(Assets.edit),
//               ],
//             ),
//           ),
//
//           /// Divider
//           HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),
//
//           /// Body
//           CustomText(widget.userHabit.userNote, maxLines: 10),
//         ],
//       ),
//     );
//   }
// }
