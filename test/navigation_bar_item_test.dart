import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_way/models/navigation_bar_model.dart';
import 'package:task_way/widgets/navigation_bar_item.dart';

void main() {
  group('NavigationBarItem widget', () {
    testWidgets('Widget renders correctly when selected',
        (WidgetTester tester) async {
      final model = PopsoNavigationBarModel(
        text: 'Test',
        icon: Icons.home,
        iconSelected: Icons.home_filled,
        semanticLabel: 'Test label',
        key: 'todo',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationBarItem(
              model: model,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home_filled), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('Widget renders correctly when not selected',
        (WidgetTester tester) async {
      final model = PopsoNavigationBarModel(
        text: 'Test',
        icon: Icons.home,
        iconSelected: Icons.home_filled,
        semanticLabel: 'Test label',
        key: 'todo',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationBarItem(
              model: model,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('onTap callback is triggered', (WidgetTester tester) async {
      bool tapped = false;
      final model = PopsoNavigationBarModel(
          text: 'Test',
          icon: Icons.home,
          iconSelected: Icons.home_filled,
          semanticLabel: 'Test label',
          key: 'todo');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationBarItem(
              model: model,
              isSelected: true,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
