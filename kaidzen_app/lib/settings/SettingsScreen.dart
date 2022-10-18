import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kaidzen_app/feedback/EmailSender.dart';
import 'package:kaidzen_app/main.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/settings/AboutPhilosophyScreen.dart';
import 'package:kaidzen_app/settings/LongTextScreen.dart';
import 'package:kaidzen_app/settings/ReviewUtils.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/AnalyticsService.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressState>(
        builder: (context, progress, child) => Scaffold(
              body: Column(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 32),
                                Text('More', style: Fonts.screenTytleTextStyle),
                                IconButton(
                                  iconSize: 32,
                                  icon: SvgPicture.asset(
                                      "assets/settings/close_black_icon.svg"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  },
                                ),
                              ])),
                      flex: 2),
                  Expanded(
                      child: SvgPicture.asset("assets/settings/line_12.svg"),
                      flex: 1),
                  Expanded(
                      child: Column(
                          children:
                              ListTile.divideTiles(context: context, tiles: [
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  onPressed: () async {
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .about_philosophy_opened.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AboutPhilosophyScreen()));
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ])),
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  onPressed: () async {
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .send_feedback_opened.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EmailSender()));
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ])),
                        Visibility(
                            visible: progress.getTotalLevel() > 10,
                            child: ListTile(
                                title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      onPressed: () async {
                                        ReviewUtils.requestReview();
                                      },
                                      icon: SvgPicture.asset(
                                          "assets/shevron-right-black.svg"))
                                ]))),
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .share_app_opened.name);
                                    share();
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ]))
                      ]).toList()),
                      flex: 4),
                  Expanded(
                      child: SvgPicture.asset("assets/settings/line_12.svg"),
                      flex: 1),
                  Expanded(
                      child: Column(
                          children:
                              ListTile.divideTiles(context: context, tiles: [
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  onPressed: () async {
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .terms_of_use_opened.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LongTextScreen(
                                                  title: "Terms of use",
                                                  date: DateTime(2022, 9, 30),
                                                  mdFilePath:
                                                      'assets/settings/terms_of_use.md',
                                                )));
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ])),
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  onPressed: () async {
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .privacy_policy_opened.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LongTextScreen(
                                                  title: "Privacy policy",
                                                  date: DateTime(2022, 9, 30),
                                                  mdFilePath:
                                                      'assets/settings/privacy_policy.md',
                                                )));
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ]))
                      ]).toList()),
                      flex: 4),
                  Expanded(
                      child: SvgPicture.asset(
                          "assets/settings/settings_bottom_line.svg"),
                      flex: 2)
                ],
              ),
            ));
  }
}
