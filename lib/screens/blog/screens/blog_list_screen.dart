import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/wp_post_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/components/blog_card_component.dart';

import '../../../utils/app_constants.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  ScrollController _controller = ScrollController();

  List<WpPostResponse> blogList = [];
  late Future<List<WpPostResponse>> future;
  TextEditingController searchController = TextEditingController();

  List<String> tags = [];
  String category = '';
  int mPage = 1;
  bool mIsLastPage = false;
  bool isChange = false;
  bool isError = false;
  bool hasShowClearTextIcon = false;

  @override
  void initState() {
    future = getBlogs();

    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});

          future = getBlogs();
        }
      }
    });

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        showClearTextIcon();
      } else {
        hasShowClearTextIcon = false;
        setState(() {});
      }
    });
  }

  void showClearTextIcon() {
    if (!hasShowClearTextIcon) {
      hasShowClearTextIcon = true;
      setState(() {});
    } else {
      return;
    }
  }

  Future<List<WpPostResponse>> getBlogs() async {
    appStore.setLoading(true);

    await getBlogList(page: mPage, searchText: searchController.text.trim()).then((value) {
      if (mPage == 1) blogList.clear();
      mIsLastPage = value.length != PER_PAGE;
      blogList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return blogList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getBlogs();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.blogs, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            16.height,
            Container(
              width: context.width() - 32,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: AppTextField(
                controller: searchController,
                textFieldType: TextFieldType.USERNAME,
                onFieldSubmitted: (text) {
                  mPage = 1;
                  future = getBlogs();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: language.searchHere,
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: Image.asset(
                    ic_search,
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    color: appStore.isDarkMode ? bodyDark : bodyWhite,
                  ).paddingAll(16),
                  suffixIcon: hasShowClearTextIcon
                      ? IconButton(
                          icon: Icon(Icons.cancel, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                          onPressed: () {
                            hideKeyboard(context);
                            hasShowClearTextIcon = false;
                            searchController.clear();

                            mPage = 1;
                            getBlogs();
                            setState(() {});
                          },
                        )
                      : null,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                FutureBuilder<List<WpPostResponse>>(
                  future: future,
                  builder: (ctx, snap) {
                    if (snap.hasError) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError ? language.somethingWentWrong : language.noDataFound,
                        onRetry: () {
                          onRefresh();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    }

                    if (snap.hasData) {
                      if (snap.data.validate().isEmpty) {
                        return NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: isError ? language.somethingWentWrong : language.noDataFound,
                          onRetry: () {
                            onRefresh();
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ).center();
                      } else {
                        return AnimatedListView(
                          slideConfiguration: SlideConfiguration(
                            delay: 80.milliseconds,
                            verticalOffset: 300,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                          itemCount: blogList.length,
                          itemBuilder: (context, index) {
                            WpPostResponse data = blogList[index];
                            return BlogCardComponent(data: data);
                          },
                        );
                      }
                    }
                    return Offstage();
                  },
                ),
                Observer(
                  builder: (_) {
                    if (appStore.isLoading) {
                      if (mPage != 1) {
                        return Positioned(
                          bottom: 10,
                          child: LoadingWidget(isBlurBackground: false),
                        );
                      } else {
                        return LoadingWidget(isBlurBackground: false).paddingTop(context.height() * 0.3);
                      }
                    } else {
                      return Offstage();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
