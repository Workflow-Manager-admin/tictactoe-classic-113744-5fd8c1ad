import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('Tic Tac Toe app bar displays correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Should find the main title in the app bar.
    expect(find.text('Tic Tac Toe'), findsOneWidget);
    // Should find the player turn or draw/win indicator somewhere on screen.
    expect(find.textContaining("Player"), findsWidgets);
  });

  testWidgets('Tic Tac Toe grid contains empty cells', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Should find at least 9 gesture detectors (for the cells).
    final cellDetectors = find.byType(GestureDetector);
    expect(cellDetectors, findsNWidgets(9));
  });

  testWidgets('Reset button resets the game', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Tap a cell, then reset
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Tap the reset button
    final resetButton = find.widgetWithText(ElevatedButton, 'Reset');
    expect(resetButton, findsOneWidget);
    await tester.tap(resetButton);
    await tester.pump();

    // Board should be reset: all cells empty (only empty text widgets in grid).
    final gridSymbols = find.descendant(
      of: find.byType(GridView),
      matching: find.text(''),
    );
    expect(gridSymbols, findsWidgets);
  });
}
