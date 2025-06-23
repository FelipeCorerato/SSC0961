import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/domain/models/diet.dart';

void main() {
  group('DietFood Model Tests', () {
    test('deve criar um alimento com todos os campos', () {
      final food = DietFood(
        alimento: 'Frango',
        quantidade: '100g',
        proteina: 25.0,
        carboidrato: 0.0,
        gordura: 3.0,
        calorias: 165.0,
      );

      expect(food.alimento, 'Frango');
      expect(food.quantidade, '100g');
      expect(food.proteina, 25.0);
      expect(food.carboidrato, 0.0);
      expect(food.gordura, 3.0);
      expect(food.calorias, 165.0);
    });

    test('deve converter de JSON para DietFood', () {
      final json = {
        'alimento': 'Arroz',
        'quantidade': '50g',
        'proteína': 2.5,
        'carboidrato': 38.0,
        'gordura': 0.5,
        'calorias': 165.0,
      };

      final food = DietFood.fromJson(json);

      expect(food.alimento, 'Arroz');
      expect(food.quantidade, '50g');
      expect(food.proteina, 2.5);
      expect(food.carboidrato, 38.0);
      expect(food.gordura, 0.5);
      expect(food.calorias, 165.0);
    });

    test('deve converter DietFood para JSON', () {
      final food = DietFood(
        alimento: 'Batata',
        quantidade: '150g',
        proteina: 3.0,
        carboidrato: 30.0,
        gordura: 0.2,
        calorias: 130.0,
      );

      final json = food.toJson();

      expect(json['alimento'], 'Batata');
      expect(json['quantidade'], '150g');
      expect(json['proteína'], 3.0);
      expect(json['carboidrato'], 30.0);
      expect(json['gordura'], 0.2);
      expect(json['calorias'], 130.0);
    });
  });

  group('DietMeal Model Tests', () {
    test('deve criar uma refeição com alimentos', () {
      final foods = [
        DietFood(
          alimento: 'Frango',
          quantidade: '100g',
          proteina: 25.0,
          carboidrato: 0.0,
          gordura: 3.0,
          calorias: 165.0,
        ),
        DietFood(
          alimento: 'Arroz',
          quantidade: '50g',
          proteina: 2.5,
          carboidrato: 38.0,
          gordura: 0.5,
          calorias: 165.0,
        ),
      ];

      final meal = DietMeal(refeicao: 'Almoço', alimentos: foods);

      expect(meal.refeicao, 'Almoço');
      expect(meal.alimentos.length, 2);
      expect(meal.totalProteinas, 27.5);
      expect(meal.totalCarboidratos, 38.0);
      expect(meal.totalGorduras, 3.5);
      expect(meal.totalCalorias, 330.0);
    });

    test('deve converter de JSON para DietMeal', () {
      final json = {
        'refeição': 'Café da manhã',
        'alimentos': [
          {
            'alimento': 'Ovo',
            'quantidade': '1 unidade',
            'proteína': 6.0,
            'carboidrato': 0.6,
            'gordura': 5.0,
            'calorias': 70.0,
          },
        ],
      };

      final meal = DietMeal.fromJson(json);

      expect(meal.refeicao, 'Café da manhã');
      expect(meal.alimentos.length, 1);
      expect(meal.alimentos.first.alimento, 'Ovo');
      expect(meal.totalProteinas, 6.0);
    });

    test('deve converter DietMeal para JSON', () {
      final foods = [
        DietFood(
          alimento: 'Banana',
          quantidade: '1 unidade',
          proteina: 1.0,
          carboidrato: 25.0,
          gordura: 0.3,
          calorias: 105.0,
        ),
      ];

      final meal = DietMeal(refeicao: 'Lanche', alimentos: foods);
      final json = meal.toJson();

      expect(json['refeição'], 'Lanche');
      expect(json['alimentos'].length, 1);
      expect(json['alimentos'][0]['alimento'], 'Banana');
    });
  });

  group('Diet Model Tests', () {
    test('deve criar uma dieta com refeições', () {
      final meals = [
        DietMeal(
          refeicao: 'Café da manhã',
          alimentos: [
            DietFood(
              alimento: 'Ovo',
              quantidade: '1 unidade',
              proteina: 6.0,
              carboidrato: 0.6,
              gordura: 5.0,
              calorias: 70.0,
            ),
          ],
        ),
        DietMeal(
          refeicao: 'Almoço',
          alimentos: [
            DietFood(
              alimento: 'Frango',
              quantidade: '100g',
              proteina: 25.0,
              carboidrato: 0.0,
              gordura: 3.0,
              calorias: 165.0,
            ),
          ],
        ),
      ];

      final diet = Diet(refeicoes: meals);

      expect(diet.refeicoes.length, 2);
      expect(diet.totalProteinas, 31.0);
      expect(diet.totalCarboidratos, 0.6);
      expect(diet.totalGorduras, 8.0);
      expect(diet.totalCalorias, 235.0);
    });

    test('deve converter de JSON para Diet', () {
      final json = {
        'refeições': [
          {
            'refeição': 'Jantar',
            'alimentos': [
              {
                'alimento': 'Salmão',
                'quantidade': '150g',
                'proteína': 30.0,
                'carboidrato': 0.0,
                'gordura': 12.0,
                'calorias': 250.0,
              },
            ],
          },
        ],
      };

      final diet = Diet.fromJson(json);

      expect(diet.refeicoes.length, 1);
      expect(diet.refeicoes.first.refeicao, 'Jantar');
      expect(diet.totalProteinas, 30.0);
      expect(diet.totalCalorias, 250.0);
    });

    test('deve converter Diet para JSON', () {
      final meals = [
        DietMeal(
          refeicao: 'Café da manhã',
          alimentos: [
            DietFood(
              alimento: 'Aveia',
              quantidade: '30g',
              proteina: 4.0,
              carboidrato: 20.0,
              gordura: 2.0,
              calorias: 110.0,
            ),
          ],
        ),
      ];

      final diet = Diet(refeicoes: meals);
      final json = diet.toJson();

      expect(json['refeições'].length, 1);
      expect(json['refeições'][0]['refeição'], 'Café da manhã');
      expect(json['refeições'][0]['alimentos'][0]['alimento'], 'Aveia');
    });
  });
}
