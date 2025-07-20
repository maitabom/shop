import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  const OrderWidget({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          NumberFormat.currency(
            locale: 'pt_BR',
            symbol: 'R\$',
          ).format(order.total),
        ),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.date)),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
      ),
    );
  }
}
