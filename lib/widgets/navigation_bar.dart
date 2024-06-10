import 'package:flutter/material.dart';
import 'package:task_way/models/navigation_bar_model.dart';
import 'package:task_way/widgets/navigation_bar_item.dart';

const _kMinElements = 4;

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({
    super.key,
    required this.items,
    required this.onChanged,
    required this.currentIndex,
  }) : assert(
          currentIndex >= 0 && currentIndex < items.length,
          'index out of range',
        );

  final List<PopsoNavigationBarModel> items;
  final void Function(int, PopsoNavigationBarModel)? onChanged;
  final int currentIndex;

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final isLandscape = orientation == Orientation.landscape;
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 20),
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _itemsFromOrientation(isLandscape),
          ),
        ),
      );
    });
  }

  Widget _itemsFromOrientation(bool isLandscape) {
    if (isLandscape) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items.indexed
            .map(
              (e) => Expanded(
                child: _item(e),
              ),
            )
            .toList(),
      );
    } else {
      final rowWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items.indexed.map((e) => _item(e)).toList(),
      );
      return widget.items.length > _kMinElements
          ? FittedBox(
              fit: BoxFit.fitWidth,
              child: rowWidget,
            )
          : rowWidget;
    }
  }

  Widget _item((int, PopsoNavigationBarModel) e) {
    return NavigationBarItem(
      model: e.$2,
      isSelected: widget.currentIndex == e.$1,
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(e.$1, widget.items[e.$1]);
        }
      },
    );
  }
}
