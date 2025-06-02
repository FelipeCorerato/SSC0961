import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../../domain/services/authentication_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  final AuthenticationService authService;

  const ProfileScreen({Key? key, required this.user, required this.authService})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();

              // Remova todas as rotas anteriores e navegue para a tela de login
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(authService: authService),
                  ),
                  (route) => false,
                );
              }
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user.name ?? 'Usuário',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildProfileMenuItem(
              context,
              Icons.person_outline,
              'Editar perfil',
              () {
                // Implementação futura
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
            ),
            _buildProfileMenuItem(
              context,
              Icons.notifications_outlined,
              'Notificações',
              () {
                // Implementação futura
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
            ),
            _buildProfileMenuItem(
              context,
              Icons.settings_outlined,
              'Configurações',
              () {
                // Implementação futura
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
            ),
            _buildProfileMenuItem(
              context,
              Icons.help_outline,
              'Ajuda e Suporte',
              () {
                // Implementação futura
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
      ),
    );
  }
}
