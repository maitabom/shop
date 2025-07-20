import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawler.dart';
import 'package:shop/components/order.dart';
import 'package:shop/provider/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Meus Pedidos')),
      drawer: AppDrawler(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (context, index) =>
            OrderWidget(order: orders.items[index]),
      ),
    );
  }
}
