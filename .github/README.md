# CI/CD Configuration

Este diretório contém as configurações de CI/CD (Continuous Integration/Continuous Deployment) para o projeto NutriPro Flutter.

## Workflow Principal

### `ci.yml` - Pipeline Completa
**Trigger:** Push para `main`/`develop` e Pull Requests

**Jobs:**
1. **Testes e Análise** (obrigatório)
   - ✅ Verificação de formatação do código (`dart format`)
   - ✅ Análise estática (`flutter analyze`)
   - ✅ Execução de todos os testes (`flutter test`)
   - ✅ Geração de relatório de cobertura (`flutter test --coverage`)

2. **Build Web** (obrigatório)
   - ✅ Build para Web (`flutter build web --release`)
   - ✅ Upload do build como artifact

3. **Build Android** (opcional)
   - ⚠️ Build para Android (`flutter build apk --release`)
   - ⚠️ Upload do APK como artifact
   - ⚠️ Pode falhar sem quebrar o pipeline (`continue-on-error: true`)

## Configuração

### Pré-requisitos
- Flutter (versão estável)
- GitHub Actions habilitado no repositório

### Variáveis de Ambiente
O workflow cria automaticamente um arquivo `.env` com valores de teste:
```bash
GEMINI_API_KEY=test_key
FIREBASE_API_KEY=test_key
```

## Status Badges

Adicione estes badges ao seu README.md:

```markdown
![CI/CD](https://github.com/{username}/{repo}/workflows/CI%2FCD%20Pipeline/badge.svg)
```

## Monitoramento

### GitHub Actions
- Acesse: `https://github.com/{username}/{repo}/actions`
- Visualize logs detalhados de cada execução
- Configure notificações para falhas

### Artifacts
- **Web Build**: Disponível em `Actions > Workflow runs > Artifacts`
- **Android APK**: Disponível quando o build Android passar

## Estrutura do Pipeline

```
┌─────────────────┐
│   Testes        │ ← Obrigatório
│   e Análise     │
└─────────┬───────┘
          │
    ┌─────▼─────┐    ┌─────────────────┐
    │ Build Web │    │ Build Android   │
    │           │    │   (Opcional)    │
    └───────────┘    └─────────────────┘
```

## Troubleshooting

### Problemas Comuns

1. **Testes falhando**
   - Verifique se o arquivo `.env` está sendo criado
   - Confirme que todas as dependências estão no `pubspec.yaml`

2. **Build Android falhando**
   - Este job é opcional e não quebra o pipeline
   - Verifique logs para identificar problemas específicos
   - Pode ser corrigido gradualmente

3. **Build Web falhando**
   - Verifique configurações do Flutter Web
   - Confirme que não há dependências específicas de mobile

### Logs Úteis
```bash
# Verificar versão do Flutter
flutter --version

# Limpar cache
flutter clean

# Verificar dependências
flutter doctor

# Executar testes com verbose
flutter test --verbose
```

## Próximos Passos

- [ ] Configurar deploy automático para staging
- [ ] Adicionar testes de performance
- [ ] Configurar análise de segurança
- [ ] Implementar cache de dependências
- [ ] Corrigir build Android (quando necessário) 