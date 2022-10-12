import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:kaidzen_app/feedback/EmailSender.dart';
import 'package:kaidzen_app/main.dart';
import 'package:kaidzen_app/settings/LongTextScreen.dart';

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
                        Text('More', style: Fonts.screenTytleTextStyle),
                        IconButton(
                          iconSize: 32,
                          icon: SvgPicture.asset(
                              "assets/settings/close_black_icon.svg"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                        ),
                      ])),
              flex: 2),
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
                          onPressed: () async {
                            await FirebaseAnalytics.instance.logEvent(
                                name: AnalyticsEventType
                                    .about_philosophy_opened.name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LongTextScreen(
                                          title: "About philosophy",
                                          date: DateTime(2022, 9, 30),
                                          mainText:
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultrices eros in cursus turpis massa tincidunt dui ut. Et leo duis ut diam quam nulla porttitor massa id. A cras semper auctor neque vitae tempus. Gravida rutrum quisque non tellus orci ac. Nibh praesent tristique magna sit amet purus gravida quis blandit. Mollis nunc sed id semper risus in hendrerit gravida rutrum. Nibh sed pulvinar proin gravida. Quam vulputate dignissim suspendisse in est ante. Montes nascetur ridiculus mus mauris. Non curabitur gravida arcu ac tortor. Tempus quam pellentesque nec nam aliquam sem et tortor. Ultrices gravida dictum fusce ut placerat orci nulla pellentesque. Interdum velit euismod in pellentesque massa placerat. Sed enim ut sem viverra. Senectus et netus et malesuada fames ac turpis. Amet luctus venenatis lectus magna fringilla urna porttitor rhoncus.',
                                        )));
                          },
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
                          onPressed: () async {
                            await FirebaseAnalytics.instance.logEvent(
                                name: AnalyticsEventType
                                    .send_feedback_opened.name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EmailSender()));
                          },
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ])),
                Visibility(
                    visible: false,
                    child: ListTile(
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
                        ]))),
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
                            await FirebaseAnalytics.instance.logEvent(
                                name: AnalyticsEventType.share_app_opened.name);
                            share();
                          },
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ]))
              ]).toList()),
              flex: 4),
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
                          onPressed: () async {
                            await FirebaseAnalytics.instance.logEvent(
                                name: AnalyticsEventType
                                    .terms_of_use_opened.name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LongTextScreen(
                                          title: "Terms of use",
                                          date: DateTime(2022, 9, 30),
                                          mainText:
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultrices eros in cursus turpis massa tincidunt dui ut. Et leo duis ut diam quam nulla porttitor massa id. A cras semper auctor neque vitae tempus. Gravida rutrum quisque non tellus orci ac. Nibh praesent tristique magna sit amet purus gravida quis blandit. Mollis nunc sed id semper risus in hendrerit gravida rutrum. Nibh sed pulvinar proin gravida. Quam vulputate dignissim suspendisse in est ante. Montes nascetur ridiculus mus mauris. Non curabitur gravida arcu ac tortor. Tempus quam pellentesque nec nam aliquam sem et tortor. Ultrices gravida dictum fusce ut placerat orci nulla pellentesque. Interdum velit euismod in pellentesque massa placerat. Sed enim ut sem viverra. Senectus et netus et malesuada fames ac turpis. Amet luctus venenatis lectus magna fringilla urna porttitor rhoncus.',
                                        )));
                          },
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
                          onPressed: () async {
                            await FirebaseAnalytics.instance.logEvent(
                                name: AnalyticsEventType
                                    .privacy_policy_opened.name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LongTextScreen(
                                          title: "Privacy policy",
                                          date: DateTime(2022, 9, 30),
                                          mainText:
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultrices eros in cursus turpis massa tincidunt dui ut. Et leo duis ut diam quam nulla porttitor massa id. A cras semper auctor neque vitae tempus. Gravida rutrum quisque non tellus orci ac. Nibh praesent tristique magna sit amet purus gravida quis blandit. Mollis nunc sed id semper risus in hendrerit gravida rutrum. Nibh sed pulvinar proin gravida. Quam vulputate dignissim suspendisse in est ante. Montes nascetur ridiculus mus mauris. Non curabitur gravida arcu ac tortor. Tempus quam pellentesque nec nam aliquam sem et tortor. Ultrices gravida dictum fusce ut placerat orci nulla pellentesque. Interdum velit euismod in pellentesque massa placerat. Sed enim ut sem viverra. Senectus et netus et malesuada fames ac turpis. Amet luctus venenatis lectus magna fringilla urna porttitor rhoncus.',
                                        )));
                          },
                          icon: SvgPicture.asset(
                              "assets/shevron-right-black.svg"))
                    ]))
              ]).toList()),
              flex: 4),
          Expanded(
              child:
                  SvgPicture.asset("assets/settings/settings_bottom_line.svg"),
              flex: 2)
        ],
      ),
    );
  }
}
