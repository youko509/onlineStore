import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'store.dart';





class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

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
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

 @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void gettoStore(int id, String name , String email){
    print(id);
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>   StoreApp(id:id,name:name,email:email)),
      );
  }
  Future<void>  getprofileAndConnect(String accessToken ) async {
      String apiUrl = 'https://api.escuelajs.co/api/v1/auth/profile';
      Map<String,String> header={
        "Authorization": "Bearer $accessToken"
      };
     try {
    http.Response response = await http.get(
      
      Uri.parse(apiUrl),
      headers: header,
    );
    if (response.statusCode == 200) {
      gettoStore(jsonDecode(response.body)['id'],jsonDecode(response.body)['name'],jsonDecode(response.body)['email']);
    }else {
    print('Failed to post data. Error: ${response.statusCode}');
  }
  } catch (e) {
  print('Error occurred: $e');
}

  }

  Future<void> postLoginData(String email, String password) async {
  // The URL of the API endpoint
  String apiUrl = 'https://api.escuelajs.co/api/v1/auth/login';

  // The data to be sent in the request
  Map<String, dynamic> data = {
    'email': email,
    "password": password,
  };

  try {
    
    // Send a POST request to the API endpoint
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(data),
    );
   print(response);
    if (response.statusCode == 201) {
      getprofileAndConnect(jsonDecode(response.body)['access_token']);
      //  gettoStore();
    print('Data posted successfully');
  } else {
    print('Failed to post data. Error: ${response.statusCode}');
  }
  } catch (e) {
  print('Error occurred: $e');
}
  
  // Check the response status code
  
}



  void _submit() {
    final form = _formKey.currentState;
    
    if (form?.validate() == true) {
      String email = _emailController.text;
      String password = _passwordController.text;

      form?.save();
      postLoginData(email,password);
      // Perform login logic here
    }
  }
   void _register(){
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const RegisterApp()),
      );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
               
              ),
             Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Container(
                    margin:const EdgeInsets.only(left: 8, top: 10),
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('login'),
                    )
                  ),
                  
                ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}