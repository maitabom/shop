import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/product_list.dart';

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> listProducts = provider.items;

    return Scaffold(
      appBar: AppBar(title: Text('Minha Loja')),
      body: GridView.builder(
        itemCount: listProducts.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ProductItem(product: listProducts[index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
