import 'package:flutter/cupertino.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/common_gamipress_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BadgeDetailScreen extends StatelessWidget {
  final CommonGamiPressModel data;
  const BadgeDetailScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: data.title!.rendered.validate(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  if (data.authorName.validate().isNotEmpty) ...[
                    TextSpan(text: '${data.authorName.validate()} ', style: secondaryTextStyle(size: 14, fontFamily: fontFamily)),
                    if (data.isUserVerified.validate())
                      WidgetSpan(
                        child: Image.asset(ic_tick_filled, height: 16, width: 16, color: blueTickColor, fit: BoxFit.cover),
                      ),
                    TextSpan(text: '  |  ', style: secondaryTextStyle(size: 14, fontFamily: fontFamily)),
                  ],
                  TextSpan(text: getFormattedDate(data.date.validate()), style: secondaryTextStyle(size: 14, fontFamily: fontFamily)),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ).paddingBottom(16),
            if (data.image.validate().isNotEmpty)
              cachedImage(
                data.image.validate(),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            16.height,
            if (data.hasEarned.validate()) ...[
              Text(language.youHaveEarnedBadge, style: primaryTextStyle()),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appGreenColor.withAlpha(30),
                  border: Border(left: BorderSide(color: appGreenColor, width: 2)),
                ),
                child: Text(language.congratulatesYouAreAchieve, style: primaryTextStyle(color: appGreenColor)),
              ),
            ],
            Text(parseHtmlString(data.content!.rendered.validate()), style: secondaryTextStyle(size: 16)),
          ],
        ),
      ),
    );
  }
}
