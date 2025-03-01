import 'package:flutter/material.dart';
import 'package:project_ebook/services/functions/authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Welcome', // More welcoming title
          style: TextStyle(
            fontSize: 20.0, // Adjust font size
            fontWeight: FontWeight.bold,
            color: Colors.black,

          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Allow scrolling on small screens
          padding: EdgeInsets.symmetric(horizontal: 20.0), // Consistent padding
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center , // Left-align content
                children: [
                  Text('E-Book',
                    style:TextStyle(fontWeight: FontWeight.bold, fontSize:30 ),
                  ),
                  SizedBox(height: 30,),
                  Visibility(
                    visible: !login, // Show fullname field only for signup
                    child: TextFormField(
                      key: ValueKey('fullname'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Full Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Full Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          fullname = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0), // Consistent spacing
                  TextFormField(
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter valid Email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Please Enter Password of min length 6';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        password = value!;
                      });
                    },
                  ),
                  SizedBox(height: 30.0), // Adjust spacing for button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          login
                              ? AuthServices.signinUser(email, password, context)
                              : AuthServices.signupUser(
                              email, password, fullname, context);
                        }
                      },
                      child: Text(login ? 'Login' : 'Signup '),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.purpleAccent, // White text for contrast
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                      });
                    },
                    child: Text(
                      login
                          ? "Don't have an account? Signup"
                          : "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.black, // Primary color for text
                      ),
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
