import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/domain/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('deve criar um usuário com todos os campos', () {
      final user = User(
        id: '123',
        email: 'teste@email.com',
        name: 'João Silva',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.id, '123');
      expect(user.email, 'teste@email.com');
      expect(user.name, 'João Silva');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('deve criar um usuário sem campos opcionais', () {
      final user = User(
        id: '123',
        email: 'teste@email.com',
      );

      expect(user.id, '123');
      expect(user.email, 'teste@email.com');
      expect(user.name, null);
      expect(user.photoUrl, null);
    });

    test('deve converter de JSON para User', () {
      final json = {
        'id': '123',
        'email': 'teste@email.com',
        'name': 'João Silva',
        'photoUrl': 'https://example.com/photo.jpg',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'teste@email.com');
      expect(user.name, 'João Silva');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('deve converter User para JSON', () {
      final user = User(
        id: '123',
        email: 'teste@email.com',
        name: 'João Silva',
        photoUrl: 'https://example.com/photo.jpg',
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'teste@email.com');
      expect(json['name'], 'João Silva');
      expect(json['photoUrl'], 'https://example.com/photo.jpg');
    });

    test('deve converter User sem campos opcionais para JSON', () {
      final user = User(
        id: '123',
        email: 'teste@email.com',
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'teste@email.com');
      expect(json['name'], null);
      expect(json['photoUrl'], null);
    });
  });
} 