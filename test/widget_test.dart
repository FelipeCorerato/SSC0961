// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/presentation/screens/login_screen.dart';
import 'package:nutripro_flutter/core/services/mock_authentication_service.dart';
import 'package:nutripro_flutter/domain/services/authentication_service.dart';

void main() {
  group('Testes da Aplicação NutriPro', () {
    late MockAuthenticationService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthenticationService();
    });

    Widget createLoginScreen() {
      return MaterialApp(
        home: LoginScreen(authService: mockAuthService),
      );
    }

    testWidgets('App deve carregar com tela de login', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(createLoginScreen());

      // Verifica se a tela de login está sendo exibida
      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email e senha
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('Deve mostrar campos de email e senha', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      // Verifica se os campos de entrada estão presentes
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
    });
  });
}
