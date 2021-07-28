import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:smart_parking_solutions/backend_requests/sign_in_controller_requestor.dart';

/// Entrypoint example for sign in via Email/Password.
class SigninPage extends StatefulWidget {
  /// The page title.
  final String title = 'Sign_in';

  @override
  State<StatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool _success;
  String _userEmail = '';

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
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
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
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success
                        ? ''
                        : (_success
                            ? 'Successfully signed in $_userEmail'
                            : 'sign in failed')),
                  )
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
      case HttpStatus.accepted:
        {
          _success = true;
        }
        break;
      case HttpStatus.unauthorized:
        {
          _success = false;
        }
        break;
      case HttpStatus.badRequest:
        {
          ///TODO Prompt for new password
        }
        break;
      default:
    }
  }
}
