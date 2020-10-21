import 'package:flutter/material.dart';
import 'package:rest_api_flutter/categories.dart';
import 'package:rest_api_flutter/item_details.dart';

import 'itemsData.dart';

class ItemLists extends StatefulWidget {
  ItemLists(this.categoryId, this.basket, this.addToBasket);
  final int categoryId;
  List basket;
  Function addToBasket;

  @override
  _ItemListsState createState() => _ItemListsState();
}

class _ItemListsState extends State<ItemLists> {
  List items;

  void initState() {
    getItemLists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTitle())),
      body: Center(
          child: items == null ? CircularProgressIndicator() : getGrid()),
    );
  }

  Widget getGrid() {
    return GridView.builder(
        itemCount: items.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => ItemDetails(
                        items[index], widget.basket, widget.addToBasket)),
              );
            },
            child: GridTile(
              child: Column(
                children: [
                  Image.asset(
                    items[index]['imgUrl'],
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                  Text(items[index]['label']),
                  Text("GHS" + items[index]['price'].toString()),
                ],
              ),
            ),
          );
        });
  }

  getTitle() {
    return categoryData
        .where((item) => item['id'] == widget.categoryId)
        .toList()[0]['label'];
  }

  getItemLists() {
    items = itemsData
        .where((item) => item['categoryId'] == widget.categoryId)
        .toList();
  }
}
