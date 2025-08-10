import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/config/constants.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final List<Order> _items = [];
  final _baseUrl = Constants.baseUrl;

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();

    final response = await http.get(Uri.parse('$_baseUrl/orders.json'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((key, item) {
      _items.add(
        Order(
          id: key,
          date: DateTime.parse(item['date']),
          total: item['total'],
          products: (item['products'] as List<dynamic>).map((cartItem) {
            return CartItem(
              id: cartItem['id'],
              productID: cartItem['productId'],
              name: cartItem['name'],
              quantity: cartItem['quantity'],
              price: cartItem['price'],
            );
          }).toList(),
        ),
      );
    });

    notifyListeners();
  }

  Future<void> add(Cart cart) {
    final currentDate = DateTime.now();

    final future = http.post(
      Uri.parse('$_baseUrl/orders.json'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': currentDate.toIso8601String(),
        'products': cart.items.values
            .map(
              (item) => {
                'id': item.id,
                'productId': item.productID,
                'name': item.name,
                'quantity': item.quantity,
                'price': item.price,
              },
            )
            .toList(),
      }),
    );

    return future.then((response) {
      final id = jsonDecode(response.body)['name'];

      _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: currentDate,
        ),
      );

      notifyListeners();

      return Future.value();
    });
  }
}
