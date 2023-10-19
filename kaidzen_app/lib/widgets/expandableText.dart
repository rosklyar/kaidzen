import 'package:flutter/material.dart';

import '../assets/constants.dart';

class ExpandableText extends StatefulWidget {
  final String previewText;
  final String fullText;

  ExpandableText({required this.previewText, required this.fullText});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: RichText(
              text: TextSpan(
                style: Fonts.graySubtitle14,
                children: [
                  TextSpan(
                    text: _isExpanded ? widget.fullText : widget.previewText,
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: _toggleExpansion,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          _isExpanded ? 'Show less' : 'Show more',
                          style: Fonts.mindfulMomentTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}