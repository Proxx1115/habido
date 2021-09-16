import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/text.dart';
import 'expandable_card_list_item.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final List<ExpandableCardListItem> expandableCardListItems;
  final EdgeInsets? margin;

  const ExpandableCard({
    Key? key,
    required this.title,
    required this.expandableCardListItems,
    this.margin,
  }) : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
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
    _expandedHeight = widget.expandableCardListItems.length * (_listItemHeight + _liteItemMarginBottom);

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
    return InkWell(
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
              Expanded(
                child: CustomText(
                  widget.title,
                  margin: EdgeInsets.only(left: 12.0),
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
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
      child: Column(
        children: List.generate(
          widget.expandableCardListItems.length,
              (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: _liteItemMarginBottom),
              child: widget.expandableCardListItems[index],
            ),
          ),
        ),
      ),
    );
  }
}
