import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;

  final void Function(String email, String password, String userName,
      bool isLogin, BuildContext ctx) submitForm;

  AuthForm(this.submitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _userName = '';
  var _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    // Close the keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(_email, _password, _userName, _isLogin, context);
      // Use the values to send to Firebase
    }
  }

  bool isValidEmail(String test) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(test);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email address
                  TextFormField(
                    key: ValueKey('email'),
                    decoration: InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value.isEmpty || !isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value.trim();
                    },
                  ),
                  if (!_isLogin)
                    // User name
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value.trim();
                      },
                    ),
                  // Password
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                    onSaved: (value) {
                      _password = value.trim();
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
