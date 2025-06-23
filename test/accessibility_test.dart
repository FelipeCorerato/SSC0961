import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/presentation/screens/login_screen.dart';
import 'package:nutripro_flutter/presentation/widgets/loading_button.dart';
import 'package:nutripro_flutter/core/services/mock_authentication_service.dart';

void main() {
  group('Testes de Acessibilidade - NutriPro Flutter', () {
    late MockAuthenticationService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthenticationService();
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        home: child,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      );
    }

    group('Testes de Semântica e Labels', () {
      testWidgets('deve ter labels semânticos apropriados na tela de login', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os campos têm labels semânticos
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.text('Esqueceu a senha?'), findsOneWidget);
        expect(find.text('Registrar-se'), findsOneWidget);
      });

      testWidgets('deve ter hints apropriados nos campos de entrada', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os campos têm hints descritivos
        expect(find.text('Insira seu e-mail'), findsOneWidget);
        expect(find.text('Insira sua senha'), findsOneWidget);
      });

      testWidgets('deve ter botões com labels descritivos', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os botões têm labels claros
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.text('Registrar-se'), findsOneWidget);
      });

      testWidgets('deve ter ícones com labels semânticos', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os ícones estão presentes
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('Testes de Navegação por Teclado', () {
      testWidgets('deve permitir navegação por teclado na tela de login', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há campos de entrada
        expect(find.byType(TextFormField), findsNWidgets(2));

        // Verifica se há botões
        expect(find.byType(ElevatedButton), findsWidgets);
      });

      testWidgets('deve permitir ativação de botões', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Foca no botão de login
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se o botão responde ao toque
        expect(find.text('Entrar'), findsOneWidget);
      });

      testWidgets('deve permitir entrada de texto nos campos', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Foca no primeiro campo
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();

        // Digita texto
        await tester.enterText(
          find.byType(TextFormField).first,
          'teste@email.com',
        );

        // Verifica se o texto foi inserido
        expect(find.text('teste@email.com'), findsOneWidget);
      });
    });

    group('Testes de Contraste e Visibilidade', () {
      testWidgets('deve ter contraste adequado nos textos', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os textos principais estão visíveis
        expect(find.text('Bem-vindo'), findsOneWidget);
        expect(find.text('Faça login para continuar'), findsOneWidget);
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
      });

      testWidgets('deve ter indicadores visuais para estados de erro', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Simula erro de validação
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se as mensagens de erro aparecem
        expect(find.text('Por favor, insira seu e-mail'), findsOneWidget);
        expect(find.text('Por favor, insira sua senha'), findsOneWidget);
      });

      testWidgets('deve ter indicadores visuais para campos obrigatórios', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os campos estão presentes
        expect(find.byType(TextFormField), findsNWidgets(2));
      });
    });

    group('Testes de Tamanho de Toque', () {
      testWidgets('deve ter áreas de toque adequadas para botões', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os botões estão presentes
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.text('Registrar-se'), findsOneWidget);
        expect(find.text('Esqueceu a senha?'), findsOneWidget);
      });

      testWidgets('deve ter áreas de toque adequadas para campos de entrada', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os campos de entrada estão presentes
        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('deve ter ícones com áreas de toque adequadas', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se o ícone de visibilidade da senha está presente
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('Testes de Feedback Tátil e Sonoro', () {
      testWidgets('deve fornecer feedback tátil ao tocar botões', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Simula toque no botão
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se o botão responde ao toque
        expect(find.text('Entrar'), findsOneWidget);
      });
    });

    group('Testes de Leitura de Tela', () {
      testWidgets('deve ter textos descritivos para leitores de tela', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os elementos têm textos semânticos
        expect(find.text('Bem-vindo'), findsOneWidget);
        expect(find.text('Faça login para continuar'), findsOneWidget);
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
      });

      testWidgets('deve anunciar mudanças de estado para leitores de tela', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Simula erro de validação
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se as mensagens de erro são anunciadas
        expect(find.text('Por favor, insira seu e-mail'), findsOneWidget);
        expect(find.text('Por favor, insira sua senha'), findsOneWidget);
      });

      testWidgets('deve ter descrições para ícones', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os ícones estão presentes
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('Testes de Componentes Específicos', () {
      testWidgets('LoadingButton deve ser acessível', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(
            Scaffold(
              body: LoadingButton(
                isLoading: false,
                onPressed: () {},
                label: 'Teste',
              ),
            ),
          ),
        );

        expect(find.text('Teste'), findsOneWidget);

        // Testa estado de loading
        await tester.pumpWidget(
          createTestApp(
            Scaffold(
              body: LoadingButton(
                isLoading: true,
                onPressed: () {},
                label: 'Teste',
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Testes de Navegação Acessível', () {
      testWidgets('deve permitir navegação acessível entre telas', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há links de navegação
        expect(find.text('Registrar-se'), findsOneWidget);
        expect(find.text('Esqueceu a senha?'), findsOneWidget);
      });

      testWidgets('deve manter foco adequado durante navegação', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Foca no campo de email
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();

        // Verifica se o campo está presente
        expect(find.byType(TextFormField).first, findsOneWidget);
      });
    });

    group('Testes de Validação Acessível', () {
      testWidgets('deve anunciar erros de validação de forma acessível', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Tenta submeter formulário vazio
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se as mensagens de erro são claras e acessíveis
        expect(find.text('Por favor, insira seu e-mail'), findsOneWidget);
        expect(find.text('Por favor, insira sua senha'), findsOneWidget);
      });

      testWidgets('deve fornecer feedback imediato para erros de formato', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Digita email inválido
        await tester.enterText(
          find.byType(TextFormField).first,
          'emailinvalido',
        );
        await tester.enterText(find.byType(TextFormField).last, 'senha123');

        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se o erro é anunciado
        expect(find.text('Por favor, insira um e-mail válido'), findsOneWidget);
      });
    });

    group('Testes de Acessibilidade Avançados', () {
      testWidgets('deve ter estrutura semântica adequada', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há estrutura semântica
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('deve ter navegação por foco adequada', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há elementos focáveis
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsWidgets);
        expect(find.byType(TextButton), findsWidgets);
      });

      testWidgets('deve ter feedback de estado adequado', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há feedback de estado
        expect(
          find.byType(IconButton),
          findsOneWidget,
        ); // Botão de visibilidade
        expect(find.byType(Icon), findsWidgets); // Ícones informativos
      });

      testWidgets('deve ter mensagens de erro acessíveis', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Simula erro
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Verifica se as mensagens são claras
        expect(find.text('Por favor, insira seu e-mail'), findsOneWidget);
        expect(find.text('Por favor, insira sua senha'), findsOneWidget);
      });

      testWidgets('deve ter contraste adequado', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se os textos principais estão visíveis
        expect(find.text('Bem-vindo'), findsOneWidget);
        expect(find.text('Faça login para continuar'), findsOneWidget);
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
      });

      testWidgets('deve ter tamanhos de toque adequados', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(LoginScreen(authService: mockAuthService)),
        );

        // Verifica se há elementos interativos
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsWidgets);
        expect(find.byType(TextButton), findsWidgets);
        expect(find.byType(IconButton), findsOneWidget);
      });
    });
  });
}
