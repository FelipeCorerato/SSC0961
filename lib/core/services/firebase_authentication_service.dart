import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/models/user.dart' as domain;
import '../../domain/services/authentication_service.dart';

class FirebaseAuthenticationService implements AuthenticationService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  @override
  Future<domain.User?> login(String email, String password) async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return _firebaseUserToDomainUser(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Lança exceções específicas para diferentes tipos de erro
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Usuário não encontrado');
        case 'wrong-password':
          throw Exception('Senha incorreta');
        case 'user-disabled':
          throw Exception('Usuário desabilitado');
        case 'too-many-requests':
          throw Exception(
            'Muitas tentativas de login. Tente novamente mais tarde',
          );
        case 'invalid-email':
          throw Exception('Email inválido');
        case 'invalid-credential':
          throw Exception('Credenciais inválidas');
        default:
          throw Exception('Erro no login: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado no login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  @override
  Future<domain.User?> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Atualiza o perfil do usuário com o nome
      await userCredential.user?.updateDisplayName(name);

      // Recarrega o usuário para obter as informações atualizadas
      await userCredential.user?.reload();
      final firebase_auth.User? updatedUser = _firebaseAuth.currentUser;

      return _firebaseUserToDomainUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Trata erros específicos do registro
      switch (e.code) {
        case 'weak-password':
          throw Exception('A senha é muito fraca');
        case 'email-already-in-use':
          throw Exception('Este email já está sendo usado');
        case 'invalid-email':
          throw Exception('Email inválido');
        case 'operation-not-allowed':
          throw Exception('Operação não permitida');
        default:
          throw Exception('Erro no registro: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado no registro: $e');
    }
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    try {
      final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // Recarrega o usuário para garantir que as informações estão atualizadas
        await firebaseUser.reload();
        final firebase_auth.User? updatedUser = _firebaseAuth.currentUser;
        return _firebaseUserToDomainUser(updatedUser);
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao obter usuário atual: $e');
    }
  }

  /// Converte um usuário do Firebase para o modelo de domínio
  domain.User? _firebaseUserToDomainUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return domain.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Stream para escutar mudanças no estado de autenticação
  Stream<domain.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return _firebaseUserToDomainUser(firebaseUser);
    });
  }

  /// Verifica se o usuário está autenticado
  bool get isAuthenticated {
    return _firebaseAuth.currentUser != null;
  }

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Usuário não encontrado');
        case 'invalid-email':
          throw Exception('Email inválido');
        default:
          throw Exception('Erro ao enviar email de redefinição: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  /// Verifica se o email do usuário foi verificado
  bool get isEmailVerified {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  /// Envia email de verificação
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Erro ao enviar email de verificação: $e');
    }
  }

  /// Atualiza o perfil do usuário
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
      }
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  /// Deleta a conta do usuário
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw Exception(
            'É necessário fazer login novamente para deletar a conta',
          );
        default:
          throw Exception('Erro ao deletar conta: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado ao deletar conta: $e');
    }
  }
}
