import 'package:flutter/material.dart';

import 'order_history.dart';

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thank You',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              'Your order has been received',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            FlatButton(
              onPressed: () {
                print('checkout order status...');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => OrderHistory()),
                    (route) => route.isFirst);
              },
              color: Colors.red,
              child: Text(
                'view order history',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
