import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';

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
          _body(),
        ],
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
