import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/text.dart';
import 'content_bloc.dart';

class SuggestedContent extends StatefulWidget {
  final int contentId;
  final EdgeInsets? margin;

  const SuggestedContent({Key? key, required this.contentId, this.margin}) : super(key: key);

  @override
  _SuggestedContentState createState() => _SuggestedContentState();
}

class _SuggestedContentState extends State<SuggestedContent> {
  final _contentBloc = ContentBloc();
  Content? _content;

  @override
  void initState() {
    _contentBloc.add(GetContentEvent(widget.contentId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contentBloc,
      child: BlocListener<ContentBloc, ContentState>(
        listener: _blocListener,
        child: BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            return _content != null
                ? Container(
                    margin: widget.margin,
                    child: Column(
                      children: [
                        /// Танд санал болгох
                        SectionTitleText(text: LocaleKeys.suggestedForYou),

                        /// Content
                        HorizontalContentCard(
                          content: _content!,
                          margin: EdgeInsets.only(top: 20.0),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ContentState state) {
    if (state is ContentSuccess) {
      _content = state.content;
    } else if (state is ContentFailed) {
      print('content not found');
      // showCustomDialog(
      //   context,
      //   child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      // );
    }
  }
}
