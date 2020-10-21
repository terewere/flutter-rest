import 'package:flutter/material.dart';

import 'basket.dart';

class ItemDetails extends StatefulWidget {
  ItemDetails(this.item, this.basket, this.addToBasket);
  final item;
  List basket;
  Function addToBasket;

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  var quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details : ' + widget.item['label']),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(getTotalQuantity2().toString()),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Basket(widget.basket);
              }));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(widget.item['imgUrl']),
          Text(
            'GHC' + widget.item['price'].toString(),
            style: TextStyle(fontSize: 35),
          ),
          Text(widget.item['description']),
          Row(
            children: [
              RaisedButton(
                child: Text(
                  '-',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  setState(() {
                    if (quantity == 1) {
                      return;
                    } else {
                      quantity--;
                    }
                  });
                },
              ),
              Text(
                quantity.toString(),
                style: TextStyle(fontSize: 25),
              ),
              RaisedButton(
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
              Text(
                "GHC ${widget.item['price'] * quantity}",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          RaisedButton(
            child: Text('Add to Cart'),
            onPressed: () {
              setState(() {
                widget.addToBasket(widget.item, quantity);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {},
      ),
    );
  }

  getTotalQuantity() {
    if (widget.basket.length == 0) return 0;
    return widget.basket
        .map((item) => item['quantity'])
        .reduce((value, element) => value + element);
  }

  getTotalQuantity2() {
    var total = 0;
    for (Map item in widget.basket) {
      total += item['quantity'];
    }
    return total;
  }
}
