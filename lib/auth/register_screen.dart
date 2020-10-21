import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_flutter/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _passConfirmationController = TextEditingController();
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _addressController = TextEditingController();
  var _cityController = TextEditingController();
  var _regionController = TextEditingController();
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
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Register',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Name is required";
                  }
                },
                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter Name"),
              ),
              SizedBox(
                height: 40,
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
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "Address is required";
//                  }
//                },
                controller: _addressController,
                decoration: InputDecoration(hintText: "Enter Address"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "City is required";
//                  }
//                },
                controller: _cityController,
                decoration: InputDecoration(hintText: "Enter City"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "Region is required";
//                  }
//                },
                controller: _regionController,
                decoration: InputDecoration(hintText: "Enter Region"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "Phone is required";
//                  }
//                },
                controller: _phoneController,
                decoration: InputDecoration(hintText: "Enter Phone"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "Password is required";
//                  }
//                },
//              obscureText: true,
                controller: _passController,
                decoration: InputDecoration(hintText: "Enter Password"),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password Confirmation is required";
                  }
                },
//              obscureText: true,
                controller: _passConfirmationController,
                decoration:
                    InputDecoration(hintText: "Enter Password Confirmation"),
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                onPressed: register,
                child: Text(loading ? "Loading" : "Sign Up"),
              ),
              Row(
                children: [
                  Text('Existing Customer?'),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text('Sign In'),
                  )
                ],
              ),
              ...errorBag
                  .map((e) => ListTile(
                        leading: Icon(
                          Icons.fiber_manual_record,
                          size: 10,
                          color: Colors.red,
                        ),
                        title: new Text(
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

  register() async {
    errorBag.clear();

    if (!formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    var email = _emailController.text;
    var password = _passController.text;
    var passwordConfirmation = _passConfirmationController.text;
    var name = _nameController.text;
    var address = _addressController.text;
    var city = _cityController.text;
    var region = _regionController.text;
    var phone = _phoneController.text;

    var options = Options(headers: {'accept': 'application/json'});

    var body = {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "name": name,
      "address": address,
      "city": city,
      "region": region,
      "phone": phone
    };

    try {
      var res = await Dio().post('http://45.32.157.58/api/register',
          data: body, options: options);
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
      } else {
        print("something went wrong");
      }
    }

    setState(() {
      loading = false;
    });
  }
}
