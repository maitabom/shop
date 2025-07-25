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
}
