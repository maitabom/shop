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

  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        '${Constants.baseDatabaseUrl}/user_favorite/$userId/$id.json?auth=$token';

    final newStatus = !favorite;

    // Atualiza otimisticamente na UI
    favorite = newStatus;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(newStatus),
      );

      if (response.statusCode >= 400) {
        // rollback em caso de erro no servidor
        favorite = !newStatus;
        notifyListeners();
        throw Exception('Falha ao atualizar favorito no servidor.');
      }
    } catch (error) {
      // rollback em caso de erro de rede/exceção
      favorite = !newStatus;
      notifyListeners();
      rethrow;
    }
  }
}
