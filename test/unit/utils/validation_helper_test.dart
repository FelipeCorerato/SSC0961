import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/core/utils/validation_helper.dart';

void main() {
  group('ValidationHelper Tests', () {
    group('validateEmail', () {
      test('deve retornar null para email válido', () {
        final result = ValidationHelper.validateEmail('teste@email.com');
        expect(result, isNull);
      });

      test('deve retornar null para email válido com subdomínio', () {
        final result = ValidationHelper.validateEmail('teste@subdomain.email.com');
        expect(result, isNull);
      });

      test('deve retornar erro para email vazio', () {
        final result = ValidationHelper.validateEmail('');
        expect(result, 'Por favor, insira seu e-mail');
      });

      test('deve retornar erro para email null', () {
        final result = ValidationHelper.validateEmail(null);
        expect(result, 'Por favor, insira seu e-mail');
      });

      test('deve retornar erro para email sem @', () {
        final result = ValidationHelper.validateEmail('testeemail.com');
        expect(result, 'Por favor, insira um e-mail válido');
      });

      test('deve retornar erro para email sem domínio', () {
        final result = ValidationHelper.validateEmail('teste@');
        expect(result, 'Por favor, insira um e-mail válido');
      });

      test('deve retornar erro para email sem parte local', () {
        final result = ValidationHelper.validateEmail('@email.com');
        expect(result, 'Por favor, insira um e-mail válido');
      });

      test('deve retornar erro para email com caracteres inválidos', () {
        final result = ValidationHelper.validateEmail('teste@email..com');
        expect(result, 'Por favor, insira um e-mail válido');
      });
    });

    group('validatePassword', () {
      test('deve retornar null para senha válida com 6 caracteres', () {
        final result = ValidationHelper.validatePassword('123456');
        expect(result, isNull);
      });

      test('deve retornar null para senha válida com mais de 6 caracteres', () {
        final result = ValidationHelper.validatePassword('senha123');
        expect(result, isNull);
      });

      test('deve retornar erro para senha vazia', () {
        final result = ValidationHelper.validatePassword('');
        expect(result, 'Por favor, insira sua senha');
      });

      test('deve retornar erro para senha null', () {
        final result = ValidationHelper.validatePassword(null);
        expect(result, 'Por favor, insira sua senha');
      });

      test('deve retornar erro para senha com menos de 6 caracteres', () {
        final result = ValidationHelper.validatePassword('12345');
        expect(result, 'A senha deve ter pelo menos 6 caracteres');
      });

      test('deve retornar erro para senha com exatamente 5 caracteres', () {
        final result = ValidationHelper.validatePassword('abcde');
        expect(result, 'A senha deve ter pelo menos 6 caracteres');
      });
    });
  });
} 