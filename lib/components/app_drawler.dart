import 'package:flutter/material.dart';

class AppDrawler extends StatelessWidget {
  const AppDrawler({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('Bem-vindo!'), automaticallyImplyLeading: false),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/orders');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_calendar_rounded),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/products');
            },
          ),
        ],
      ),
    );
  }
}
