import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../../domain/services/authentication_service.dart';
import '../../core/utils/validation_helper.dart';

class MockAuthenticationService implements AuthenticationService {
  User? _currentUser;

  @override
  Future<User?> login(String email, String password) async {
    // Simula uma chamada de API com um atraso
    await Future.delayed(const Duration(seconds: 1));

    if (password == "teste123") {
      _currentUser = User(id: '1', email: email, name: 'teste123@email.com');
      return _currentUser;
    }

    // Retorna null para representar falha no login
    return null;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    return;
  }

  @override
  Future<User?> register(String email, String password, String name) async {
    // Simula uma chamada de API com um atraso
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(id: '1', email: email, name: name);

    return _currentUser;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
