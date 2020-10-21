import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_flutter/time_ago.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_item_screen.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var _loading = true;

  List _orders = [];

  @override
  void initState() {
    getOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: Center(
        child: _loading ? CircularProgressIndicator() : getOrderList(),
      ),
    );
  }

  getOrderList() {
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderItemScreen(_orders[index])));
            },
            title: Text("Order No: ${_orders[index]['id']}"),
            subtitle: Text(_orders[index]['status']),
            trailing:
                Text(TimeAgo.timeAgoSinceDate(_orders[index]['createdAt'])),
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text("${index + 1}"),
            ),
          ),
        );
      },
    );
  }

  getOrders() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");

    var headers = {"authorization": "Bearer $token"};

    var options = Options(headers: headers);

    var res =
        await Dio().get("http://45.32.157.58/api/orders", options: options);

    setState(() {
      _orders = res.data['data'];

      _loading = false;
    });
  }
}
