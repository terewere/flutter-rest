import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_flutter/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var loading = false;
  var formKey = GlobalKey<FormState>();

  List errorBag = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Email is required";
                  }
                },
                controller: _emailController,
                decoration: InputDecoration(hintText: "Enter Email"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password is required";
                  }
                },
//              obscureText: true,
                controller: _passController,
                decoration: InputDecoration(hintText: "Enter Password"),
              ),
              RaisedButton(
                onPressed: login,
                child: Text(loading ? "Loading" : "Sign in"),
              ),
              Row(
                children: [
                  Text('New Customer?'),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    child: Text('Sign Up'),
                  )
                ],
              ),
              ...errorBag
                  .map((e) => ListTile(
                        leading: Icon(
                          Icons.fiber_manual_record,
                          color: Colors.red,
                          size: 10,
                        ),
                        title: Text(
                          e,
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    errorBag.clear();

    if (!formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    var email = _emailController.text;
    var password = _passController.text;

    var options = Options(headers: {'accept': 'application/json'});

    var body = {"email": email, "password": password};

    try {
      var res = await Dio()
          .post('http://45.32.157.58/api/login', data: body, options: options);
      var pref = await SharedPreferences.getInstance();

      if (res.statusCode == 200) {
        pref.setString("token", res.data['access_token']);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response == null) {
          setState(() {
            errorBag.add(e.message);
            loading = false;
          });
          return;
        }

        Map errors = e.response.data['errors'];

        if (errors == null) {
          setState(() {
            errorBag.add("Error: Invalid email or password");
            loading = false;
          });

          return;
        }

        if (errors.containsKey("email")) {
          for (String e in errors['email']) {
            errorBag.add(e);
            print(e);
          }
        }
        if (errors.containsKey("password")) {
          for (String e in errors['password']) {
            print(e);
            errorBag.add(e);
          }
        }
      }
    }

    setState(() {
      loading = false;
    });
  }
}
