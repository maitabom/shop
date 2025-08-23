import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config/constants.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;
  final _baseUrl = Constants.baseDatabaseUrl;

  ProductList([this._token = '', this._userId = '', this._items = const []]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.favorite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();

    final productResponse = await http.get(
      Uri.parse('$_baseUrl/products.json?auth=$_token'),
    );

    if (productResponse.body == 'null') return;

    final favoriteResponse = await http.get(
      Uri.parse('$_baseUrl/user_favorite/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favoriteData = favoriteResponse.body == 'null'
        ? {}
        : jsonDecode(favoriteResponse.body);

    Map<String, dynamic> data = jsonDecode(productResponse.body);

    data.forEach((key, item) {
      final isFavorite = favoriteData[key] ?? false;

      _items.add(
        Product(
          id: key,
          name: item['name'],
          description: item['description'],
          price: item['price'],
          imageUrl: item['imageUrl'],
          favorite: isFavorite,
        ),
      );
    });

    notifyListeners();
  }

  Future<void> add(Product product) {
    final future = http.post(
      Uri.parse('$_baseUrl/products.json?auth=$_token'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
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
        ),
      );
      notifyListeners();

      return Future.value();
    });
  }

  Future<void> update(Product product) {
    var index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final future = http.patch(
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      return future.then<void>((response) {
        _items[index] = product;
        notifyListeners();

        return Future.value();
      });
    }

    return Future.value();
  }

  Future<void> delete(Product product) {
    var index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final future = http.delete(
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'),
      );

      return future.then<void>((response) {
        _items.removeWhere((p) => p.id == product.id);
        notifyListeners();

        return Future.value();
      });
    }

    return Future.value();
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
