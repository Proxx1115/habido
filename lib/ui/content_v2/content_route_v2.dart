import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/ui/content_v2/content_bloc_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ContentRouteV2 extends StatefulWidget {
  final int contentId;

  const ContentRouteV2({
    Key? key,
    required this.contentId,
  }) : super(key: key);

  @override
  State<ContentRouteV2> createState() => _ContentRouteV2State();
}

class _ContentRouteV2State extends State<ContentRouteV2> {
  /// CONTENT
  ContentV2? _content;

  /// ScrollController
  late ScrollController _scrollController;
  double _scrollPosition = 0;

  String title = 'Зөвлөмж';

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    /// GET_CONTENT_EVENT
    BlocManager.contentBlocV2.add(GetContentEventV2(widget.contentId));
    super.initState();
  }

  _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition > 30) {
      title = _content?.title ?? '';
    } else {
      title = "Зөвлөмж";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: title,
      child: BlocProvider.value(
        value: BlocManager.contentBlocV2,
        child: BlocListener<ContentBlocV2, ContentStateV2>(
          listener: _blocListener,
          child: BlocBuilder<ContentBlocV2, ContentStateV2>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ContentStateV2 state) {
    if (state is ContentSuccessV2) {
      _content = state.content;
    } else if (state is ContentFailedV2) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, ContentStateV2 state) {
    return Column(
      children: [
        // Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //   child: Row(
        //     children: [
        //       InkWell(
        //         onTap: () {
        //           Navigator.pop(context);
        //         },
        //         child: SvgPicture.asset(
        //           Assets.arrow_back,
        //           fit: BoxFit.scaleDown,
        //           color: customColors.iconGrey,
        //           height: 15,
        //         ),
        //       ),
        //       const SizedBox(width: 12),
        //       CustomText(
        //         title,
        //         fontSize: 15,
        //         fontWeight: FontWeight.w500,
        //         maxLines: 3,
        //       )
        //     ],
        //   ),
        // ),
        if (_content != null)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return _contentDesc(_content!);
              },
            ),
          ),
      ],
    );
  }

  Widget _contentDesc(ContentV2 content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 15),

          /// Title
          CustomText(
            content.title ?? '',
            fontWeight: FontWeight.w600,
            maxLines: 2,
            fontSize: 19,
            color: customColors.primaryText,
          ),
          SizedBox(height: 10),

          /// Cover image
          Hero(
            tag: Func.toStr(content.contentId),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: content.contentPhoto!,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: 175,
                // height: _imageWidth! * SizeHelper.contentImageRatio,
                alignment: Alignment.topCenter,
                placeholder: (context, url) => CustomLoader(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),

          /// Text
          Container(
            margin: EdgeInsets.only(top: 10.0),
            // padding: SizeHelper.boxPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Нийтэлсэн: ${Func.toDateTimeStr(content.createdAt!)}",
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: customColors.lightText,
                    ),
                    Row(
                      children: [
                        CustomText(
                          "Сэтгэл зүй",
                          maxLines: 2,
                          fontSize: 11,
                          color: customColors.primary,
                          fontWeight: FontWeight.w300,
                        ),
                        CustomText(
                          " |  ${content.readTime} мин",
                          maxLines: 2,
                          fontSize: 11,
                          color: customColors.primaryText,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: customColors.greyBackground,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                /// Body
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Html(
                      shrinkWrap: true,
                      style: {
                        'html': Style(
                          textAlign: TextAlign.justify,
                        ),
                      },
                      data: content.text ?? ''),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        BlocManager.contentBlocV2.add(GetContentLikeEvent(content.contentId!));
                        BlocManager.contentBlocV2.add(GetContentEventV2(widget.contentId));
                      },
                      child: content.isLiked! ? SvgPicture.asset(Assets.heartRed) : SvgPicture.asset(Assets.heart),
                    ),
                    Row(
                      children: [
                        CustomText(
                          "Нийтэлсэн: ${Func.toDateTimeStr(content.createdAt!)}",
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: customColors.lightText,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
