import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../../domain/models/diet.dart';
import '../../core/services/gemini_nutrition_service.dart';

class NutriAIScreen extends StatefulWidget {
  final User user;

  const NutriAIScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NutriAIScreen> createState() => _NutriAIScreenState();
}

class _NutriAIScreenState extends State<NutriAIScreen> {
  final GeminiNutritionService _nutritionService = GeminiNutritionService();
  Diet? _currentDiet;
  bool _isLoading = false;
  String? _errorMessage;
  String? _replacingFoodId; // Para indicar qual alimento está sendo substituído

  // Controladores para o formulário
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedGoal = 'ganho de massa';
  String _selectedActivity = 'consistente';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _fillExampleData() {
    setState(() {
      _ageController.text = '21';
      _weightController.text = '65';
      _selectedGoal = 'ganho de massa';
      _selectedActivity = 'consistente';
    });
  }

  Future<void> _generateDiet() async {
    if (_ageController.text.isEmpty || _weightController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha idade e peso';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final age = int.parse(_ageController.text);
      final weight = double.parse(_weightController.text);

      final diet = await _nutritionService.generateDiet(
        goal: _selectedGoal,
        age: age,
        weight: weight,
        activityLevel: _selectedActivity,
      );

      setState(() {
        _currentDiet = diet;
        _isLoading = false;
      });

      if (diet == null) {
        setState(() {
          _errorMessage = 'Erro ao gerar dieta. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro: Verifique se idade e peso são números válidos';
      });
    }
  }

  Future<void> _replaceFood(
    DietFood food,
    DietMeal meal,
    int mealIndex,
    int foodIndex,
  ) async {
    final foodId = '${mealIndex}_$foodIndex';

    setState(() {
      _replacingFoodId = foodId;
      _errorMessage = null;
    });

    try {
      final replacementFood = await _nutritionService.replaceFood(
        originalFood: food.alimento,
        mealName: meal.refeicao,
        originalQuantity: food.quantidade,
        originalProteins: food.proteina,
        originalCarbs: food.carboidrato,
        originalFats: food.gordura,
        originalCalories: food.calorias,
      );

      if (replacementFood != null && _currentDiet != null) {
        setState(() {
          _currentDiet!.refeicoes[mealIndex].alimentos[foodIndex] =
              replacementFood;
          _replacingFoodId = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${food.alimento} foi substituído por ${replacementFood.alimento}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _replacingFoodId = null;
          _errorMessage = 'Não foi possível encontrar um substituto adequado';
        });
      }
    } catch (e) {
      setState(() {
        _replacingFoodId = null;
        _errorMessage = 'Erro ao substituir alimento: $e';
      });
    }
  }

  Future<void> _showFoodDetails(DietFood food, DietMeal meal) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Detalhes de Preparo',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.alimento,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${meal.refeicao} • ${food.quantidade}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Buscando detalhes de preparo...',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );

