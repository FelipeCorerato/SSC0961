# CI/CD Configuration

Este diretório contém as configurações de CI/CD (Continuous Integration/Continuous Deployment) para o projeto NutriPro Flutter.

## Workflows Disponíveis

### 1. `test.yml` - Testes Automatizados
**Trigger:** Push para `main`/`develop` e Pull Requests

**Executa:**
- ✅ Verificação de formatação do código (`dart format`)
- ✅ Análise estática (`flutter analyze`)
- ✅ Execução de todos os testes (`flutter test`)
- ✅ Geração de relatório de cobertura (`flutter test --coverage`)

### 2. `flutter.yml` - Pipeline Completa (Opcional)
**Trigger:** Push para `main`/`develop` e Pull Requests

**Executa:**
- ✅ Todos os passos do `test.yml`
- ✅ Build para Android (APK)
- ✅ Build para iOS (sem assinatura)
- ✅ Build para Web
- ✅ Upload de artifacts

## Configuração

### Pré-requisitos
- Flutter 3.24.0+
- Java 17+
- GitHub Actions habilitado no repositório

### Variáveis de Ambiente (Opcional)
Para builds completos, você pode configurar:

```yaml
# Secrets do GitHub (Settings > Secrets and variables > Actions)
FIREBASE_SERVICE_ACCOUNT_KEY: # Para builds com Firebase
GEMINI_API_KEY: # Para testes com Gemini
```

## Status Badges

Adicione estes badges ao seu README.md:

```markdown
![Testes](https://github.com/{username}/{repo}/workflows/Testes/badge.svg)
![Cobertura](https://codecov.io/gh/{username}/{repo}/branch/main/graph/badge.svg)
```

## Monitoramento

### GitHub Actions
- Acesse: `https://github.com/{username}/{repo}/actions`
- Visualize logs detalhados de cada execução
- Configure notificações para falhas

### Codecov (Opcional)
- Acesse: `https://codecov.io/gh/{username}/{repo}`
- Relatórios detalhados de cobertura
- Histórico de cobertura ao longo do tempo

## Troubleshooting

### Problemas Comuns

1. **Testes falhando no CI mas passando localmente**
   - Verifique dependências do sistema
   - Confirme versão do Flutter
   - Teste com `flutter clean && flutter pub get`

2. **Build falhando**
   - Verifique configurações de Android/iOS
   - Confirme que todas as dependências estão no `pubspec.yaml`

3. **Cobertura não gerada**
   - Verifique se o arquivo `coverage/lcov.info` existe
   - Confirme que os testes estão executando corretamente

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