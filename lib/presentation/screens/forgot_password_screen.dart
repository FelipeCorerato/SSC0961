import 'package:flutter/material.dart';
import '../../core/utils/validation_helper.dart';
import '../widgets/loading_button.dart';
import '../../domain/services/authentication_service.dart';
import '../../core/services/firebase_authentication_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthenticationService? authService;

  const ForgotPasswordScreen({Key? key, this.authService}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Se o authService for FirebaseAuthenticationService, usa o método específico
      if (widget.authService != null &&
          widget.authService is FirebaseAuthenticationService) {
        final firebaseService =
            widget.authService as FirebaseAuthenticationService;
        await firebaseService.sendPasswordResetEmail(
          _emailController.text.trim(),
        );
      } else {
        // Fallback para simulação (mock service)
        await Future.delayed(const Duration(seconds: 2));
      }

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
        const SizedBox(height: 24),
        Text(
          'E-mail enviado!',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Um link para redefinir sua senha foi enviado para:',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Voltar para o Login'),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título
        Text(
          'Esqueceu sua senha?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Subtítulo
        const Text(
          'Insira seu e-mail abaixo para receber um link de redefinição de senha.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Mensagem de erro (se houver)
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // Campo de e-mail
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            hintText: 'Insira seu e-mail',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: ValidationHelper.validateEmail,
          enabled: !_isLoading,
          onFieldSubmitted: (_) => _sendResetEmail(),
        ),
        const SizedBox(height: 32),

        // Botão de envio
        LoadingButton(
          isLoading: _isLoading,
          onPressed: _sendResetEmail,
          label: 'Enviar Link',
        ),
        const SizedBox(height: 24),

        // Voltar para login
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text('Voltar para o Login'),
        ),
      ],
    );
  }
}
