import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/announcements/AnnouncementWidget.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/AnalyticsService.dart';
import 'AnnouncementsState.dart';

class SurveyAnnouncementWidget extends AnnouncementWidget {
  SurveyAnnouncementWidget({required AnnouncementsState announcementsState})
      : super(announcementsState: announcementsState);

  @override
  int get id => 0;

  @override
  Widget get widget => Stack(children: [
        SvgPicture.asset("assets/announcement/survey.svg",
            width: double.infinity, height: double.infinity, fit: BoxFit.fill),
        Column(children: [
          Column(children: [
            Align(
                child: Padding(
                    child: Text("Shape our future:\nTake a survey!",
                        style: Fonts.announcementBoldTextStyle),
                    padding: const EdgeInsets.fromLTRB(40, 19, 10, 0)),
                alignment: Alignment.topLeft),
            Padding(
                child: Text(
                    "Make an impact on entire community by spending 3-5 mins",
                    style: Fonts.mediumTextStyle),
                padding: const EdgeInsets.fromLTRB(40, 19, 10, 0))
          ]),
          GestureDetector(
              child: Padding(
                  child: Row(children: [
                    SvgPicture.asset("assets/announcement/ExternalLink.svg"),
                    const SizedBox(width: 5),
                    Text("Open survey",
                        style: Fonts.largeBoldTextStyle.copyWith(
                            decoration: TextDecoration.underline,
                            color: const Color.fromRGBO(55, 22, 190, 1.0)))
                  ], mainAxisAlignment: MainAxisAlignment.end),
                  padding: const EdgeInsets.fromLTRB(0, 0, 25, 25)),
              onTap: () => _launchURL()),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
                child: IconButton(
                  icon:
                      SvgPicture.asset("assets/settings/close_black_icon.svg"),
                  onPressed: () async {
                    await close();
                  },
                ),
                padding: const EdgeInsets.only(right: 5, top: 5)))
      ]);

  _launchURL() async {
    const url = 'https://tally.so/r/wvMPVX';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      await FirebaseAnalytics.instance
          .logEvent(name: AnalyticsEventType.survey_opened.name);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  bool get shouldBeShown => true;
}
