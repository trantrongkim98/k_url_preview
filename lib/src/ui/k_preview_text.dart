import 'package:flutter/material.dart';

class KPreviewText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsets padding;
  const KPreviewText({
    Key? key,
    this.text = '',
    this.style,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return SizedBox(width: 0);
    return Padding(
      padding: padding,
      child: Text(text, style: style),
    );
  }
}