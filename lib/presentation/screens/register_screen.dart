import 'package:flutter/material.dart';
import '../../core/utils/validation_helper.dart';
import '../widgets/loading_button.dart';
import '../../domain/services/authentication_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthenticationService authService;

  const RegisterScreen({Key? key, required this.authService}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }

    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }

    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await widget.authService.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );

      if (user == null) {
        setState(() {
          _errorMessage = 'Erro ao criar conta. Tente novamente.';
          _isLoading = false;
        });
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegue de volta para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(authService: widget.authService),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocorreu um erro durante o registro. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                Text(
                  'Crie sua conta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  'Preencha os dados abaixo para se registrar',
                  style: Theme.of(context).textTheme.bodyLarge,
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

                // Campo de nome
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    hintText: 'Insira seu nome completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateName,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Campo de e-mail
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Insira seu e-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: ValidationHelper.validateEmail,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Campo de senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Crie uma senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: ValidationHelper.validatePassword,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Campo de confirmação de senha
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    hintText: 'Confirme sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                  enabled: !_isLoading,
                  onFieldSubmitted: (_) => _register(),
                ),
                const SizedBox(height: 32),

                // Botão de registro
                LoadingButton(
                  isLoading: _isLoading,
                  onPressed: _register,
                  label: 'Registrar',
                ),
                const SizedBox(height: 24),

                // Voltar para login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já tem uma conta?'),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
