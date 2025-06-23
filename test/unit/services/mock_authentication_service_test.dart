import 'package:flutter_test/flutter_test.dart';
import 'package:nutripro_flutter/core/services/mock_authentication_service.dart';
import 'package:nutripro_flutter/domain/models/user.dart';

void main() {
  group('MockAuthenticationService Tests', () {
    late MockAuthenticationService authService;

    setUp(() {
      authService = MockAuthenticationService();
    });

    group('login', () {
      test('deve fazer login com credenciais válidas', () async {
        final user = await authService.login('teste@email.com', 'teste123');

        expect(user, isNotNull);
        expect(user!.id, '1');
        expect(user.email, 'teste@email.com');
        expect(user.name, 'teste123@email.com');
      });

      test('deve falhar login com senha incorreta', () async {
        final user = await authService.login('teste@email.com', 'senhaerrada');

        expect(user, isNull);
      });

      test('deve falhar login com senha vazia', () async {
        final user = await authService.login('teste@email.com', '');

        expect(user, isNull);
      });
    });

    group('register', () {
      test('deve registrar um novo usuário', () async {
        final user = await authService.register(
          'novo@email.com',
          'senha123',
          'João Silva',
        );

        expect(user, isNotNull);
        expect(user!.id, '1');
        expect(user.email, 'novo@email.com');
        expect(user.name, 'João Silva');
      });

      test('deve registrar usuário sem nome', () async {
        final user = await authService.register(
          'novo@email.com',
          'senha123',
          '',
        );

        expect(user, isNotNull);
        expect(user!.email, 'novo@email.com');
        expect(user.name, '');
      });
    });

    group('getCurrentUser', () {
      test('deve retornar null quando não há usuário logado', () async {
        final user = await authService.getCurrentUser();

        expect(user, isNull);
      });

      test('deve retornar usuário após login', () async {
        await authService.login('teste@email.com', 'teste123');
        final user = await authService.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.email, 'teste@email.com');
      });

      test('deve retornar usuário após registro', () async {
        await authService.register('novo@email.com', 'senha123', 'João');
        final user = await authService.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.email, 'novo@email.com');
        expect(user.name, 'João');
      });
    });

    group('logout', () {
      test('deve fazer logout e limpar usuário atual', () async {
        // Primeiro faz login
        await authService.login('teste@email.com', 'teste123');
        var user = await authService.getCurrentUser();
        expect(user, isNotNull);

        // Faz logout
        await authService.logout();
        user = await authService.getCurrentUser();
        expect(user, isNull);
      });

      test('deve fazer logout sem usuário logado', () async {
        // Tenta fazer logout sem estar logado
        await authService.logout();
        final user = await authService.getCurrentUser();
        expect(user, isNull);
      });
    });

    group('fluxo completo', () {
      test('deve manter estado do usuário durante operações', () async {
        // Registra um usuário
        final registeredUser = await authService.register(
          'usuario@email.com',
          'senha123',
          'Usuário Teste',
        );
        expect(registeredUser, isNotNull);

        // Verifica se o usuário está logado
        var currentUser = await authService.getCurrentUser();
        expect(currentUser, isNotNull);
        expect(currentUser!.email, 'usuario@email.com');

        // Faz logout
        await authService.logout();
        currentUser = await authService.getCurrentUser();
        expect(currentUser, isNull);

        // Faz login novamente
        final loggedUser = await authService.login(
          'usuario@email.com',
          'teste123',
        );
        expect(loggedUser, isNotNull);

        // Verifica se o usuário está logado novamente
        currentUser = await authService.getCurrentUser();
        expect(currentUser, isNotNull);
        expect(currentUser!.email, 'usuario@email.com');
      });
    });
  });
}
