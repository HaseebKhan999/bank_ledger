import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Imports from your project
import 'package:dsa_sem_project/main.dart';
import 'package:dsa_sem_project/providers/bank_provider.dart';

void main() {
  testWidgets('App starts at Login Screen', (WidgetTester tester) async {
    // 1. Wrap the app in the Provider, just like in main.dart
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => BankProvider(),
        child: const BankingApp(), // Use the correct class name 'BankingApp'
      ),
    );

    // 2. Verify that the app starts at the Login Screen
    // We look for the text "SECURE LOGIN" which is on the button in your LoginScreen
    expect(find.text('SECURE LOGIN'), findsOneWidget);

    // 3. Verify that we are NOT yet on the Dashboard (Balance shouldn't be visible yet)
    expect(find.text('Current Balance'), findsNothing);
  });
}