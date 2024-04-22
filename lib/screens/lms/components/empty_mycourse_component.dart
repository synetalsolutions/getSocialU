import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/constants.dart';

class EmptyMyCourseComponent extends StatelessWidget {
  const EmptyMyCourseComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/book-outline.gif', height: 100, width: 100, fit: BoxFit.cover),
        16.height,
        Text(language.youHaveNotEnrolled, style: primaryTextStyle()),
        16.height,
        InkWell(
          onTap: () {
            finish(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(commonRadius)),
            child: Text(language.viewCourses, style: boldTextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
