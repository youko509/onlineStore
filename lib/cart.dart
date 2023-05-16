
import 'package:flutter/material.dart';
import 'package:storeapp/product.dart';

import 'db.dart';

class CartApp extends StatefulWidget {
  final int userId;
  const CartApp({super.key, required this.userId});
  

  @override
  State<CartApp> createState() {
    return _CartPage();
  }
}


class _CartPage extends State<CartApp>  {
  Future<List<Cart>>? _futureCart;
    Future<List<Cart>>? carts ;
    int selectedindex =0;
    final List<Cart> cartItems=List.empty(growable: true);
      @override
    
void initState() {
    super.initState();
    _futureCart = CartService().getCartItems();
    }

   
  void checkout() {
    // Perform checkout logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: Text('Perform checkout logic here'),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: buildFutureBuilder(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
         setState(() {
           selectedindex=index;
           if (selectedindex==2){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   CartApp(userId:widget.userId),
                ),
              );
           }

         });
        },
        currentIndex: selectedindex,
        items: [
        BottomNavigationBarItem(label: "Peson",icon:  Icon(Icons.person)),
        BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Cart",icon: Icon(Icons.add_shopping_cart))
      ]),
    );
  }
  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCart,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                 
                  return   Container(
                      margin: EdgeInsets.only(bottom: 16.0, top: 10, left: 10,right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          '${snapshot.data[index].productName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                          Container(
                      margin: EdgeInsets.only(top: 8),
                          child: Text(
                          'Price \$${snapshot.data[index].price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        ),
                       Container(
                      margin: EdgeInsets.only(bottom: 10.0, top: 14),
                      child:ElevatedButton(
                      onPressed: () {
                        // Checkout logic
                        print('Checkout ${snapshot.data[index].productName}');
                      },
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          
                          color: Color.fromARGB(255, 245, 246, 247),
                        ),
                      ),
                    ),),
                        ]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                             CartService().removeItemFromCart(index);
                        setState(() {
                          _futureCart = CartService().getCartItems();
                        });
                          },
                        ),
                      ),
                    );
                  },
        
              );
        }
        return const Center(child: CircularProgressIndicator());
      }
    );
  }
}




// ListTile(
//                     title: Text('${snapshot.data[index].productName}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         CartService().removeItemFromCart(index);
//                         setState(() {
//                           _futureCart = CartService().getCartItems();
//                         });
//                       },
//                     ),
//                   );