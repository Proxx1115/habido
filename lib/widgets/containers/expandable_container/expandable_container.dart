import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/text.dart';

class ExpandableContainer extends StatefulWidget {
  final String title;
  final List<ExpandableListItem> expandableListItems;

  const ExpandableContainer({
    Key? key,
    required this.title,
    required this.expandableListItems,
  }) : super(key: key);

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
    _expandedHeight = widget.expandableListItems.length * (_listItemHeight + _liteItemMarginBottom);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header
        _header(),

        /// Body
        _body(),
      ],
    );
  }

  Widget _header() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
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
    );
  }

  Widget _body() {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: _isExpanded ? _expandedHeight : _collapsedHeight,
      child: Container(
        child: ListView(
          children: List.generate(
            widget.expandableListItems.length,
            (index) => Container(
              margin: EdgeInsets.only(bottom: _liteItemMarginBottom),
              child: widget.expandableListItems[index],
            ),
          ),
        ),
      ),
    );
  }
}

// class ExpandableContainer extends StatelessWidget {
//   final bool expanded;
//   final double collapsedHeight;
//   final double expandedHeight;
//   final Widget child;
//
//   ExpandableContainer({
//     required this.child,
//     this.collapsedHeight = 0.0,
//     this.expandedHeight = 300.0,
//     this.expanded = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return new AnimatedContainer(
//       duration: new Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       width: screenWidth,
//       height: expanded ? expandedHeight : collapsedHeight,
//       child: new Container(
//         child: child,
//         decoration: new BoxDecoration(border: new Border.all(width: 1.0, color: Colors.blue)),
//       ),
//     );
//   }
// }
