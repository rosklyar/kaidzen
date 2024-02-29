import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:provider/provider.dart';
import '../assets/light_dark_theme.dart';

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
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = themeProvider.darkTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: dark_light_modes.statusIcon(isDarkTheme),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: dark_light_modes.statusIcon(isDarkTheme),
            ),
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
          )
        ],
        backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
      ),
      body: Column(children: [
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
      ]),
      backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
    );
  }
}
