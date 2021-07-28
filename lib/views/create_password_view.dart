import 'package:flutter/material.dart';

class CreatePasswordView extends StatefulWidget {
  final email;
  CreatePasswordView(this.email);
  @override
  _CreatePasswordViewState createState() => _CreatePasswordViewState(email);
}

class _CreatePasswordViewState extends State<CreatePasswordView> {
  final TextEditingController _passwordController = new TextEditingController();
  final email;
  _CreatePasswordViewState(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text('Enter password'),
            TextField(
              controller: _passwordController,
            )
          ],
        ),
        ElevatedButton(
            onPressed: () => {
                // _passwordController.text
                // email
                ///TODO Set password on existing user
                },
            child: Text('Submit'))
      ])),
    );
  }
}
