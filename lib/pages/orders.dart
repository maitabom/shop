import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawler.dart';
import 'package:shop/components/order.dart';
import 'package:shop/provider/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Meus Pedidos')),
      drawer: AppDrawler(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (context, index) =>
                  OrderWidget(order: orders.items[index]),
            ),
    );
  }
}
