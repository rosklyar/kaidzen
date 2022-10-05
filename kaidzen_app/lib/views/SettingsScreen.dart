import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:in_app_review/in_app_review.dart';

import '../assets/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Sticky Goals',
        text: 'Sticky Goals',
        linkUrl:
            'https://play.google.com/apps/test/com.funworkstudio.stickygoals.android/4',
        chooserTitle: 'Share \'Sticky Goals\'');
  }

  Future<void> _requestReview() => InAppReview.instance.requestReview();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 32),
                        Text('Hey there!', style: Fonts.screenTytleTextStyle),
                        IconButton(
                          iconSize: 32,
                          icon: SvgPicture.asset(
                              "assets/settings/close_black_icon.svg"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ])),
              flex: 2),
          Expanded(
              child: Stack(children: [
                SvgPicture.asset("assets/settings/subscribe_panel.svg")
              ]),
              flex: 6),
          Expanded(
              child: SvgPicture.asset("assets/settings/line_12.svg"), flex: 1),
          Expanded(
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "About philosophy",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ])),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "Send feedback",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ])),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "Love the app? Leave a review",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _requestReview,
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ])),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "Share app",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            share();
                          },
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ]))
              ]).toList()),
              flex: 6),
          Expanded(
              child: SvgPicture.asset("assets/settings/line_12.svg"), flex: 1),
          Expanded(
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "Terms of use",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ])),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        Text(
                          "Privacy policy",
                          style: Fonts.largeTextStyle20,
                          textAlign: TextAlign.left,
                        )
                      ]),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ]))
              ]).toList()),
              flex: 4),
        ],
      ),
    );
  }
}
