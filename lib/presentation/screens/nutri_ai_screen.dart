import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

class NutriAIScreen extends StatelessWidget {
  final User user;

  const NutriAIScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriAI'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text('NutriAI', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Aqui você receberá recomendações personalizadas sobre nutrição e alimentação saudável.',
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
