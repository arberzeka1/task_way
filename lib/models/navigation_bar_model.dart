import 'package:flutter/material.dart';

class PopsoNavigationBarModel {
  final IconData icon, iconSelected;
  final String text;
  final String? semanticLabel;
  final String key;

  PopsoNavigationBarModel({
    required this.icon,
    required this.iconSelected,
    required this.text,
    this.semanticLabel,
    required this.key,
  });
}
