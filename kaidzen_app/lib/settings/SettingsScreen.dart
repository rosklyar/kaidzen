import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kaidzen_app/feedback/EmailSender.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/settings/AboutPhilosophyScreen.dart';
import 'package:kaidzen_app/settings/LongTextScreen.dart';
import 'package:kaidzen_app/settings/ReviewUtils.dart';
import 'package:kaidzen_app/settings/SpheresExplanationScreen.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/AnalyticsService.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Sticky Goals',
        text: 'Sticky Goals',
        linkUrl: defaultTargetPlatform == TargetPlatform.android
            ? 'https://play.google.com/apps/test/com.funworkstudio.stickygoals.android/15'
            : "https://https://www.apple.com/app-store",
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
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ])),
                      flex: 2),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Row(children: [
                            Expanded(
                                child: GestureDetector(
                                    child: Image.asset(
                                        "assets/settings/philosophy.png",
                                        width: double.infinity,
                                        height: double.infinity),
                                    onTap: () async {
                                      await _goToAboutPhilosophy(context);
                                    }),
                                flex: 6),
                            const Expanded(child: SizedBox(), flex: 1),
                            Expanded(
                                child: GestureDetector(
                                    child: Image.asset(
                                        "assets/settings/spheres.png",
                                        width: double.infinity,
                                        height: double.infinity),
                                    onTap: () async {
                                      await _goToSpheresExplanation(context);
                                    }),
                                flex: 6),
                            const Expanded(child: SizedBox(), flex: 1),
                            const Expanded(child: SizedBox(), flex: 6)
                          ])),
                      flex: 3),
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
                                      "Send feedback",
                                      style: Fonts.largeTextStyle20,
                                      textAlign: TextAlign.left,
                                    )
                                  ]),
                                  SvgPicture.asset(
                                      "assets/shevron-right-black.svg")
                                ]),
                            onTap: () async {
                              await _goToSendFeedback(context);
                            }),
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
                                      SvgPicture.asset(
                                          "assets/shevron-right-black.svg")
                                    ]),
                                onTap: () async {
                                  ReviewUtils.requestReview();
                                })),
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
                                  SvgPicture.asset(
                                      "assets/shevron-right-black.svg")
                                ]),
                            onTap: () async {
                              await _shareApp();
                            })
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
                                  SvgPicture.asset(
                                      "assets/shevron-right-black.svg")
                                ]),
                            onTap: () async {
                              await _goToTermsOfUse(context);
                            }),
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
                                  SvgPicture.asset(
                                      "assets/shevron-right-black.svg")
                                ]),
                            onTap: () async {
                              await _goToPrivacyPolicy(context);
                            }),
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

  Future<void> _goToPrivacyPolicy(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.privacy_policy_opened.name);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LongTextScreen(
                  title: "Privacy policy",
                  date: DateTime(2022, 9, 30),
                  mdFilePath: 'assets/settings/privacy_policy.md',
                )));
  }

  Future<void> _goToTermsOfUse(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.terms_of_use_opened.name);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LongTextScreen(
                  title: "Terms of use",
                  date: DateTime(2022, 9, 30),
                  mdFilePath: 'assets/settings/terms_of_use.md',
                )));
  }

  Future<void> _shareApp() async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.share_app_opened.name);
    share();
  }

  Future<void> _goToSendFeedback(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.send_feedback_opened.name);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const EmailSender()));
  }

  Future<void> _goToAboutPhilosophy(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.about_philosophy_opened.name);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AboutPhilosophyScreen()));
  }

  Future<void> _goToSpheresExplanation(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.spheres_explanation_opened.name);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SpheresExplanationScreen()));
  }
}
