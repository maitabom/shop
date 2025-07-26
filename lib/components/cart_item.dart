import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/provider/cart.dart';

class CartItemComponent extends StatelessWidget {
  final CartItem cartItem;
  const CartItemComponent({required this.cartItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(cartItem.productID);
      },
      confirmDismiss: (_) {
        return Future.value(
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirma exclusão?'),
              content: Text('A exclusão deste item é irreversível.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Sim'),
                ),
              ],
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text(
                  NumberFormat.currency(
                    locale: 'pt_BR',
                    symbol: 'R\$',
                  ).format(cartItem.price),
                ),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text(
            NumberFormat.currency(
              locale: 'pt_BR',
              symbol: 'R\$',
            ).format(cartItem.price * cartItem.quantity),
          ),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
