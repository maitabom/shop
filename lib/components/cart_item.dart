import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';

class CartItemComponent extends StatelessWidget {
  final CartItem cartItem;
  const CartItemComponent({required this.cartItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(cartItem.name);
  }
}
