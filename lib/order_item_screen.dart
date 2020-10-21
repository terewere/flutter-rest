import 'package:flutter/material.dart';

class OrderItemScreen extends StatefulWidget {
  var _order;
  OrderItemScreen(this._order);

  @override
  _OrderItemScreenState createState() => _OrderItemScreenState();
}

class _OrderItemScreenState extends State<OrderItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Column(
        children: [Text(widget._order['user']['name'])],
      ),
    );
  }
}
