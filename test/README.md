# Testes do NutriPro Flutter

Este diretório contém todos os testes do projeto NutriPro Flutter.

## Estrutura dos Testes

```
test/
├── unit/                    # Testes unitários
│   ├── models/             # Testes dos modelos de dados
│   │   ├── user_test.dart
│   │   └── diet_test.dart
│   ├── utils/              # Testes dos utilitários
│   │   └── validation_helper_test.dart
│   └── services/           # Testes dos serviços
│       └── mock_authentication_service_test.dart
├── widget/                 # Testes de widgets
│   └── login_screen_test.dart
├── all_tests.dart          # Arquivo para executar todos os testes
├── widget_test.dart        # Teste principal do widget
└── README.md              # Este arquivo
```

## Como Executar os Testes

### Executar todos os testes:
```bash
flutter test
```

### Executar testes específicos:
```bash
# Apenas testes unitários
flutter test test/unit/

# Apenas testes de widgets
flutter test test/widget/

# Apenas testes de modelos
flutter test test/unit/models/

# Teste específico
flutter test test/unit/models/user_test.dart
```

### Executar com cobertura:
```bash
flutter test --coverage
```

## Tipos de Testes

### Testes Unitários (`test/unit/`)
- **Modelos**: Testam a criação, serialização e lógica dos modelos de dados
- **Utilitários**: Testam funções auxiliares como validação
- **Serviços**: Testam a lógica de negócio dos serviços

### Testes de Widget (`test/widget/`)
- **Telas**: Testam a interface do usuário e interações
- **Navegação**: Testam fluxos de navegação entre telas
- **Validação**: Testam validação de formulários na UI

## Convenções de Nomenclatura

- Arquivos de teste: `*_test.dart`
- Grupos de teste: `group('Nome do Grupo', () {})`
- Casos de teste: `test('descrição do teste', () {})`
- Testes de widget: `testWidgets('descrição do teste', (WidgetTester tester) async {})`

## Exemplos de Testes

### Teste Unitário Simples
```dart
test('deve retornar null para email válido', () {
  final result = ValidationHelper.validateEmail('teste@email.com');
  expect(result, isNull);
});
```

### Teste de Widget
```dart
testWidgets('deve exibir campo de email', (WidgetTester tester) async {
  await tester.pumpWidget(createLoginScreen());
  expect(find.text('E-mail'), findsOneWidget);
});
```

## Boas Práticas

1. **Organização**: Mantenha os testes organizados por tipo e funcionalidade
2. **Nomes descritivos**: Use nomes que descrevam claramente o que está sendo testado
3. **Setup e Teardown**: Use `setUp()` e `tearDown()` para preparar e limpar o ambiente
4. **Mocks**: Use serviços mock para testar isoladamente
5. **Cobertura**: Mantenha uma boa cobertura de testes (idealmente >80%)

## Adicionando Novos Testes

1. Crie o arquivo de teste no diretório apropriado
2. Siga as convenções de nomenclatura
3. Importe as dependências necessárias
4. Execute os testes para verificar se funcionam
5. Atualize este README se necessário

## Dependências de Teste

As dependências de teste estão configuradas no `pubspec.yaml`:
- `flutter_test`: Framework de testes do Flutter
- `mockito`: Para criar mocks (se necessário)
- `integration_test`: Para testes de integração (se necessário) 