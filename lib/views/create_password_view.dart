import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/backend_requests/create_password_requestor.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';

class CreatePasswordView extends StatefulWidget {
  CreatePasswordView();

  final String title = 'Create password';

  @override
  _CreatePasswordViewState createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends State<CreatePasswordView> {
  final TextEditingController _passwordController = new TextEditingController();
  _CreatePasswordViewState();

  @override
  Widget build(BuildContext context) {
    final createPassRequestor = new CreatePasswordController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your new password'),
                    validator: (String? value) {
                      if (value!.length < 7) {
                        return 'Please enter a stronger password';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await createPassRequestor
                              .setPass(_passwordController.text.toString());
                          Navigator.push<MaterialPageRoute>(context,
                              MaterialPageRoute(builder: (context) {
                            return SignInView();
                          }));
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
