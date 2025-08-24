import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/authentication.dart';
import 'package:shop/pages/products_overview.dart';
import 'package:shop/provider/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.autologin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro no sistema.'));
        } else {
          return auth.isAuth ? ProductsOverviewPage() : AuthenticationPage();
        }
      },
    );
  }
}
