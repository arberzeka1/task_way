import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_way/models/navigation_bar_model.dart';
import 'package:task_way/widgets/navigation_bar.dart';
import 'package:task_way/widgets/navigation_bar_item.dart';

void main() {
  group('MainNavigationBar widget', () {
    testWidgets('Widget renders correctly in portrait mode',
        (WidgetTester tester) async {
      final items = List.generate(
        4,
        (index) => PopsoNavigationBarModel(
          text: 'Item $index',
          icon: Icons.home,
          iconSelected: Icons.home_filled,
          semanticLabel: 'Item $index',
          key: 'todo',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainNavigationBar(
              items: items,
              onChanged: (index, item) {},
              currentIndex: 0,
            ),
          ),
        ),
      );

      expect(find.byType(NavigationBarItem), findsNWidgets(4));
    });

    testWidgets('Widget renders correctly in landscape mode',
        (WidgetTester tester) async {
      final items = List.generate(
        4,
        (index) => PopsoNavigationBarModel(
          text: 'Item $index',
          icon: Icons.home,
          iconSelected: Icons.home_filled,
          semanticLabel: 'Item $index',
          key: 'todo',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainNavigationBar(
              items: items,
              onChanged: (index, item) {},
              currentIndex: 0,
            ),
          ),
        ),
      );

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pump();

      expect(find.byType(NavigationBarItem), findsNWidgets(4));
    });

    testWidgets('onChanged callback is triggered when an item is tapped',
        (WidgetTester tester) async {
      int currentIndex = 0;
      PopsoNavigationBarModel? selectedItem;

      final items = List.generate(
        4,
        (index) => PopsoNavigationBarModel(
          text: 'Item $index',
          icon: Icons.home,
          iconSelected: Icons.home_filled,
          semanticLabel: 'Item $index',
          key: 'todo',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MainNavigationBar(
              items: items,
              onChanged: (index, item) {
                currentIndex = index;
                selectedItem = item;
              },
              currentIndex: currentIndex,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Item 1'));
      await tester.pump();

      expect(currentIndex, equals(1));
      expect(selectedItem?.text, equals('Item 1'));
    });
  });
}
