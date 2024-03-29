import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/constants.dart';

class MoreFeedbackScreen extends StatelessWidget {
  const MoreFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: SvgPicture.asset("assets/shevron-left-black.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset("assets/settings/close_black_icon.svg"),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 3);
                },
              )
            ],
            backgroundColor: moreScreenBackColor),
        backgroundColor: moreScreenBackColor,
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Expanded(
                  child: Image.asset("assets/emotions/communication.png"),
                  flex: 5),
              Expanded(
                  child: Text("Your thoughts matter",
                      style: Fonts.screenTytleTextStyle),
                  flex: 2),
              Expanded(
                  child: Text(
                      "Thank you for helping the app to become\nbetter. Feel free to contact us with any\nthoughts and ideas!",
                      style: Fonts.largeTextStyle,
                      textAlign: TextAlign.center),
                  flex: 3),
              const Expanded(child: SizedBox(), flex: 5),
              Expanded(
                  child: InkWell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child:
                                  SvgPicture.asset("assets/settings/mail.svg"),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text('Send another message',
                                style: Fonts.largeTextStyle.copyWith(
                                    decoration: TextDecoration.underline))
                          ]),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  flex: 2),
            ])));
  }
}
