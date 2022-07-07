import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingItem extends StatelessWidget {
  final String answerImageUrl;
  final String answerText;
  final String? date;
  final bool state;
  final List<String> reasons;
  final String writtenAnswer;
  final int maxLines;

  const FeelingItem(
      {Key? key,
      required this.answerImageUrl,
      required this.answerText,
      required this.reasons,
      required this.writtenAnswer,
      this.date,
      required this.maxLines,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: customColors.greyBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: answerImageUrl,
                  placeholder: (context, url) => Container(),
                  //CustomLoader(),
                  errorWidget: (context, url, error) => Container(),
                  height: 30.0,
                  // width: 40.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        answerText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      state
                          ? date != null
                              ? CustomText(
                                  Func.toDateStr(
                                    Func.toDate(date ?? ""),
                                    dateFormat: 'yyyy-MM-dd  hh:mm',
                                  ).toString(),
                                  color: customColors.cornflowerText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  alignment: Alignment.bottomRight,
                                )
                              : Container()
                          : Container()
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (var reasons in reasons)
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                            margin: EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                              color: customColors.primaryButtonDisabledContent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomText(
                              reasons,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ))
            ],
          ),
          const SizedBox(height: 10),
          writtenAnswer.isNotEmpty
              ? Column(
                  children: [
                    HorizontalLine(
                      color: customColors.primaryButtonDisabledContent,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      writtenAnswer,
                      maxLines: maxLines,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                )
              : Container(),
          state
              ? Container()
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    date != null
                        ? CustomText(
                            Func.toDateStr(
                              Func.toDate(date ?? ""),
                              dateFormat: 'yyyy-MM-dd  hh:mm',
                            ).toString(),
                            color: customColors.cornflowerText,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            alignment: Alignment.bottomRight,
                          )
                        : Container(),
                  ],
                )
        ],
      ),
    );
  }
}
