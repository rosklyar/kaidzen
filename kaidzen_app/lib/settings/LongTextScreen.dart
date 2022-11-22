import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 32,
                          icon:
                              SvgPicture.asset("assets/shevron-left-black.svg"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          iconSize: 32,
                          icon: SvgPicture.asset(
                              "assets/settings/close_black_icon.svg"),
                          onPressed: () {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                        )
                      ]),
                  flex: 3),
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
                  flex: 22),
            ])));
  }
}
