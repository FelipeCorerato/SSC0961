import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../../domain/services/authentication_service.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final AuthenticationService authService;

  const HomeScreen({Key? key, required this.user, required this.authService})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showcase'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Bem-vindo${user.name != null ? ', ${user.name}' : ''}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Login efetuado com sucesso',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
