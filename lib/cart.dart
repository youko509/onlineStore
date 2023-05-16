
import 'package:flutter/material.dart';
import 'package:storeapp/product.dart';

class CartApp extends StatefulWidget {
  const CartApp({super.key,});
  

  @override
  State<CartApp> createState() {
    return _CartPage();
  }
}

class _CartPage extends State<CartApp>  {
   final List<String> cartItems = [
    'Product 1',
    'Product 2',
    'Product 3',
    'Product 4',
  ];
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remove item from cart
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Perform checkout
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
  
}