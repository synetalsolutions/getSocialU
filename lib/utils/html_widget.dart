import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/table_view_widget.dart';
import 'package:socialv/components/vimeo_embed_widget.dart';
import 'package:socialv/components/youtube_embed_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/screens/blog_detail_screen.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/post/screens/pdf_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';

extension StringExtension on String {
  String get nonBreaking => replaceAll(' ', " ").replaceAll('&nbsp;', " ");
}

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;
  final double fontSize;
  final int? blogId;

  HtmlWidget({this.postContent, this.color, this.fontSize = 14.0, this.blogId});

  Style commonStyle({
    Color? backgroundColor,
    HtmlPaddings? padding,
    Border? border,
    Alignment? alignment,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    Margins? margin,
    ListStyleType? listStyleType,
    ListStylePosition? listStylePosition,
    Color? passedColor,
    TextAlign? textAlign,
  }) {
    return Style(
      backgroundColor: backgroundColor,
      lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
      padding: padding ?? HtmlPaddings.zero,
      border: border,
      color: passedColor != null ? passedColor : color ?? textPrimaryColorGlobal,
      alignment: alignment,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontSize: FontSize(fontSize),
      textDecoration: textDecoration,
      margin: margin,
      listStyleType: listStyleType,
      listStylePosition: listStylePosition,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (postContent.validate().contains('youtube_url')) YoutubeComponent(postContent: postContent.validate()),
        Html(
          data: postContent.validate().nonBreaking,
          onLinkTap: (s, _, __) {
            if (s!.split('/').last.contains('.pdf')) {
              PDFScreen(docURl: s).launch(context);
            } else {
              log(s);
              if (s.contains('?user_id=')) {
                MemberProfileScreen(memberId: s.splitAfter('?user_id=').toInt()).launch(context);
              } else {
                openWebPage(context, url: s);
              }
            }
          },
          onAnchorTap: (s, _, __) async {
            if (s!.split('/').last.contains('.pdf')) {
              PDFScreen(docURl: s).launch(context);
            } else {
              if (s.contains('?user_id=')) {
                if (s.contains('&is_mention=1')) {
                  MemberProfileScreen(memberId: s.splitBetween('?user_id=', '&is_mention=1').toInt()).launch(context);
                } else {
                  MemberProfileScreen(memberId: s.splitAfter('?user_id=').toInt()).launch(context);
                }
              } else {
                if (blogId != null) {
                  appStore.setLoading(true);
                  await wpPostById(postId: blogId.validate()).then((value) {
                    appStore.setLoading(false);
                    if (value.is_restricted.validate()) {
                      MembershipPlansScreen().launch(context);
                    } else {
                      BlogDetailScreen(blogId: blogId.validate(), data: value).launch(context);
                    }
                  }).catchError((e) {
                    toast(language.canNotViewPost);
                    appStore.setLoading(false);
                  });
                } else {
                  openWebPage(context, url: s);
                }
              }
            }
          },
          style: {
            "table": commonStyle(backgroundColor: color ?? transparentColor),
            "tr": commonStyle(border: Border(bottom: BorderSide(color: Colors.black45.withOpacity(0.5)))),
            "th": commonStyle(backgroundColor: Colors.black45.withOpacity(0.5)),
            "td": commonStyle(alignment: Alignment.center),
            'embed': commonStyle(passedColor: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            'strong': commonStyle(),
            'a': commonStyle(passedColor: Colors.blue, fontWeight: FontWeight.bold, textDecoration: TextDecoration.none),
            'div': commonStyle(),
            'figure': commonStyle(margin: Margins.zero),
            'h1': commonStyle(),
            'h2': commonStyle(),
            'h3': commonStyle(),
            'h4': commonStyle(),
            'h5': commonStyle(),
            'h6': commonStyle(),
            'p': commonStyle(textAlign: TextAlign.justify),
            'ol': commonStyle(),
            'ul': commonStyle(),
            'strike': commonStyle(),
            'u': commonStyle(),
            'b': commonStyle(),
            'i': commonStyle(),
            'hr': commonStyle(),
            'header': commonStyle(),
            'code': commonStyle(),
            'data': commonStyle(),
            'body': commonStyle(),
            'big': commonStyle(),
            'audio': commonStyle(),
            'img': Style(width: Width(context.width()), padding: HtmlPaddings.only(bottom: 8), fontSize: FontSize(fontSize)),
            'li': commonStyle(listStyleType: ListStyleType.disc, listStylePosition: ListStylePosition.outside),
          },
          extensions: [
            TagExtension(
              tagsToExtend: {'embed'},
              builder: (extensionContext) {
                var videoLink = extensionContext.parser.htmlData.text.splitBetween('<embed>', '</embed');

                if (videoLink.contains('yout')) {
                  return YouTubeEmbedWidget(videoLink.replaceAll('<br>', '').toYouTubeId());
                } else if (videoLink.contains('vimeo')) {
                  return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
                } else {
                  return Offstage();
                }
              },
            ),
            TagExtension(
              tagsToExtend: {'figure'},
              builder: (extensionContext) {
                if (extensionContext.innerHtml.contains('yout')) {
                  return YouTubeEmbedWidget(extensionContext.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').toYouTubeId());
                } else if (extensionContext.innerHtml.contains('vimeo')) {
                  return VimeoEmbedWidget(extensionContext.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
                } else if (extensionContext.innerHtml.contains('audio')) {
                  //retu rn AudioPostWidget(postString: extensionContext.innerHtml);
                } else if (extensionContext.innerHtml.contains('twitter')) {
                  String t = extensionContext.innerHtml.splitAfter('<div class="wp-block-embed__wrapper">').splitBefore('</div>');
                  // return TweetWebView(tweetUrl: t);
                } else if (extensionContext.innerHtml.validate().contains('img')) {
                  String img = '';

                  img = extensionContext.innerHtml.splitAfter('<a href="').splitBefore('"><img loading');
                  if (img.isNotEmpty) {
                    return CachedNetworkImage(
                      imageUrl: img,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
                      //OpenPhotoViewer(photoImage: img).launch(context);
                    });
                  } else {
                    return Offstage();
                  }
                }
                return Offstage();
              },
            ),
            TagExtension(
              tagsToExtend: {'iframe'},
              builder: (extensionContext) {
                if (extensionContext.attributes.containsKey('class')) {
                  return Column(
                    children: [
                      AnyLinkPreview(
                        link: extensionContext.attributes['src'].validate(),
                        backgroundColor: context.cardColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 0.5,
                            color: context.dividerColor,
                          ) //BoxShadow
                        ],
                        bodyStyle: secondaryTextStyle(size: 12),
                        titleStyle: boldTextStyle(size: 14),
                      ).paddingAll(8),
                    ],
                  );
                } else {
                  return YouTubeEmbedWidget(extensionContext.attributes['src'].validate().toYouTubeId());
                }
              },
            ),
            TagExtension(
              tagsToExtend: {'img'},
              builder: (extensionContext) {
                String img = '';
                if (extensionContext.attributes.containsKey('src')) {
                  img = extensionContext.attributes['src'].validate();
                } else if (extensionContext.attributes.containsKey('data-src')) {
                  img = extensionContext.attributes['data-src'].validate();
                }
                if (img.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: img,
                    width: context.width(),
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
                    //OpenPhotoViewer(photoImage: img).launch(context);
                  });
                } else {
                  return Offstage();
                }
              },
            ),
            TagWrapExtension(
              tagsToWrap: {"table"},
              builder: (child) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.open_in_full_rounded),
                        onPressed: () async {
                          await TableViewWidget(child).launch(context);
                          setOrientationPortrait();
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: child,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class YoutubeComponent extends StatefulWidget {
  final String? postContent;

  const YoutubeComponent({this.postContent});

  @override
  State<YoutubeComponent> createState() => _YoutubeComponentState();
}

class _YoutubeComponentState extends State<YoutubeComponent> {
  String videoId = '';

  @override
  void initState() {
    super.initState();

    extractDivAttributes(widget.postContent.validate());
  }

  void extractDivAttributes(String htmlText) {
    RegExp regExp = RegExp(r'"youtube_url":"([^"]+)"');
    Match? match = regExp.firstMatch(htmlText);

    if (match != null) {
      String youtubeURL = match.group(1)!;
      youtubeURL = json.decode('"$youtubeURL"');
      videoId = youtubeURL.toYouTubeId();
    } else {
      print('YouTube URL not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YouTubeEmbedWidget(videoId);
  }
}
