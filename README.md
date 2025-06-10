# NutriPro Flutter

Um aplicativo Flutter para nutrição com integração Firebase e Google Gemini AI.

## Configuração de Variáveis de Ambiente

Este projeto utiliza variáveis de ambiente para armazenar chaves de API de forma segura.

### Configuração Inicial

1. Copie o arquivo de exemplo:
   ```bash
   cp .env.example .env
   ```

2. Edite o arquivo `.env` e configure sua chave da API do Gemini:
   ```
   GEMINI_API_KEY=sua_chave_api_aqui
   ```

### Como obter a chave da API do Google Gemini

1. Acesse [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Faça login com sua conta Google
3. Clique em "Create API Key"
4. Copie a chave gerada e cole no arquivo `.env`

### ⚠️ Importante

- **NUNCA** commite o arquivo `.env` no Git
- O arquivo `.env` está listado no `.gitignore` para sua segurança
- Use o arquivo `.env.example` para documentar as variáveis necessárias

## Getting Started

1. Instale as dependências:
   ```bash
   flutter pub get
   ```

2. Configure o arquivo `.env` conforme as instruções acima

3. Execute o aplicativo:
   ```bash
   flutter run
   ```

## Recursos do Flutter

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/)
