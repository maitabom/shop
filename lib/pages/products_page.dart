import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawler.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/provider/product_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Produtos')),
      drawer: AppDrawler(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (context, index) => Column(
            children: [
              ProductItem(product: products.items[index]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
