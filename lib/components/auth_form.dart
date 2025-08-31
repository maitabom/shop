import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/errors/auth_exception.dart';
import 'package:shop/provider/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'email': '', 'password': ''};

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;

  bool _isLogin() => _authMode == AuthMode.login;
  //bool _isSignUp() => _authMode == AuthMode.signUp;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _heightAnimation = Tween(
      begin: Size(double.infinity, 320),
      end: Size(double.infinity, 400),
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    final auth = Provider.of<Auth>(context, listen: false);

    _formKey.currentState?.save();

    try {
      if (_isLogin()) {
        await auth.login(
          _formData['email'] as String,
          _formData['password'] as String,
        );
      } else {
        await auth.signUp(
          _formData['email'] as String,
          _formData['password'] as String,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado.');
    }

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
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (context, child) => Container(
          padding: const EdgeInsets.all(16),
          height: _heightAnimation?.value.height ?? (_isLogin() ? 320 : 400),
          width: deviceSize.width * 0.75,
          child: child,
        ),
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
              AnimatedContainer(
                duration: Duration(microseconds: 400),
                curve: Curves.linear,
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirme a senha',
                      ),
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
                  ),
                ),
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
