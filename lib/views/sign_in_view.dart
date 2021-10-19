import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/backend_requests/sign_in_controller_requestor.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/tmp/session_data.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/views/home_view.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

/// Entrypoint example for sign in via Email/Password.
class SignInView extends StatefulWidget {
  /// The page title.
  final String title = 'Sign_in';

  @override
  State<StatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText:
                            'Leave blank if you haven\'t set your password'),
                    validator: (String? value) {
                      return null;
                    },
                    obscureText: true,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: SignInButtonBuilder(
                      icon: Icons.person_add,
                      backgroundColor: Colors.blueGrey,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _signin(
                              email: _emailController.text,
                              password: _passwordController.text);
                        }
                      },
                      text: 'signin',
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for sign in logic
  Future<void> _signin(
      {required String email, required String password}) async {
    final signinRequestor =
        new SignInControllerRequestor(email: email, password: password);
    final loginStatus = await signinRequestor.attemptLogin();

    switch (loginStatus.statusCode) {
      case HttpStatus.ok:
        {
          SessionData.currentUser =
              User.fromJson(json: jsonDecode(loginStatus.body));
          String urlstring = 'http://' + localhost + ':8888/currentBookings';
          final url = Uri.parse(urlstring);
          Response response = await post(url,
              headers: {'content-type': 'application/json'},
              body: jsonEncode(SessionData.currentUser.toJson()));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeView(response);
          }));
        }
        break;
      case HttpStatus.unauthorized:
        {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Sign in failed'),
              content: Text(
                  'If you\'ve just registered, you can set it by leaving the password field blank.'),
            ),
          );
        }
        break;
      case HttpStatus.badRequest:
        {
          SessionData.currentUser =
              User.fromJson(json: jsonDecode(loginStatus.body));
          Navigator.push<MaterialPageRoute>(context,
              MaterialPageRoute(builder: (context) {
            return CreatePasswordView();
          }));
        }
        break;
    }
  }
}
