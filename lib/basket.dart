import 'package:flutter/material.dart';
import 'package:rest_api_flutter/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checkout.dart';

class Basket extends StatefulWidget {
  List basket;
  Basket(this.basket);
  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  void initState() {
    getTotalAmount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: getBasketList(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var pref = await SharedPreferences.getInstance();
            var token = pref.get("token");
            if (token == null) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginScreen()));
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Checkout(widget.basket)));
            }
          },
          label: Text('Proceed to Checkout')),
    );
  }

  getBasketList() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: ListView.builder(
              itemCount: widget.basket.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading:
                        Image.asset(widget.basket[index]['item']['imgUrl']),
                    title: Text(getDescription(index)),
                    trailing: Text(getAmount(index)),
                  ),
                );
              }),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "GHC ${getTotalAmount2().toString()}",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  getAmount(index) {
    var price = widget.basket[index]['item']['price'];
    var quantity = widget.basket[index]['quantity'];
    return " GHC ${quantity * price}";
  }

  getTotalAmount() {
    var sum = widget.basket
        .map((element) => element['quantity'] * element['item']['price'])
        .reduce((value, element) => value + element);
    return sum;
  }

  getTotalAmount2() {
    var total = 0;
    for (Map item in widget.basket) {
      total += item['quantity'] * item['item']['price'];
    }
    return total;
  }

  getDescription(index) {
    var quantity = widget.basket[index]['quantity'];
    var name = widget.basket[index]['item']['label'];
    return "${quantity} X ${name} @ ";
  }
}
