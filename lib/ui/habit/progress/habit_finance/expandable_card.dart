import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';
import 'expandable_card_list_item.dart';

class ExpandableCard extends StatefulWidget {
  final EdgeInsets? margin;
  final Color? primaryColor;
  final String title;
  final List<HabitProgress> habitProgressList;
  final Widget? child;

  const ExpandableCard({
    Key? key,
    this.margin,
    this.primaryColor,
    required this.title,
    required this.habitProgressList,
    this.child,
  }) : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  // Expandable container
  bool _isExpanded = true;
  final _collapsedHeight = 0.0;
  late double _expandedHeight;

  // Header
  final _expandedHeaderBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(SizeHelper.borderRadius),
    topRight: Radius.circular(SizeHelper.borderRadius),
  );

  final _collapsedHeaderBorderRadius = BorderRadius.circular(SizeHelper.borderRadius);

  // List item
  final _listItemHeight = SizeHelper.listItemHeight70;
  final _liteItemMarginBottom = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight = widget.habitProgressList.length * (_listItemHeight + _liteItemMarginBottom);

    return Container(
      margin: widget.margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          _header(),

          /// Body
          _body(),
        ],
      ),
    );
  }

  Widget _header() {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: MoveInAnimation(
          duration: 400,
          child: StadiumContainer(
            borderRadius: _isExpanded ? _expandedHeaderBorderRadius : _collapsedHeaderBorderRadius,
            padding: SizeHelper.boxPadding,
            child: Container(
              // margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  /// Title
                  Expanded(
                    child: CustomText(
                      widget.title,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  /// Icon
                  Container(
                    height: 24.0,
                    width: 24.0,
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor ?? customColors.primary,
                    ),
                    child: SvgPicture.asset(_isExpanded ? Assets.minus12 : Assets.plus12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: _isExpanded ? _expandedHeight : _collapsedHeight,
      child: Column(
        children: List.generate(
          widget.habitProgressList.length,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: _liteItemMarginBottom),
              child: ExpandableCardListItem(
                text: widget.habitProgressList[index].value ?? '',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
