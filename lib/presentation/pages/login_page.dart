import 'package:flutter/material.dart';
import 'package:projeto_flutter/data/repository/user_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final viewModel = Provider.of<UserViewmodel>(context, listen: false);
    final username = usernameController.text;
    final senha = senhaController.text;

    if (username.isEmpty || senha.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos')),
        );
      }
      return;
    }

    try {
      bool sucesso = await viewModel.login(username, senha);
      if (mounted && sucesso) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao fazer login. Verifique suas credenciais.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $e')));
      }
    }
  }

  void cancelar() {
    Navigator.popAndPushNamed(context, '/');
  }

  void irParaRegistro() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone ou Logo
                Icon(Icons.lock_person, size: 100, color: Colors.deepPurple),
                const SizedBox(height: 20),

                // Texto de Boas-Vindas
                const Text(
                  'Bem-vindo de volta!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Faça login para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
                const SizedBox(height: 30),

                // Campo de Usuário
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de Senha
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Botão de Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Botão de Cancelar
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: cancelar,
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Link para Registro
                TextButton(
                  onPressed: irParaRegistro,
                  child: const Text(
                    'Não tem uma conta? Registre-se',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Exemplo de UserViewmodel (substitua pelo seu próprio ViewModel)
class UserViewmodel {
  UserViewmodel(UserRepository userRepository);

  Future<bool> login(String username, String senha) async {
    // Simulação de uma chamada de API ou lógica de autenticação
    await Future.delayed(const Duration(seconds: 2));
    return username == "admin" && senha == "123456"; // Exemplo simples
  }
}
