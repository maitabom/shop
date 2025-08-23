import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/config/constants.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool favorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) {
    String url =
        '${Constants.baseDatabaseUrl}/user_favorite/$userId/$id.json?auth=$token';

    final future = http.put(
      Uri.parse(url),
      body: jsonEncode({'favorite': favorite}),
    );

    return future.then((response) {
      favorite = !favorite;
      notifyListeners();

      return Future.value();
    });
  }
}
