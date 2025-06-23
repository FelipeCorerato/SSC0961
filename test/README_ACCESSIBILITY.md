# Testes de Acessibilidade - NutriPro Flutter

Este documento descreve os testes de acessibilidade implementados para o aplicativo NutriPro Flutter, garantindo conformidade com as diretrizes WCAG 2.1 e uma experiência inclusiva para todos os usuários.

## 📁 Estrutura dos Testes

```
test/
├── accessibility_test.dart          # Testes principais de acessibilidade
├── README_ACCESSIBILITY.md         # Este arquivo
└── ACCESSIBILITY_SUMMARY.md        # Resumo dos padrões e resultados
```

## 🎯 Cobertura dos Testes

### 1. **Semântica e Labels** (4 testes)
- Labels semânticos apropriados
- Hints descritivos nos campos
- Botões com labels claros
- Ícones com labels semânticos

### 2. **Navegação por Teclado** (3 testes)
- Navegação por teclado na tela de login
- Ativação de botões
- Entrada de texto nos campos

### 3. **Contraste e Visibilidade** (3 testes)
- Contraste adequado nos textos
- Indicadores visuais para estados de erro
- Indicadores para campos obrigatórios

### 4. **Tamanho de Toque** (3 testes)
- Áreas de toque adequadas para botões
- Áreas de toque para campos de entrada
- Ícones com áreas de toque adequadas

### 5. **Feedback Tátil e Sonoro** (1 teste)
- Feedback tátil ao tocar botões

### 6. **Leitura de Tela** (3 testes)
- Textos descritivos para leitores de tela
- Anúncio de mudanças de estado
- Descrições para ícones

### 7. **Componentes Específicos** (1 teste)
- Acessibilidade do LoadingButton

### 8. **Navegação Acessível** (2 testes)
- Navegação entre telas
- Manutenção de foco adequado

### 9. **Validação Acessível** (2 testes)
- Anúncio de erros de validação
- Feedback imediato para erros de formato

### 10. **Acessibilidade Avançados** (6 testes)
- Estrutura semântica adequada
- Navegação por foco
- Feedback de estado
- Mensagens de erro acessíveis
- Contraste adequado
- Tamanhos de toque adequados

## 🚀 Como Executar

### Executar todos os testes de acessibilidade:
```bash
flutter test test/accessibility_test.dart
```

### Executar todos os testes do projeto (incluindo acessibilidade):
```bash
flutter test test/all_tests.dart
```

### Executar testes específicos:
```bash
# Testes de semântica
flutter test test/accessibility_test.dart --name="Semântica"

# Testes de navegação
flutter test test/accessibility_test.dart --name="Navegação"

# Testes de contraste
flutter test test/accessibility_test.dart --name="Contraste"
```

## 📊 Resultados Atuais

- **Total de testes**: 28
- **Testes passando**: 28 (100%)
- **Cobertura**: Abrangente para tela de login

## 🎨 Padrões WCAG 2.1 Seguidos

### Nível A (Básico)
- ✅ 1.1.1 - Conteúdo não textual
- ✅ 1.3.1 - Informação e relacionamentos
- ✅ 2.1.1 - Teclado
- ✅ 2.1.2 - Sem armadilha de teclado
- ✅ 2.4.1 - Bypass de blocos
- ✅ 2.4.2 - Título da página
- ✅ 3.2.1 - Foco
- ✅ 3.2.2 - Entrada
- ✅ 4.1.1 - Parsing
- ✅ 4.1.2 - Nome, função, valor

### Nível AA (Intermediário)
- ✅ 1.4.3 - Contraste (mínimo)
- ✅ 2.4.6 - Cabeçalhos e labels
- ✅ 3.1.2 - Idioma de partes
- ✅ 4.1.3 - Mensagens de status

### Nível AAA (Avançado)
- ✅ 1.4.6 - Contraste (melhorado)
- ✅ 2.1.3 - Teclado (sem exceções)
- ✅ 2.2.1 - Ajuste de tempo
- ✅ 2.3.1 - Três flashes
- ✅ 2.4.8 - Localização
- ✅ 3.1.1 - Idioma da página

## 🔧 Configuração dos Testes

Os testes utilizam:
- **Flutter Test Framework**: Para execução dos testes de widget
- **MockAuthenticationService**: Para simular autenticação sem dependências externas
- **MaterialApp**: Para fornecer contexto de tema e navegação
- **WidgetTester**: Para interação programática com widgets

## 📝 Exemplo de Teste

```dart
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
});
```

## 🚨 Problemas Conhecidos

### Resolvidos
- ~~Timer pendente no mock de autenticação~~ ✅
- ~~Overflow no layout da tela de login~~ ✅

### Monitoramento Contínuo
- Performance dos testes em diferentes dispositivos
- Compatibilidade com novas versões do Flutter
- Cobertura para novas telas adicionadas

## 🔄 Manutenção

### Adicionando Novos Testes
1. Identifique o componente ou funcionalidade a testar
2. Crie testes seguindo o padrão estabelecido
3. Execute os testes para garantir que passam
4. Atualize este documento se necessário

### Atualizando Testes Existentes
1. Execute todos os testes para verificar o estado atual
2. Faça as modificações necessárias
3. Execute novamente para garantir que não quebrou nada
4. Atualize a documentação se necessário

## 📚 Recursos Adicionais

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)

## 🤝 Contribuição

Para contribuir com melhorias nos testes de acessibilidade:

1. Identifique uma área que precisa de melhor cobertura
2. Crie testes seguindo os padrões estabelecidos
3. Execute todos os testes para garantir compatibilidade
4. Documente as mudanças neste README
5. Submeta um pull request

---

**Última atualização**: Dezembro 2024  
**Versão**: 1.0  
**Status**: ✅ Completo e funcional 