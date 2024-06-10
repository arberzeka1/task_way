import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_way/widgets/card/leading_card_widget.dart';

void main() {
  group('LeadingCardWidget', () {
    testWidgets('Widget renders correctly without text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LeadingCardWidget(
            icon: Icons.star,
            color: Colors.blue,
          ),
        ),
      );

      expect(find.byType(LeadingCardWidget), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('Widget renders correctly with text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LeadingCardWidget(
            icon: Icons.star,
            color: Colors.blue,
            showText: true,
            text: 'Star',
          ),
        ),
      );

      expect(find.byType(LeadingCardWidget), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star'), findsOneWidget);
    });

    testWidgets('Widget renders correctly with default icon size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LeadingCardWidget(
            icon: Icons.star,
            color: Colors.blue,
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(iconWidget.size, 20);
    });

    testWidgets('Widget renders correctly with specified icon size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LeadingCardWidget(
            icon: Icons.star,
            color: Colors.blue,
            iconSize: 30,
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(iconWidget.size, 30);
    });
  });
}
