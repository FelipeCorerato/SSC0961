import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

class DiaryScreen extends StatelessWidget {
  final User user;

  const DiaryScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu diário'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Meu diário',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Acompanhe seus registros diários de alimentação e atividades físicas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
