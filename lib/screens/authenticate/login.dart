import 'package:flutter/material.dart';
import 'package:food_project/api/food_api.dart';
import 'package:food_project/models/user.dart';
import 'package:food_project/notifier/auth_notifier.dart';
import 'package:food_project/shared/constants.dart';
import 'package:food_project/shared/loading.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool loading = false;
  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Name'),
      /*decoration: InputDecoration(
        labelText: "Display Name",
        labelStyle: TextStyle(color: Colors.white54),
      ),*/
      keyboardType: TextInputType.text,
      //style: TextStyle(fontSize: 26, color: Colors.white),
      //cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _user.displayName = value;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Email'),
      /*decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.white54),
      ),*/
      keyboardType: TextInputType.emailAddress,
      //initialValue: 'abc@xyz.com',
      //style: TextStyle(fontSize: 26, color: Colors.white),
      //cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Password'),
      /*decoration: InputDecoration(
        labelText: "c",
        labelStyle: TextStyle(color: Colors.white54),
      ),
      style: TextStyle(fontSize: 26, color: Colors.white),*/
      //cursorColor: Colors.white,
      obscureText: true,
      controller: _passwordController,
      validator: (val) => val.length < 6 ? 'Enter a password greater than 5 characters' : null,
      /*validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }
        return null;
      },*/
      onSaved: (String value) {
        _user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
      /*decoration: InputDecoration(
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: Colors.white54),
      ),*/
      //style: TextStyle(fontSize: 16, color: Colors.white),
      //cursorColor: Colors.white,
      obscureText: true,
      validator: (val) => _passwordController.text != val ? 'Passwords do not match' : null,
      /*validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
        return null;
      },*/
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen"); 
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[200],
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        //decoration: BoxDecoration(color: Color(0xff34056D)),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 50, 32, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Please Sign In",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.pink[400]),
                  ),
                  SizedBox(height: 20),
                  _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                  SizedBox(height: 20),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 20),
                  _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                  SizedBox(height: 20),
                  ButtonTheme(
                    minWidth: 200,
                    height: 40,
                    child: RaisedButton(
                      color: Colors.pink[400],
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonTheme(
                    minWidth: 200,
                    height: 45,
                    child: RaisedButton(
                      color: Colors.pink[400],
                      //padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _authMode =
                          _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                        });
                      },
                    ),
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