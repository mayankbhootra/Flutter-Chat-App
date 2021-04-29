import 'dart:io';

import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
      String email,
      String password,
      String userName,
      File image,
      bool isLogin,
      BuildContext ctx
      ) submitAuthForm;

  AuthForm(this.submitAuthForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;
//  final _emailController = TextEditingController();
//  final _usernameController = TextEditingController();
//  final _passwordController = TextEditingController();

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySybmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if(_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Please pick an image'),
            backgroundColor: Theme.of(context).errorColor,
          )
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
    }
    widget.submitAuthForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _userImageFile,
      _isLogin,
      context
    );
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
              children: <Widget>[
                if(!_isLogin)
                  UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
//                        controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  validator: (value) {
                    if (value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
//                        controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter atleast 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
//                        controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if(widget.isLoading)
                  CircularProgressIndicator(),
                if(!widget.isLoading)
                  RaisedButton(
                    child: Text(
                      _isLogin ? 'Login' : 'Signup',
//                            style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                            ),
                    ),
                    elevation: 5,
                    splashColor: Theme.of(context).primaryColor,
                    onPressed: _trySybmit),
                if(!widget.isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _formKey.currentState.reset();
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create new account'
                          : 'Already have an account',
                      style: TextStyle(
//                              color: Theme.of(context).primaryColor
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
