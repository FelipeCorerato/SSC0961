import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/presentation/screens/login_screen.dart';
import 'package:nutripro_flutter/core/services/mock_authentication_service.dart';
import 'package:nutripro_flutter/presentation/widgets/loading_button.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthenticationService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthenticationService();
    });

    Widget createLoginScreen() {
      return MaterialApp(home: LoginScreen(authService: mockAuthService));
    }

    testWidgets('deve exibir todos os elementos da tela de login', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Verifica se os elementos principais estão presentes
      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Faça login para continuar'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Esqueceu a senha?'), findsOneWidget);
      expect(find.text('Não tem uma conta?'), findsOneWidget);
      expect(find.text('Registrar-se'), findsOneWidget);
    });

    testWidgets('deve ter campos de entrada para email e senha', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Verifica se os campos de entrada estão presentes
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Insira seu e-mail'), findsOneWidget);
      expect(find.text('Insira sua senha'), findsOneWidget);
    });

    testWidgets('deve mostrar erro para email inválido', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Digita email inválido
      await tester.enterText(find.byType(TextFormField).first, 'emailinvalido');
      await tester.enterText(find.byType(TextFormField).last, 'senha123');

      // Tenta submeter o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se a mensagem de erro aparece
      expect(find.text('Por favor, insira um e-mail válido'), findsOneWidget);
    });

    testWidgets('deve mostrar erro para senha muito curta', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Digita email válido e senha curta
      await tester.enterText(
        find.byType(TextFormField).first,
        'teste@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '123');

      // Tenta submeter o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se a mensagem de erro aparece
      expect(
        find.text('A senha deve ter pelo menos 6 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('deve mostrar erro para campos vazios', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Tenta submeter o formulário sem preencher nada
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se as mensagens de erro aparecem
      expect(find.text('Por favor, insira seu e-mail'), findsOneWidget);
      expect(find.text('Por favor, insira sua senha'), findsOneWidget);
    });

    testWidgets('deve alternar visibilidade da senha', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Verifica se a senha está oculta inicialmente
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Clica no ícone de visibilidade
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Verifica se o ícone mudou
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Clica novamente
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      // Verifica se voltou ao estado inicial
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('deve mostrar erro de login com credenciais inválidas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Digita credenciais inválidas
      await tester.enterText(
        find.byType(TextFormField).first,
        'teste@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'senhaerrada');

      // Submete o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Aguarda a resposta assíncrona
      await tester.pump(const Duration(seconds: 2));

      // Verifica se a mensagem de erro aparece
      expect(find.text('E-mail ou senha inválidos.'), findsOneWidget);
    });

    testWidgets('deve navegar para tela de registro', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Clica no link de registro
      await tester.tap(find.text('Registrar-se'));
      await tester.pumpAndSettle();

      // Verifica se navegou para a tela de registro
      expect(find.text('Criar Conta'), findsOneWidget);
    });

    testWidgets('deve navegar para tela de recuperação de senha', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Clica no link de esqueceu a senha
      await tester.tap(find.text('Esqueceu a senha?'));
      await tester.pumpAndSettle();

      // Verifica se navegou para a tela de recuperação
      expect(find.text('Recuperar Senha'), findsOneWidget);
    });

    testWidgets('deve desabilitar botões durante carregamento', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      // Digita credenciais válidas, mas senha errada para simular loading sem navegação
      await tester.enterText(
        find.byType(TextFormField).first,
        'teste@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'senhaerrada');

      // Submete o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // O botão deve estar em loading
      final loadingButton = tester.widget<LoadingButton>(
        find.byType(LoadingButton),
      );
      expect(loadingButton.isLoading, isTrue);

      // Aguarda o término da operação assíncrona
      await tester.pump(const Duration(seconds: 2));

      // Após o loading, o botão deve voltar ao normal
      final loadingButtonAfter = tester.widget<LoadingButton>(
        find.byType(LoadingButton),
      );
      expect(loadingButtonAfter.isLoading, isFalse);
    });
  });
}
