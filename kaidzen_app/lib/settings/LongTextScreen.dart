import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';

class LongTextScreen extends StatelessWidget {
  final String title;
  final DateTime date;
  final String mdFilePath;

  const LongTextScreen(
      {Key? key,
      required this.title,
      required this.date,
      required this.mdFilePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child:
                              SvgPicture.asset("assets/shevron-left-black.svg"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()));
                          },
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                              "assets/settings/close_black_icon.svg"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                  flex: 2),
              Expanded(
                  child: FutureBuilder<String>(
                      future: Future.delayed(const Duration(milliseconds: 150))
                          .then((value) => rootBundle.loadString(mdFilePath)),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return Markdown(data: snapshot.data!);
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                  flex: 27),
            ])));
  }
}
