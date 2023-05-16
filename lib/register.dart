import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'store.dart';
Future<void> postRegisterData(String email, String password) async {
  // The URL of the API endpoint
  String apiUrl = 'https://api.escuelajs.co/api/v1/users/';

  // The data to be sent in the request
  Map<String, dynamic> data = {
    'name':"nam",
    'email': email,
    "password": password,
  };
  print(data);
  try {
     print("strast");
     http.Response response2 = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/users'));
    print(response2.statusCode);
    final List<dynamic> data2 = json.decode(response2.body);
    print(data2);
    // Send a POST request to the API endpoint
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
    print('Data posted successfully');
  } else {
    print('Failed to post data. Error: ${response.statusCode}');
  }
  } catch (e) {
  print('Error occurred: $e');
}
}
class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void login(){
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>   const StoreApp(id:67,name:"fd",email:"de")),
      );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      
      String email = _emailController.text;
      String password = _passwordController.text;
    
      postRegisterData(email,password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password again',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Container(
                    margin:const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    )
                  ),
                  Container(
                    margin:const EdgeInsets.all(8),
                    child:
                    ElevatedButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ))
                ],
                ),
            ]
          )
        ),
      ),
    );
  }
}
