import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/rewards_model.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class LevelComponent extends StatelessWidget {
  final Rank? rank;
  const LevelComponent({this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank == null)
      return SizedBox(
        height: context.height() * 0.7,
        child: NoDataWidget(
          imageWidget: NoDataLottieWidget(),
          title: language.userNotAchievedLevel,
        ),
      );
    else
      return Container(
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rank!.image.validate().isNotEmpty)
              cachedImage(
                rank!.image.validate(),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
            else
              cachedImage(
                level_image,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            16.height,
            Text(rank!.name.validate(), style: boldTextStyle(size: 20, color: context.primaryColor)),
          ],
        ),
      );
  }
}
