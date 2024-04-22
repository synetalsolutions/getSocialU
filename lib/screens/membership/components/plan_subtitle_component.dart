import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';

import '../../../utils/app_constants.dart';

class PlanSubtitleComponent extends StatelessWidget {
  final MembershipModel plan;
  final int? size;
  final Color? color;

  PlanSubtitleComponent({required this.plan, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (plan.initialPayment == plan.billingAmount)
          Text(
            '${pmpStore.pmpCurrency}${plan.initialPayment} ${plan.cycleNumber == '1' ? 'per ${plan.cyclePeriod}' : 'every ${plan.cycleNumber} ${plan.cyclePeriod}'}',
            style: boldTextStyle(
                color: color != null
                    ? color
                    : appStore.isDarkMode
                        ? bodyDark
                        : bodyWhite,
                size: size ?? 14),
          )
        else if (plan.initialPayment != plan.billingAmount)
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${pmpStore.pmpCurrency}${plan.initialPayment}',
                  style: boldTextStyle(
                      size: size ?? 14,
                      fontFamily: fontFamily,
                      color: color != null
                          ? color
                          : appStore.isDarkMode
                              ? bodyDark
                              : bodyWhite),
                ),
                TextSpan(
                  text: ' now and then',
                  style: secondaryTextStyle(fontFamily: fontFamily, size: size ?? 14,color: color ?? textSecondaryColorGlobal),
                ),
                TextSpan(
                  text: ' ${pmpStore.pmpCurrency}${plan.billingAmount} ${plan.cycleNumber == '1' ? 'per ${plan.cyclePeriod}' : 'every ${plan.cycleNumber} ${plan.cyclePeriod}'}',
                  style: boldTextStyle(
                      size: size ?? 14,
                      fontFamily: fontFamily,
                      color: color != null
                          ? color
                          : appStore.isDarkMode
                              ? bodyDark
                              : bodyWhite),
                ),
              ],
            ),
          ),
        if (plan.expirationNumber != "0" && plan.expirationPeriod.validate().isNotEmpty)
          Text(
            '${language.membershipExpiresAfter} ${plan.expirationNumber} ${plan.expirationPeriod}.',
            style: secondaryTextStyle(
                color: color != null
                    ? color
                    : appStore.isDarkMode
                        ? bodyDark
                        : bodyWhite),
          ).paddingTop(8),
      ],
    );
  }
}
