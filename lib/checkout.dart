import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_flutter/thank_you.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  final List basket;
  Checkout(this.basket);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var loading = true;
  var _delivery = "atYourDoorstep";
  var shippingFee = 50;
  var subTotal = 0;
  var grandTotal = 0;
  var _payment = "cashOnDeliver";
  var user;

  @override
  void initState() {
    getUserInfo();
    subTotal = getSubtotal2();
    grandTotal = subTotal + shippingFee;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.all(0),
        width: 160,
        child: RaisedButton(
          color: Colors.amber,
          onPressed: submitOrder,
          child: Text('Submit your order'),
        ),
      ),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Text(
                    "Address Detail",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${user['name']}"),
                          Text("${user['address']}"),
                          Text("${user['city']}"),
                          Text("${user['region']}"),
                          Text("${user['email']}"),
                          Text("${user['phone']}"),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Select a Delivery",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Radio(
                              onChanged: (value) {
                                setState(() {
                                  _delivery = value;
                                  shippingFee = 50;
                                  subTotal = getSubtotal2();
                                  grandTotal = subTotal + shippingFee;
                                });
                              },
                              groupValue: _delivery,
                              value: "atYourDoorstep",
                            ),
                            title: Text('At your doorstep'),
                            subtitle: Text('shipping fee: GHC50'),
                          ),
                          ListTile(
                            leading: Radio(
                              onChanged: (value) {
                                setState(() {
                                  _delivery = value;
                                  shippingFee = 0;
                                  subTotal = getSubtotal2();
                                  grandTotal = subTotal + shippingFee;
                                });
                              },
                              groupValue: _delivery,
                              value: "pickUpAtOurOffice",
                            ),
                            title: Text('Pick up at our office'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Select a payment Method",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Radio(
                              onChanged: (value) {
                                setState(() {
                                  _payment = value;
                                });
                              },
                              groupValue: _payment,
                              value: "cashOnDeliver",
                            ),
                            title: Text('Cash on delivery'),
                          ),
                          ListTile(
                            leading: Radio(
                              onChanged: (value) {
                                setState(() {
                                  _payment = value;
                                });
                              },
                              groupValue: _payment,
                              value: "mobileMoney",
                            ),
                            title: Text('Mobile Money'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Subtotal:GHC ${subTotal}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Shipping Fees: ${shippingFee}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    "Total Fees:GHC ${grandTotal}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  getSubtotal2() {
    return widget.basket
        .map((item) => item['quantity'] * item['item']['price'])
        .reduce((value, element) => value + element);
  }

  getSubtotal() {
    int total = 0;
    if (widget.basket.length > 0) {
      for (Map item in widget.basket) {
        total += item['quantity'] * item['item']['price'];
      }
    }
    return total;
  }

  getUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");

    var headers = {
      "authorization": "Bearer $token",
      "accept": "application/json"
    };

    var options = Options(headers: headers);

    var res = await Dio().get("http://45.32.157.58/api/user", options: options);

    if (res.statusCode == 200) {
      try {
        setState(() {
          user = res.data;
          loading = false;
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  submitOrder() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");

    var headers = {
      "authorization": "Bearer $token",
      "accept": "application/json"
    };

    var body = {
      "basket": widget.basket,
      "shipping_fee": shippingFee,
      "sub_total": subTotal,
      "grand_total": grandTotal,
      "payment_method": _payment,
      "delivery_method": _delivery,
    };

    var options = Options(headers: headers);

    var res = await Dio()
        .post("http://45.32.157.58/api/checkout", options: options, data: body);

    if (res.statusCode == 200) {
      widget.basket.clear();
      Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => ThankYouScreen()),
              (route) => route.isFirst)
          .then((value) => widget.basket.clear());
    }
  }
}
