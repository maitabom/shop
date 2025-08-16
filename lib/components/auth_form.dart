import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();

  final AuthMode _authMode = AuthMode.login;
  final Map<String, String> _formData = {'email': '', 'password': ''};

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 320,
        width: deviceSize.width * 0.75,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _formData['email'] = email ?? '',
                validator: (email) {
                  final pivot = email ?? '';

                  if (pivot.trim().isEmpty || !pivot.contains('@')) {
                    return 'Informe o e-mail válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _formData['password'] = password ?? '',
                validator: (password) {
                  final pivot = password ?? '';

                  if (pivot.isEmpty || pivot.length < 5) {
                    return 'Informe uma senha válida';
                  }

                  return null;
                },
              ),
              if (_authMode == AuthMode.signUp)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirme a senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _authMode == AuthMode.login
                      ? null
                      : (password) {
                          final pivot = password ?? '';

                          if (pivot != _passwordController.text) {
                            return 'Senhas informadas não conferem';
                          }

                          return null;
                        },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthMode { signUp, login }
