import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.favorite).toList();

  int get itemsCount => _items.length;

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void update(Product product) {
    var index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void save(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: double.tryParse(data['price'] as String) ?? 0.0,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      update(product);
    } else {
      add(product);
    }
  }
}
