import 'package:flutter/material.dart';
import '../../core/utils/validation_helper.dart';
import '../widgets/loading_button.dart';
import '../../domain/services/authentication_service.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthenticationService authService;

  const LoginScreen({Key? key, required this.authService}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await widget.authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (user == null) {
        setState(() {
          _errorMessage = 'E-mail ou senha inválidos.';
          _isLoading = false;
        });
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainScreen(user: user, authService: widget.authService),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocorreu um erro durante o login. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ou imagem de destaque
                Icon(
                  Icons.account_circle_outlined,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Bem-vindo',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  'Faça login para continuar',
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
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Insira sua senha',
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
                  onFieldSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 8),

                // "Esqueceu a senha"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            // Navegar para tela de recuperação de senha
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(
                                  authService: widget.authService,
                                ),
                              ),
                            );
                          },
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão de login
                LoadingButton(
                  isLoading: _isLoading,
                  onPressed: _login,
                  label: 'Entrar',
                ),
                const SizedBox(height: 24),

                // Opção de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              // Navegar para tela de registro
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(
                                    authService: widget.authService,
                                  ),
                                ),
                              );
                            },
                      child: const Text('Registrar-se'),
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
