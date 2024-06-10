import 'package:flutter/material.dart';

class LeadingCardWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double iconSize;
  final bool showText;
  final String? text;
  const LeadingCardWidget({
    super.key,
    required this.icon,
    required this.color,
    this.iconSize = 20,
    this.showText = false,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    print('Color $color');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        if (showText)
          const SizedBox(
            width: 6,
          ),
        if (showText) Text(text ?? '')
      ],
    );
  }
}
