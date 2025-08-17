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

    return auth.isAuth ? ProductsOverviewPage() : AuthenticationPage();
  }
}
