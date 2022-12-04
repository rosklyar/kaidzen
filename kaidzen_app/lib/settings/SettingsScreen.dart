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
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              title: Text('More', style: Fonts.screenTytleTextStyle),
              centerTitle: true,
              actions: [
                IconButton(
                  icon:
                      SvgPicture.asset("assets/settings/close_black_icon.svg"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
              backgroundColor: moreScreenBackColor,
            ),
            body: Container(
              color: moreScreenBackColor,
              child: Column(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
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
                                flex: 1),
                            Expanded(
                                child: GestureDetector(
                                    child: Image.asset(
                                        "assets/settings/spheres.png",
                                        width: double.infinity,
                                        height: double.infinity),
                                    onTap: () async {
                                      await _goToSpheresExplanation(context);
                                    }),
                                flex: 1),
                            const Expanded(child: SizedBox(), flex: 1)
                          ])),
                      flex: 9),
                  Expanded(
                      child: Column(
                          children:
                              ListTile.divideTiles(context: context, tiles: [
                        ListTile(
                            title: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.circle,
                                              color: Color.fromRGBO(
                                                  234, 125, 98, 1.0),
                                              size: 8),
                                          Row(children: [
                                            Text(
                                              " Send feedback",
                                              style: Fonts.largeTextStyle20,
                                              textAlign: TextAlign.left,
                                            )
                                          ])
                                        ]),
                                    SvgPicture.asset(
                                        "assets/shevron-right-black.svg")
                                  ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                const SizedBox(width: 13),
                                Text("Share ideas or tell about bugs",
                                    style: Fonts.mediumTextStyle.copyWith(
                                        color: const Color.fromRGBO(
                                            114, 118, 121, 1.0)))
                              ])
                            ]),
                            onTap: () async {
                              await _goToSendFeedback(context);
                            }),
                        ListTile(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.circle,
                                      color: Color.fromRGBO(240, 213, 76, 1.0),
                                      size: 8),
                                  Text(
                                    " Share app",
                                    style: Fonts.largeTextStyle20,
                                    textAlign: TextAlign.left,
                                  )
                                ]),
                            onTap: () async {
                              await _shareApp();
                            }),
                        progress.getTotalLevel() > 10
                            ? ListTile(
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
                                })
                            : const ListTile()
                      ]).toList()),
                      flex: 12),
                  Expanded(
                      child: Image.asset("assets/settings/line_12.png"),
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
                      flex: 8),
                  Expanded(
                      child: Image.asset(
                          "assets/settings/settings_bottom_line.png"),
                      flex: 4),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Version 1.0",
                                  style: Fonts.mediumTextStyle.copyWith(
                                      color: const Color.fromRGBO(
                                          114, 118, 121, 1.0)),
                                )
                              ])),
                      flex: 1)
                ],
              ),
            )));
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