    try {
      final details = await _nutritionService.getFoodPreparationDetails(
        foodName: food.alimento,
        mealName: meal.refeicao,
        quantity: food.quantidade,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Fecha o dialog de loading

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Como Preparar', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.alimento,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${meal.refeicao} • ${food.quantidade}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNutrientChip(
                                'P',
                                '${food.proteina.toStringAsFixed(1)}g',
                              ),
                              _buildNutrientChip(
                                'C',
                                '${food.carboidrato.toStringAsFixed(1)}g',
                              ),
                              _buildNutrientChip(
                                'G',
                                '${food.gordura.toStringAsFixed(1)}g',
                              ),
                              _buildNutrientChip(
                                'Cal',
                                '${food.calorias.toStringAsFixed(0)}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormattedText(
                      details ?? 'Não foi possível obter detalhes de preparo.',
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Fecha o dialog de loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter detalhes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildNutrientChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text) {
    final lines = text.split('\n');
    final List<Widget> widgets = [];

    for (String line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Título principal (##)
      if (trimmedLine.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              trimmedLine.substring(3),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }
      // Subtítulo (**texto**)
      else if (trimmedLine.startsWith('**') && trimmedLine.endsWith('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              trimmedLine.substring(2, trimmedLine.length - 2),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }
      // Item de lista (* texto)
      else if (trimmedLine.startsWith('* ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Expanded(
                  child: Text(
                    trimmedLine.substring(2),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Lista numerada (1. texto)
      else if (RegExp(r'^\d+\. ').hasMatch(trimmedLine)) {
        final match = RegExp(r'^(\d+)\. (.+)').firstMatch(trimmedLine);
        if (match != null) {
          final number = match.group(1);
          final content = match.group(2);

          widgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      '$number.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      // Texto em negrito destacado (**texto:** restante)
      else if (trimmedLine.contains('**') && trimmedLine.contains(':')) {
        final parts = trimmedLine.split('**');
        if (parts.length >= 3) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: parts[1],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: parts.length > 2 ? parts.sublist(2).join('**') : '',
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Texto normal como fallback
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                trimmedLine,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        }
      }
      // Texto normal
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              trimmedLine,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriAI'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formulário para gerar dieta
            _buildDietForm(),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              _buildLoadingWidget(),
            ],

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorWidget(),
            ],

            if (_currentDiet != null) ...[
              const SizedBox(height: 24),
              _buildDietDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDietForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gerar Dieta Personalizada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Botão de exemplo
            TextButton.icon(
              onPressed: _fillExampleData,
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: const Text('Usar exemplo (Homem 21 anos, 65kg)'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Idade
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
                suffixText: 'anos',
              ),
            ),
            const SizedBox(height: 16),

            // Peso
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 16),

            // Objetivo
            DropdownButtonFormField<String>(
              value: _selectedGoal,
              decoration: const InputDecoration(
                labelText: 'Objetivo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'ganho de massa',
                  child: Text('Ganho de massa'),
                ),
                DropdownMenuItem(
                  value: 'perda de peso',
                  child: Text('Perda de peso'),
                ),
                DropdownMenuItem(
                  value: 'manutenção',
                  child: Text('Manutenção'),
                ),
                DropdownMenuItem(
                  value: 'definição',
                  child: Text('Definição muscular'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGoal = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Nível de atividade
            DropdownButtonFormField<String>(
              value: _selectedActivity,
              decoration: const InputDecoration(
                labelText: 'Nível de atividade física',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'sedentária',
                  child: Text('Sedentária'),
                ),
                DropdownMenuItem(value: 'leve', child: Text('Leve')),
                DropdownMenuItem(value: 'moderada', child: Text('Moderada')),
                DropdownMenuItem(
                  value: 'consistente',
                  child: Text('Consistente'),
                ),
                DropdownMenuItem(value: 'intensa', child: Text('Intensa')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Botão gerar
            ElevatedButton(
              onPressed: _isLoading ? null : _generateDiet,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isLoading ? 'Gerando dieta...' : 'Gerar Dieta com IA',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Dica sobre a funcionalidade de trocar alimentos
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dica: Após gerar a dieta, você pode ver detalhes de preparo (ⓘ) ou trocar qualquer alimento (⇄) clicando nos ícones ao lado dele.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Gerando sua dieta personalizada...'),
            SizedBox(height: 8),
            Text(
              'Isso pode levar alguns segundos',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumo nutricional
        _buildNutritionalSummary(),
        const SizedBox(height: 16),

        // Lista de refeições
        Text('Plano Alimentar', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),

        ...(_currentDiet!.refeicoes.asMap().entries.map((entry) {
          final mealIndex = entry.key;
          final meal = entry.value;
          return _buildMealCard(meal, mealIndex);
        }).toList()),
      ],
    );
  }

  Widget _buildNutritionalSummary() {
    return Card(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo Nutricional Diário',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo(
                  'Calorias',
                  '${_currentDiet!.totalCalorias.toStringAsFixed(0)} kcal',
                ),
                _buildNutrientInfo(
                  'Proteínas',
                  '${_currentDiet!.totalProteinas.toStringAsFixed(1)}g',
                ),
                _buildNutrientInfo(
                  'Carboidratos',
                  '${_currentDiet!.totalCarboidratos.toStringAsFixed(1)}g',
                ),
                _buildNutrientInfo(
                  'Gorduras',
                  '${_currentDiet!.totalGorduras.toStringAsFixed(1)}g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildMealCard(DietMeal meal, int mealIndex) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          meal.refeicao,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${meal.totalCalorias.toStringAsFixed(0)} kcal • ${meal.alimentos.length} ${meal.alimentos.length == 1 ? 'alimento' : 'alimentos'}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Lista de alimentos
                ...meal.alimentos.asMap().entries.map((entry) {
                  final foodIndex = entry.key;
                  final food = entry.value;
                  return _buildFoodItem(food, meal, mealIndex, foodIndex);
                }),

                const Divider(),

                // Totais da refeição
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSmallNutrientInfo(
                      'P',
                      '${meal.totalProteinas.toStringAsFixed(1)}g',
                    ),
                    _buildSmallNutrientInfo(
                      'C',
                      '${meal.totalCarboidratos.toStringAsFixed(1)}g',
                    ),
                    _buildSmallNutrientInfo(
                      'G',
                      '${meal.totalGorduras.toStringAsFixed(1)}g',
                    ),
                    _buildSmallNutrientInfo(
                      'Cal',
                      meal.totalCalorias.toStringAsFixed(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(
    DietFood food,
    DietMeal meal,
    int mealIndex,
    int foodIndex,
  ) {
    final foodId = '${mealIndex}_$foodIndex';
    final isReplacing = _replacingFoodId == foodId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.alimento,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isReplacing ? Colors.grey : null,
                  ),
                ),
                Text(
                  food.quantidade,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${food.proteina.toStringAsFixed(1)}g',
                  style: TextStyle(
                    fontSize: 12,
                    color: isReplacing ? Colors.grey : null,
                  ),
                ),
                Text(
                  '${food.carboidrato.toStringAsFixed(1)}g',
                  style: TextStyle(
                    fontSize: 12,
                    color: isReplacing ? Colors.grey : null,
                  ),
                ),
                Text(
                  '${food.gordura.toStringAsFixed(1)}g',
                  style: TextStyle(
                    fontSize: 12,
                    color: isReplacing ? Colors.grey : null,
                  ),
                ),
                Text(
                  '${food.calorias.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isReplacing ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ),
          // Botões de ação
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão de detalhes
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: _isLoading
                      ? null
                      : () => _showFoodDetails(food, meal),
                  icon: const Icon(Icons.info_outline, size: 16),
                  tooltip: 'Ver detalhes de preparo',
                  iconSize: 16,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              // Botão para trocar alimento ou indicador de carregamento
              SizedBox(
                width: 32,
                height: 32,
                child: isReplacing
                    ? const Padding(
                        padding: EdgeInsets.all(6),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: _isLoading
                            ? null
                            : () => _replaceFood(
                                food,
                                meal,
                                mealIndex,
                                foodIndex,
                              ),
                        icon: const Icon(Icons.swap_horiz, size: 16),
                        tooltip: 'Trocar alimento',
                        iconSize: 16,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
