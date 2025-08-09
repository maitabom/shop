import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  final _baseUrl = 'https://shop-valentim-default-rtdb.firebaseio.com/';

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.favorite).toList();

  int get itemsCount => _items.length;

  Future<void> add(Product product) {
    final future = http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'favorite': product.favorite,
      }),
    );

    return future.then<void>((response) {
      final id = jsonDecode(response.body)['name'];

      _items.add(
        Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          favorite: product.favorite,
        ),
      );
      notifyListeners();

      return Future.value();
    });
  }

  Future<void> update(Product product) {
    var index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  void delete(Product product) {
    var index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  Future<void> save(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: double.tryParse(data['price'] as String) ?? 0.0,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return update(product);
    } else {
      return add(product);
    }
  }
}
