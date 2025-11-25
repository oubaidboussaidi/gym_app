import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? styles;

  static const defaultStyle = TextStyle(fontSize: 14);

  const CustomText({super.key, required this.text, this.styles});

  @override
  Widget build(BuildContext context) {
    final baseStyle = defaultStyle.copyWith(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    return Text(
      text,
      style: styles != null ? baseStyle.merge(styles) : baseStyle,
    );
  }
}
