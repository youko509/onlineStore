
import 'package:flutter/material.dart';
import 'package:storeapp/product.dart';
import 'package:storeapp/store.dart';

import 'cart.dart';
import 'db.dart';

class FavoriteApp extends StatefulWidget {
  final int userId;
  final int selectedindex;
  const FavoriteApp({super.key, required this.userId, required this.selectedindex});
  

  @override
  State<FavoriteApp> createState() {
    return _favoritePage();
  }
}


class _favoritePage extends State<FavoriteApp>  {
  Future<List<FavoriteProduct>>? _futureFavorite;
    int selectedindex =0;
    final List<FavoriteProduct> cartItems=List.empty(growable: true);
      @override
    
void initState() {
    super.initState();
    _futureFavorite = FavoriteService().getCartItems(userId: widget.userId);
    selectedindex=widget.selectedindex;
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
        title: Text('Favorite Page'),
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
                  builder: (context) =>  CartApp(userId:widget.userId,selectedindex:selectedindex),
                ),
              );
           }
          if (selectedindex==0){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   FavoriteApp(userId:widget.userId,selectedindex:selectedindex),
                ),
              );
          }
           if (selectedindex==1){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   StoreApp(id: widget.userId,),
                ),
              );
          }

         });
        },
        currentIndex: selectedindex,
        items: [
        BottomNavigationBarItem(label: "Favorite",icon:  Icon(Icons.favorite)),
        BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Cart",icon: Icon(Icons.add_shopping_cart))
      ]),
    );
  }
  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _futureFavorite,
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
                       
                        ]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                             FavoriteService().removeItemFromCart(index);
                        setState(() {
                          _futureFavorite = FavoriteService().getCartItems(userId: widget.userId);
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
