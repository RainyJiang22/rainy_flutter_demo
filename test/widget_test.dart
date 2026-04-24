import 'package:first_flutter_demo/pages/chapter7/chapter7_exercises_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter_demo/main.dart';

void main() {
  testWidgets('opens chapter 7 exercise list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter Demo 列表'), findsOneWidget);
    expect(find.text('第7章实战练习'), findsOneWidget);
  });

  testWidgets('renders chapter 7 exercise list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Chapter7ExercisesPage()));

    expect(find.text('购物车练习'), findsOneWidget);
    expect(find.text('设置页面练习'), findsOneWidget);
    expect(find.text('待办事项练习'), findsOneWidget);
    expect(find.text('登录系统练习'), findsOneWidget);
  });
}
