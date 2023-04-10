import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/announcements/AnnouncementWidget.dart';
import 'package:kaidzen_app/assets/constants.dart';

import 'AnnouncementsState.dart';

class ReorderingAnnouncementWidget extends AnnouncementWidget {
  ReorderingAnnouncementWidget({required AnnouncementsState announcementsState})
      : super(announcementsState: announcementsState);

  @override
  int get id => 1;

  @override
  Widget get widget => Stack(children: [
        SvgPicture.asset("assets/announcement/reg-announcement.svg",
            width: double.infinity, height: double.infinity, fit: BoxFit.fill),
        Column(children: [
          Column(children: [
            Align(
                child: Padding(
                    child: Text("Did you know?\nReorder your goals!",
                        style: Fonts.announcementBoldTextStyle.copyWith(
                            color: const Color.fromRGBO(117, 30, 132, 1.0))),
                    padding: const EdgeInsets.fromLTRB(15, 14, 0, 0)),
                alignment: Alignment.topLeft),
            Padding(
                child: Text(
                    "Press and hold the goal tile, then move it up or down",
                    style: Fonts.mediumTextStyle),
                padding: const EdgeInsets.fromLTRB(15, 14, 0, 0))
          ]),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: SvgPicture.asset("assets/settings/close_black_icon.svg"),
              onPressed: () async {
                await close();
              },
            ))
      ]);

  @override
  bool get shouldBeShown => true;
}
