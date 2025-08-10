import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/product_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final snackMessage = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed('/product_form', arguments: product);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                final provider = Provider.of<ProductList>(
                  context,
                  listen: false,
                );

                showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Excluir produto?'),
                    content: Text('A remoção do produto é irreversível!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Não'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Sim'),
                      ),
                    ],
                  ),
                ).then(
                  (value) => {
                    if (value ?? false)
                      provider.delete(product).catchError((error) {
                        snackMessage.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Não foi possível excluir este produto.',
                            ),
                          ),
                        );
                      }),
                  },
                );
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
