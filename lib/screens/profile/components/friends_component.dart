import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../main.dart';
import '../../../utils/app_constants.dart';

class FriendsComponent extends StatefulWidget {
  final VoidCallback? callback;

  FriendsComponent({this.callback});

  @override
  State<FriendsComponent> createState() => _FriendsComponentState();
}

class _FriendsComponentState extends State<FriendsComponent> with AutomaticKeepAliveClientMixin {
  List<FriendRequestModel> list = [];
  late Future<List<FriendRequestModel>> future;

  ScrollController _scrollController = ScrollController();

  int totalFriend = 0;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;
  int? friendCount;

  @override
  void initState() {
    getFriendList(
      page: mPage,
      membersList: list,
      userId: appStore.loginUserId.toInt(),
      lastPageCallback: (b) => mIsLastPage = b,
      countCall: (p0) => friendCount = p0,
    );
    init();
    setStatusBarColor(Colors.transparent);
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          appStore.setLoading(true);
          init();
        }
      }
    });

    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    LiveStream().on(OnRequestAccept, (p0) {
      list.clear();
      mPage = 1;
      appStore.setLoading(true);
      init();
      widget.callback?.call();
    });
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getFriendList(
      page: mPage,
      membersList: list,
      userId: appStore.loginUserId.toInt(),
      lastPageCallback: (b) => mIsLastPage = b,
      countCall: (p0) => friendCount = p0,
    ).whenComplete(() {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnRequestAccept);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: context.width(),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
      ),
      child: Stack(
        alignment: isError || list.isEmpty ? Alignment.center : Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: PageScrollPhysics(),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) Text('${language.totalFriends} ( $friendCount )', style: boldTextStyle()).paddingAll(16),
                SnapHelperWidget(
                  future: future,
                  loadingWidget: Offstage(),
                  errorBuilder: (p0) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        isError = false;
                        mPage = 1;
                        init();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  },
                  onSuccess: (data) {
                    if(data.isEmpty)
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError ? language.somethingWentWrong : language.noDataFound,
                        onRetry: () {
                          isError = false;
                          mPage = 1;
                          init();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    return AnimatedListView(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        FriendRequestModel friend = list[index];

                        return Row(
                          children: [
                            cachedImage(
                              friend.userImage.validate(),
                              height: 42,
                              width: 42,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(100),
                            12.width,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: '${friend.userName.validate()} ', style: boldTextStyle(fontFamily: fontFamily)),
                                      if (friend.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                4.height,
                                Text(friend.userMentionName.validate(), style: secondaryTextStyle()),
                              ],
                            ).expand(),
                            8.width,
                            IconButton(
                              onPressed: () {
                                if (!appStore.isLoading)
                                  showConfirmDialogCustom(
                                    context,
                                    dialogType: DialogType.CONFIRMATION,
                                    title: language.areYouSureUnfriend,
                                    positiveText: language.unfriend,
                                    primaryColor: context.primaryColor,
                                    onAccept: (c) {
                                      ifNotTester(
                                        () {
                                          appStore.setLoading(true);
                                          removeExistingFriendConnection(
                                            friendId: friend.userId.validate().toString(),
                                            passRequest: true,
                                          ).then((value) {
                                            appStore.setLoading(false);
                                            mPage = 1;
                                            appStore.setLoading(true);
                                            init();
                                            if (value.deleted.validate()) {
                                              widget.callback?.call();
                                            }
                                          }).catchError((e) {
                                            appStore.setLoading(false);
                                            toast(e.toString(), print: true);
                                          });
                                        },
                                      );
                                    },
                                  );
                              },
                              icon: Image.asset(
                                ic_close_square,
                                color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(
                          () async {
                            MemberProfileScreen(memberId: friend.userId.validate()).launch(context).then(
                              (value) {
                                if (value ?? false) {
                                  mPage = 1;
                                  appStore.setLoading(true);
                                  init();
                                  widget.callback?.call();
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Observer(
            builder: (_) {
              if (appStore.isLoading) {
                return Positioned(
                  bottom: mPage != 1 ? 10 : null,
                  child: LoadingWidget(isBlurBackground: true),
                );
              } else {
                return Offstage();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
