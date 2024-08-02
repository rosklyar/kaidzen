import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../assets/light_dark_theme.dart';


class DoneIconButton extends StatelessWidget {
  const DoneIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
    return IconButton(
        icon: Icon(Icons.done, color: dark_light_modes.statusIcon(isDarkTheme)),
        color: Theme.of(context).colorScheme.error,
        onPressed: () {});
  }
}
