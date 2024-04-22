import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/pmp_order_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/screens/all_orders_screen.dart';
import 'package:socialv/screens/membership/screens/pmp_order_detail_screen.dart';

import '../../../utils/app_constants.dart';

class PastInvoicesComponent extends StatefulWidget {
  const PastInvoicesComponent({Key? key}) : super(key: key);

  @override
  State<PastInvoicesComponent> createState() => _PastInvoicesComponentState();
}

class _PastInvoicesComponentState extends State<PastInvoicesComponent> {
  late Future<List<PmpOrderModel>> future;
  List<PmpOrderModel> orderList = [];

  @override
  void initState() {
    future = getOrders();
    super.initState();
  }

  Future<List<PmpOrderModel>> getOrders({String? status}) async {
    await pmpOrders().then((value) {
      orderList = value;
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    return orderList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (orderList.isNotEmpty)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.width(),
            color: context.cardColor,
            margin: EdgeInsets.symmetric(vertical: 16),
            padding: EdgeInsets.all(16),
            child: Text(language.pastInvoices, style: boldTextStyle(color: context.primaryColor)),
          ),
          Table(
            border: TableBorder.all(color: appStore.isDarkMode ? bodyDark : bodyWhite, style: BorderStyle.solid, width: 1),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  Text(language.date, style: primaryTextStyle()).center().paddingSymmetric(vertical: 8),
                  Text(language.plan, style: primaryTextStyle()).center().paddingSymmetric(vertical: 8),
                  Text(language.amount, style: primaryTextStyle()).center().paddingSymmetric(vertical: 8),
                ],
              ),
              ...orderList.take(5).map((e) {
                return TableRow(
                  children: [
                    Text(
                      DateFormat(DATE_FORMAT_5).format(DateTime.parse(e.timestamp.validate())),
                      style: secondaryTextStyle(color: context.primaryColor),
                    ).center().paddingSymmetric(horizontal: 8, vertical: 8).onTap(() {
                      PmpOrderDetailScreen(orderDetail: e).launch(context);
                    }),
                    Text(e.membershipName.validate(), style: secondaryTextStyle()).center().paddingSymmetric(vertical: 8),
                    Text('${pmpStore.pmpCurrency}${e.total.validate()}', style: secondaryTextStyle()).center().paddingSymmetric(vertical: 8),
                  ],
                );
              }).toList(),
            ],
          ).paddingSymmetric(horizontal: 16),
          16.height,
          if (orderList.length > 5)
            TextButton(
              onPressed: () {
                AllOrdersScreen().launch(context);
              },
              child: Text(
                language.viewAllInvoices,
                style: primaryTextStyle(color: context.primaryColor),
              ),
            ).paddingSymmetric(horizontal: 8),
        ],
      );
    else
      return Offstage();
  }
}
