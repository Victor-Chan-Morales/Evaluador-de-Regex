// This is a basic Flutter widget test for the Regex Evaluator app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_automatas/main.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RegexApp());

    // Verify that the home screen displays the correct title.
    expect(find.text('Evaluador de Regex'), findsOneWidget);
    expect(
      find.text('Herramienta para analizar y probar expresiones regulares'),
      findsOneWidget,
    );
    expect(find.text('Iniciar Análisis'), findsOneWidget);
    expect(find.text('Características'), findsOneWidget);
  });

  testWidgets('Navigation to Regex Analyzer works', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RegexApp());

    // Find and tap the "Iniciar Análisis" button.
    await tester.tap(find.text('Iniciar Análisis'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the Regex Analyzer screen.
    expect(find.text('Analizador de Regex'), findsOneWidget);
    expect(find.text('Expresión Regular'), findsOneWidget);
    expect(find.text('Texto (mínimo 5 líneas)'), findsOneWidget);
    expect(find.text('Procesar Regex'), findsOneWidget);
  });
}
