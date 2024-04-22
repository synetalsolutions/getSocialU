import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/pmp_order_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/screens/pmp_order_detail_screen.dart';

import '../../../utils/app_constants.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  ScrollController _scrollController = ScrollController();

  List<PmpOrderModel> orderList = [];
  late Future<List<PmpOrderModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getOrdersList();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage && orderList.isNotEmpty) {
          mPage++;
          future = getOrdersList();
        }
      }
    });
  }

  Future<List<PmpOrderModel>> getOrdersList() async {
    appStore.setLoading(true);

    await pmpOrders(page: mPage).then((value) {
      if (mPage == 1) orderList.clear();

      mIsLastPage = value.length != 20;
      orderList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return orderList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.pastInvoices,
      child: FutureBuilder<List<PmpOrderModel>>(
        future: future,
        builder: (ctx, snap) {
          if (snap.hasError) {
            return NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.somethingWentWrong,
            ).center();
          }
          if (snap.hasData) {
            if (snap.data.validate().isEmpty) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: language.noDataFound,
              ).center();
            } else {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 60),
                child: Table(
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
                    ...orderList.map((e) {
                      return TableRow(
                        children: [
                          Text(
                            DateFormat(DATE_FORMAT_5).format(DateTime.parse(e.timestamp.validate())),
                            style: secondaryTextStyle(),
                          ).center().paddingSymmetric(horizontal: 8, vertical: 8).onTap(() {
                            PmpOrderDetailScreen(orderDetail: e).launch(context);
                          }),
                          Text(e.membershipName.validate(), style: secondaryTextStyle()).center().paddingSymmetric(vertical: 8),
                          Text('${pmpStore.pmpCurrency}${e.total.validate()}', style: secondaryTextStyle()).center().paddingSymmetric(vertical: 8),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            }
          }

          return Offstage();
        },
      ),
    );
  }
}
