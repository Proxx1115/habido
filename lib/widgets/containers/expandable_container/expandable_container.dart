import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/text.dart';

class ExpandableContainer extends StatefulWidget {
  final String title;
  final List<ExpandableListItem> expandableListItems;
  final EdgeInsets? margin;
  final bool isToday;
  final String? todayText;

  const ExpandableContainer(
      {Key? key,
      required this.title,
      required this.expandableListItems,
      this.margin,
      required this.isToday,
      this.todayText})
      : super(key: key);

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  // Expandable container
  bool _isExpanded = true;
  final _collapsedHeight = 0.0;
  late double _expandedHeight;

  // List item
  final _listItemHeight = SizeHelper.listItemHeight70;
  final _liteItemMarginBottom = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight = widget.expandableListItems.length *
        (_listItemHeight + _liteItemMarginBottom);

    return Container(
      margin: widget.margin,
      child: Column(
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
    List<String> parts = widget.todayText?.split('/') ?? ['one', 'two'];
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: FadeInAnimation(
          duration: 200,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                /// Icon
                RotatedBox(
                  quarterTurns: _isExpanded ? 0 : 3,
                  child: SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: SvgPicture.asset(Assets.expanded),
                  ),
                ),

                /// Title
                CustomText(
                  widget.title,
                  margin: EdgeInsets.only(left: 12.0),
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                ),

                /// ListItem done/total
                if (widget.isToday && widget.todayText != null)
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        CustomText(
                          parts[0],
                          fontSize: 19.0,
                          fontWeight: FontWeight.w500,
                          color: customColors.iconSeaGreen,
                        ),
                        CustomText(
                          '/' + parts[1],
                          fontSize: 19.0,
                          fontWeight: FontWeight.w500,
                          color: customColors.greyText
                        ),
                      ],
                    ),
                  ),
              ],
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
          widget.expandableListItems.length,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: _liteItemMarginBottom),
              child: widget.expandableListItems[index],
            ),
          ),
        ),
      ),
    );
  }
}
