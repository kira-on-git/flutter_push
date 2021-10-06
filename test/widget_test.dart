import 'package:flutter/material.dart';
import 'package:flutter_push/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('l01h01', () {
    testWidgets('Scaffold have right background color', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(
        (tester.firstWidget(find.byType(Scaffold)) as Scaffold).backgroundColor,
        const Color(0xFF282E3D),
      );
    });
  });

  group("l01h02", () {
    testWidgets('Top Text widget has correct style', (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white);
      await tester.pumpWidget(MyApp());
      expect((tester.firstWidget(find.textContaining("Test your")) as Text).style, correctStyle);
      expect((tester.firstWidget(find.textContaining("Test your")) as Text).textAlign, TextAlign.center);
    });
  });

  group('l01h03', () {
    testWidgets('Centered box has right background color', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      final List<Stack> stackWidgets =
          tester.widgetList<Stack>(find.byWidgetPredicate((widget) => widget is Stack)).toList();
      final Stack? stackWithThreeWidgets = stackWidgets.firstWhere((stack) => stack.children.length == 3);
      expect(stackWithThreeWidgets, isNotNull);
      final Widget? centeredWidget = stackWithThreeWidgets!.children
          .firstWhere((element) => (element is Align && element.alignment == Alignment.center) || element is Center);
      expect(centeredWidget, isNotNull);
      expect(centeredWidget, isInstanceOf<Align>());
      expect((centeredWidget as Align).child, isInstanceOf<ColoredBox>());
      final ColoredBox coloredBox = centeredWidget.child as ColoredBox;
      expect(coloredBox.color, const Color(0xFF6D6D6D));
    });
  });

  group('l01h04', () {
    testWidgets('The Text with milliseconds has correct style', (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white);
      await tester.pumpWidget(MyApp());
      final Text? text = tester.firstWidget(find.byWidgetPredicate((widget) => widget is Text && widget.data == ""));
      expect(text, isNotNull);
      expect(text!.style, correctStyle);
    });
  });

  group('l01h05', () {
    testWidgets('The Text with milliseconds has correct style', (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white);
      await tester.pumpWidget(MyApp());
      final Text? text =
          tester.firstWidget(find.byWidgetPredicate((widget) => widget is Text && widget.data == "START"));
      expect(text, isNotNull);
      expect(text!.style, correctStyle);
    });
  });

  group('l01h06', () {
    testWidgets('Top and Bottom widget have 10% padding from the edges of the screen', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      final List<Stack> stackWidgets =
          tester.widgetList<Stack>(find.byWidgetPredicate((widget) => widget is Stack)).toList();
      final Stack? stackWithThreeWidgets = stackWidgets.firstWhere((stack) => stack.children.length == 3);
      expect(stackWithThreeWidgets, isNotNull);
      final Widget? topWidget = stackWithThreeWidgets!.children
          .firstWhere((element) => element is Align && element.alignment == const Alignment(0, -0.8));
      expect(topWidget, isNotNull);
      final Widget? bottomWidget = stackWithThreeWidgets.children
          .firstWhere((element) => element is Align && element.alignment == const Alignment(0, 0.8));
      expect(bottomWidget, isNotNull);
    });
  });

  group('l01h07', () {
    testWidgets('Bottom button has correct colors for all GameStates', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(TickerMode(child: MyApp(), enabled: true));

        expect(find.text('START'), findsOneWidget);
        expect(find.text('WAIT'), findsNothing);
        expect(find.text('STOP'), findsNothing);
        expect(
          (tester.firstWidget(find.widgetWithText(ColoredBox, "START")) as ColoredBox).color,
          const Color(0xFF40CA88),
        );

        await tester.tap(find.text("START"));
        await tester.pump();

        expect(find.text('START'), findsNothing);
        expect(find.text('WAIT'), findsOneWidget);
        expect(find.text('STOP'), findsNothing);

        expect(
          (tester.firstWidget(find.widgetWithText(ColoredBox, "WAIT")) as ColoredBox).color,
          const Color(0xFFE0982D),
        );

        await Future.delayed(Duration(milliseconds: 5001));
        await tester.pump();

        expect(find.text('START'), findsNothing);
        expect(find.text('WAIT'), findsNothing);
        expect(find.text('STOP'), findsOneWidget);

        expect(
          (tester.firstWidget(find.widgetWithText(ColoredBox, "STOP")) as ColoredBox).color,
          const Color(0xFFE02D47),
        );

        await tester.tap(find.text("STOP"));
        await tester.pump();

        expect(find.text('START'), findsOneWidget);
        expect(find.text('WAIT'), findsNothing);
        expect(find.text('STOP'), findsNothing);
      });
    });
  });
}
