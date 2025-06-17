class DietFood {
  final String alimento;
  final String quantidade;
  final double proteina;
  final double carboidrato;
  final double gordura;
  final double calorias;

  DietFood({
    required this.alimento,
    required this.quantidade,
    required this.proteina,
    required this.carboidrato,
    required this.gordura,
    required this.calorias,
  });

  factory DietFood.fromJson(Map<String, dynamic> json) {
    return DietFood(
      alimento: json['alimento'] as String,
      quantidade: json['quantidade'] as String,
      proteina: (json['proteína'] ?? json['proteina'] ?? 0).toDouble(),
      carboidrato: (json['carboidrato'] ?? 0).toDouble(),
      gordura: (json['gordura'] ?? 0).toDouble(),
      calorias: (json['calorias'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alimento': alimento,
      'quantidade': quantidade,
      'proteína': proteina,
      'carboidrato': carboidrato,
      'gordura': gordura,
      'calorias': calorias,
    };
  }
}

class DietMeal {
  final String refeicao;
  final List<DietFood> alimentos;

  DietMeal({required this.refeicao, required this.alimentos});

  factory DietMeal.fromJson(Map<String, dynamic> json) {
    return DietMeal(
      refeicao: json['refeição'] ?? json['refeicao'] ?? '',
      alimentos: (json['alimentos'] as List<dynamic>? ?? [])
          .map((food) => DietFood.fromJson(food as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refeição': refeicao,
      'alimentos': alimentos.map((food) => food.toJson()).toList(),
    };
  }

  // Métodos para calcular totais da refeição
  double get totalProteinas =>
      alimentos.fold(0, (sum, food) => sum + food.proteina);
  double get totalCarboidratos =>
      alimentos.fold(0, (sum, food) => sum + food.carboidrato);
  double get totalGorduras =>
      alimentos.fold(0, (sum, food) => sum + food.gordura);
  double get totalCalorias =>
      alimentos.fold(0, (sum, food) => sum + food.calorias);
}

class Diet {
  final List<DietMeal> refeicoes;

  Diet({required this.refeicoes});

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      refeicoes: (json['refeições'] as List<dynamic>? ?? [])
          .map((meal) => DietMeal.fromJson(meal as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'refeições': refeicoes.map((meal) => meal.toJson()).toList()};
  }

  // Métodos para calcular totais da dieta
  double get totalProteinas =>
      refeicoes.fold(0, (sum, meal) => sum + meal.totalProteinas);
  double get totalCarboidratos =>
      refeicoes.fold(0, (sum, meal) => sum + meal.totalCarboidratos);
  double get totalGorduras =>
      refeicoes.fold(0, (sum, meal) => sum + meal.totalGorduras);
  double get totalCalorias =>
      refeicoes.fold(0, (sum, meal) => sum + meal.totalCalorias);
}
