import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawler.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/product_list.dart';

enum FilterOptions { favorite, all }

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<ProductList>(context, listen: false).loadProducts().then((
      value,
    ) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Somente Favoritos'),
              ),
              PopupMenuItem(value: FilterOptions.all, child: Text('Todos')),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _showFavoriteOnly = (selectedValue == FilterOptions.favorite);
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => AppBadge(
              value: cart.itemsCount.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawler(),
    );
  }
}
