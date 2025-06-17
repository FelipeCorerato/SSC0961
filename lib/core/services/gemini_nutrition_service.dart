import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../domain/models/diet.dart';

class GeminiNutritionService {
  final Gemini _gemini = Gemini.instance;

  Future<Diet?> generateDiet({
    required String goal,
    required int age,
    required double weight,
    required String activityLevel,
    String? additionalInfo,
  }) async {
    try {
      // Monta a mensagem para o Gemini
      final message = _buildDietPrompt(
        goal: goal,
        age: age,
        weight: weight,
        activityLevel: activityLevel,
        additionalInfo: additionalInfo,
      ); // Chama o Gemini
      final response = await _gemini.text(message);

      if (response?.output == null) {
        throw Exception('Resposta vazia do Gemini');
      }

      // Extrai o JSON da resposta
      final jsonString = _extractJsonFromResponse(response!.output!);

      if (jsonString == null) {
        throw Exception('Não foi possível extrair JSON válido da resposta');
      }

      // Converte para objeto Diet
      final jsonData = json.decode(jsonString);
      return Diet.fromJson(jsonData);
    } catch (e) {
      print('Erro ao gerar dieta: $e');
      return null;
    }
  }

  String _buildDietPrompt({
    required String goal,
    required int age,
    required double weight,
    required String activityLevel,
    String? additionalInfo,
  }) {
    final baseMessage =
        '''
Monte uma dieta para $goal para uma pessoa de $age anos que pesa ${weight}kg e tem uma rotina $activityLevel de atividades físicas.
${additionalInfo != null ? 'Informações adicionais: $additionalInfo' : ''}

As unidades da resposta devem ser gramas e calorias e ela deve ser dada EXATAMENTE neste formato JSON (sem formatação markdown, apenas o JSON puro):

{
  "refeições": [
    {
      "refeição": "Café da manhã",
      "alimentos": [
        {
          "alimento": "Nome do alimento",
          "quantidade": "quantidade em gramas ou unidades",
          "proteína": valor_numerico,
          "carboidrato": valor_numerico,
          "gordura": valor_numerico,
          "calorias": valor_numerico
        }
      ]
    }
  ]
}

IMPORTANTE: 
- Retorne APENAS o JSON, sem texto adicional
- Use "refeições" e "proteína" com acentos
- Inclua pelo menos 5 refeições (café da manhã, lanche da manhã, almoço, lanche da tarde, jantar)
- Valores nutricionais devem ser números (não strings)
- Seja específico nas quantidades e alimentos
''';

    return baseMessage;
  }

  String? _extractJsonFromResponse(String response) {
    try {
      // Remove possível formatação markdown
      String cleanResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Procura pelo início e fim do JSON
      final startIndex = cleanResponse.indexOf('{');
      final lastIndex = cleanResponse.lastIndexOf('}');

      if (startIndex != -1 && lastIndex != -1 && lastIndex > startIndex) {
        return cleanResponse.substring(startIndex, lastIndex + 1);
      }

      // Se não encontrou chaves, tenta a resposta completa
      if (cleanResponse.startsWith('{') && cleanResponse.endsWith('}')) {
        return cleanResponse;
      }

      return null;
    } catch (e) {
      print('Erro ao extrair JSON: $e');
      return null;
    }
  }

  Future<String?> getNutritionAdvice(String question) async {
    try {
      final message =
          '''
Você é um nutricionista especializado. Responda a seguinte pergunta sobre nutrição de forma clara e educativa:

$question

Dê uma resposta prática e baseada em evidências científicas, mantendo um tom amigável e profissional.
''';

      final response = await _gemini.text(message);
      return response?.output;
    } catch (e) {
      print('Erro ao obter conselho nutricional: $e');
      return null;
    }
  }

  Future<DietFood?> replaceFood({
    required String originalFood,
    required String mealName,
    required String originalQuantity,
    required double originalProteins,
    required double originalCarbs,
    required double originalFats,
    required double originalCalories,
  }) async {
    try {
      final message =
          '''
Troque o item "$originalFood" da refeição "$mealName" por algo equivalente nutricionalmente.

Alimento original:
- Nome: $originalFood
- Quantidade: $originalQuantity
- Proteínas: ${originalProteins}g
- Carboidratos: ${originalCarbs}g
- Gorduras: ${originalFats}g
- Calorias: ${originalCalories}kcal

Encontre um substituto com valores nutricionais similares (±10% de diferença é aceitável).

As unidades da resposta devem ser gramas e calorias e ela deve ser apenas esse alimento neste formato JSON (sem formatação markdown, apenas o JSON puro):

{
  "alimento": "nome_do_alimento_substituto",
  "quantidade": "quantidade_em_gramas_ou_unidades", 
  "proteina": valor_numerico,
  "carboidrato": valor_numerico,
  "gordura": valor_numerico,
  "calorias": valor_numerico
}

IMPORTANTE: 
- Retorne APENAS o JSON, sem texto adicional
- Use "proteina" sem acento
- Valores nutricionais devem ser números (não strings)
- Busque um alimento que faça sentido para a refeição "$mealName"
''';

      final response = await _gemini.text(message);

      if (response?.output == null) {
        throw Exception('Resposta vazia do Gemini');
      }

      // Extrai o JSON da resposta
      final jsonString = _extractJsonFromResponse(response!.output!);

      if (jsonString == null) {
        throw Exception('Não foi possível extrair JSON válido da resposta');
      }

      // Converte para objeto DietFood
      final jsonData = json.decode(jsonString);
      return DietFood.fromJson(jsonData);
    } catch (e) {
      print('Erro ao substituir alimento: $e');
      return null;
    }
  }

  Future<String?> getFoodPreparationDetails({
    required String foodName,
    required String mealName,
    required String quantity,
  }) async {
    try {
      final message =
          '''
Como essa comida "$foodName" da refeição "$mealName" deve ser preparada?

Detalhes do alimento:
- Nome: $foodName
- Quantidade: $quantity
- Refeição: $mealName

Forneça instruções práticas e detalhadas sobre:
1. Como preparar este alimento
2. Métodos de cocção recomendados
3. Temperos e condimentos sugeridos
4. Dicas de preparo para maximizar o valor nutricional
5. Tempo de preparo estimado

Mantenha as instruções claras e práticas para uso doméstico.
''';

      final response = await _gemini.text(message);
      return response?.output;
    } catch (e) {
      print('Erro ao obter detalhes de preparo: $e');
      return null;
    }
  }
}
