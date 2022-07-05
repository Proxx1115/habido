import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item_v2.dart';
import 'package:habido_app/widgets/text.dart';

class ExpandableContainerV2 extends StatefulWidget {
  final String title;
  final List<ExpandableListItemV2> expandableListItems;
  final EdgeInsets? margin;
  final bool? isToday;
  final String? todayText;

  const ExpandableContainerV2({Key? key, required this.title, required this.expandableListItems, this.margin, this.isToday, this.todayText})
      : super(key: key);

  @override
  _ExpandableContainerV2State createState() => _ExpandableContainerV2State();
}

class _ExpandableContainerV2State extends State<ExpandableContainerV2> {
  // Expandable container
  bool _isExpanded = true;
  final _collapsedHeight = 0.0;
  late double _expandedHeight;

  // List item
  final _listItemHeight = 60;
  final _liteItemMarginBottom = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight = (widget.expandableListItems.length / 2).ceil() * (60 + _liteItemMarginBottom + 20);

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
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Title
              CustomText(
                widget.title,
                margin: EdgeInsets.only(left: 12.0),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),

              /// Icon
              Container(
                width: 10,
                height: 10,
                padding: EdgeInsets.zero,
                child: RotatedBox(
                  quarterTurns: _isExpanded ? 0 : 5,
                  child: SvgPicture.asset(
                    Assets.downArrow,
                  ),
                ),
              ),
            ],
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
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: ((MediaQuery.of(context).size.width - 55) / 2) / 73,
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        padding: EdgeInsets.all(15),
        children: [
          for (var el in widget.expandableListItems)
            Container(
              // margin: EdgeInsets.only(bottom: _liteItemMarginBottom),
              child: el,
            ),
        ],
      ),
    );
  }
}
