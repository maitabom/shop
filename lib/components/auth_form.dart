import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _formData = {'email': '', 'password': ''};

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignUp() => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    if (_isLogin()) {
    } else {}

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
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
              if (_isSignUp())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirme a senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (password) {
                          final pivot = password ?? '';

                          if (pivot != _passwordController.text) {
                            return 'Senhas informadas não conferem';
                          }

                          return null;
                        },
                ),
              SizedBox(height: 40),
              if (_isLoading)
                CircularProgressIndicator()
              else
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
                  child: Text(_isLogin() ? 'ENTRAR' : 'REGISTRAR'),
                ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'Deseja registrar?' : 'Já possui a conta?',
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
