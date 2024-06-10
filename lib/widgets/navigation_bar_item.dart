import 'package:flutter/material.dart';
import 'package:task_way/models/navigation_bar_model.dart';

class NavigationBarItem extends StatefulWidget {
  const NavigationBarItem({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  final PopsoNavigationBarModel model;
  final bool isSelected;
  final Function() onTap;

  @override
  State<NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<NavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.model.semanticLabel,
      button: true,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: widget.isSelected
                    ? const BorderSide(color: Color.fromARGB(255, 11, 84, 121))
                    : BorderSide.none,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  widget.isSelected
                      ? widget.model.iconSelected
                      : widget.model.icon,
                  size: 24,
                  color: widget.isSelected
                      ? const Color.fromARGB(255, 11, 84, 121)
                      : Colors.grey,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.model.text,
                  style: TextStyle(
                      fontWeight: widget.isSelected
                          ? FontWeight.w900
                          : FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
