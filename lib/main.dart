import 'package:flutter/material.dart';
import 'package:rest_api_flutter/IteamLists.dart';
import 'package:rest_api_flutter/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Categories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List categories;
  List basket = [];

  addToBasket(item, quantity) {
    basket.add({"item": item, "quantity": quantity});
    print(basket);
  }

  @override
  void initState() {
    getLocalCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          GestureDetector(
            onTap: () async {
              var pref = await SharedPreferences.getInstance();
              pref.remove("token");
              var alert = AlertDialog(
                title: Text('Log out'),
                content: Text('Logout Successfully'),
              );
              showDialog(child: alert, context: context);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Log out',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
      body: Center(
          child: categories == null ? CircularProgressIndicator() : getGrid()),
    );
  }

  Widget getGrid() {
    return GridView.builder(
        itemCount: categories.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ItemLists(categories[index]['id'], basket, addToBasket);
              }));
            },
            child: GridTile(
              child: Column(
                children: [
                  Image.asset(
                    categories[index]['imgUrl'],
                    fit: BoxFit.contain,
                    width: 150,
                    height: 150,
                  ),
                  Text(categories[index]['label'])
                ],
              ),
            ),
          );
        });
  }

  // void getCategories() async {
  //   var url = 'http://192.168.10.10/api/categories';
  //   var response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     var categoryData = json.decode(response.body);
  //
  //     categories = categoryData['data'];
  //     setState(() {});
  //   }
  //
  // }

  getLocalCategory() {
    categories = categoryData;
  }
}
