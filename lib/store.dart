import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:storeapp/cart.dart';
import 'package:storeapp/db.dart';
import 'package:storeapp/login.dart';
import 'favorite.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  const Product({required this.id,required this.name, required this.description, required this.price,required this.image});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      image:json['images'][0],
      description:json['description'],
      price:json['price'],
    );
  }
}
class Categorie {
  final int id;
  final String title;
  final String image;
  const Categorie({required this.id, required this.title, required this.image});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      title: json['name'],
      image:json['image'],
    );
  }
}


 void info(context,message) {
    // Perform checkout logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: 
              Container(
                margin: EdgeInsets.all(5),
               
             child:  Text(message)
           ,),
            
           
            
           
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



class StoreApp extends StatefulWidget {
  const StoreApp({super.key,required this.id, String name='', String email=''});
  final int id;
  
  final String name='';
  final String email='';

  @override
  State<StoreApp> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<StoreApp>  {
  Future<List<Categorie>>? _futureCategorie;
  List<Categorie> categorieList=List.empty(growable: true);
  int selectedindex=0;
  Future<List<Categorie>> getCategorie() async {
    
      final List l;
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories'),
      );

      if (response.statusCode == 200) {
        
        l = jsonDecode(response.body);

        l.forEach((el) { 
          categorieList.add(Categorie.fromJson(el));
          });
        
        return categorieList;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to get Categories.');
      }
  }
  Future<List<Product>>? _futureProduct;
  List<Product> productList=List.empty(growable: true);
  IconData icon = Icons.favorite_border ;
  Future<List<Product>> getproducts() async {
    
      final List l;
      
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/products'),
      );
      if (response.statusCode == 200) {
        
        l = jsonDecode(response.body);

        l.forEach((el) { 
          productList.add(Product.fromJson(el));
          });
        return productList;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to get Categories.');
      }
  }
  @override
void initState() {
    super.initState();
    // synchronous call if you don't care about the result
    () async {
        _futureCategorie = getCategorie();
         _futureProduct = getproducts();
        print(widget.id);
    }();
    // anonymous function if you want the result
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        actions: [
          ElevatedButton(onPressed: (){
            if (widget.id ==0){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.id==0  ? const LoginApp(): CartApp(userId:widget.id,selectedindex:selectedindex),
                ),
              );
          }
          }, child: Text('Payment'))
        ],
      ),
      drawer:  Drawer(
          
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child:  Text("MyApp"),
                ),
              
              ListTile(title:widget.id==0 ? const Text("Login"):const Text("Logout"), onTap: (){
                 Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>const  LoginApp())
                                );
                },)]
            ),
        ),
      bottomNavigationBar:BottomNavigationBar(
        onTap: (index){
         setState(() {
           selectedindex=index;
           if (selectedindex==2){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CartApp(userId:widget.id,selectedindex:selectedindex),
                ),
              );
           }
          if (selectedindex==0){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   FavoriteApp(userId:widget.id,selectedindex:selectedindex),
                ),
              );
          }
           if (selectedindex==1){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   StoreApp(id: widget.id,),
                ),
              );
          }
         });
        },
        currentIndex: 1,
        items: [
        BottomNavigationBarItem(label: "Favorite",icon:  Icon(Icons.favorite)),
        BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Cart",icon: Icon(Icons.add_shopping_cart))
      ]),
      body: Column(children: <Widget>[Expanded(child: buildFutureBuilder()),Expanded(child: buildBuilder()) ],) 
      
      
    );
  }
  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCategorie,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          return ListView.builder(
                itemCount: snapshot.data.length ,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                            margin: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    '${snapshot.data[index].image}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    color: Colors.white,
                                    child: TextButton(
                                      onPressed: () {
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ProductsApp(userId:widget.id,id:snapshot.data[index].id, title: snapshot.data[index].name,)),
                                        );
                                      },
                                      child: Text(
                                        '${snapshot.data[index].title}',
                                         style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                    );
        
        }else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  FutureBuilder buildBuilder() {
    return FutureBuilder(
      future: _futureProduct,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          
          return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    
                    width: 60,
              margin: EdgeInsets.all(16.0),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                         children:[IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          if (widget.id!=0){
                             CartService().addItemToCart(Cart(userId: widget.id,productId: snapshot.data[index].id,productName:snapshot.data[index].name,price: snapshot.data[index].price,paid: 'Unpaid',quantity: 0).toMap());
                         print("add");
                          }else{
                            info(context, "You have to login to add Cart");
                          }
                         
                        },
                      ),
                      IconButton(
                        icon: Icon(icon),
                        onPressed: () {
                          if (widget.id!=0){
                             FavoriteService().addItemToCart(FavoriteProduct(userId: widget.id,productId: snapshot.data[index].id,productName:snapshot.data[index].name,price: snapshot.data[index].price,).toMap());
                         print("add");
                          }else{
                            info(context, "You have to login to add Favorite");
                          }
                        },
                      ),]),
                        Text(
                         snapshot.data[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '\$${snapshot.data[index].price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ProductDetailPage(product: Product(id: snapshot.data[index].id,name:snapshot.data[index].name,price: snapshot.data[index].price,description: snapshot.data[index].description,image: snapshot.data[index].image)),
                            ),
                          );
                        }, 
                        child: Text("See More")),),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
              
       );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

//  maria@mail.com

class ProductsApp extends StatefulWidget {
  const ProductsApp({super.key, required this.id, required this.title,this.userId});
  final int id;
  final int? userId;
  final String title;
 @override
  State<ProductsApp> createState(){
    return _ProductListPage();
  }
}


class _ProductListPage extends State<ProductsApp> {
  int selectedindex=0;
  Future<List<Product>>? _futureProduct;
  List<Product> productList=List.empty(growable: true);
  IconData icon = Icons.favorite_border ;
  Future<List<Product>> getproducts({required int id}) async {
    
      final List l;
      
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories/$id/products'),
      );
      if (response.statusCode == 200) {
        
        l = jsonDecode(response.body);

        l.forEach((el) { 
          productList.add(Product.fromJson(el));
          });
        return productList;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to get Categories.');
      }
  }


 @override
void initState() {
    super.initState();
    // synchronous call if you don't care about the result
    () async {
        _futureProduct = getproducts(id:widget.id);
       
    }();
    // anonymous function if you want the result
}
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lis Pwodwi pou ${widget.title}'),
        actions: [
          ElevatedButton(onPressed: (){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.userId==0  ? const LoginApp():CartApp(userId:widget.userId!,selectedindex:selectedindex) ,
                ),
              );
          }, child: Text('Payment'))
        ],
      ),
      bottomNavigationBar:BottomNavigationBar(
        onTap: (index){
         setState(() {
           selectedindex=index;
           if (selectedindex==2){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CartApp(userId:widget.userId!,selectedindex:selectedindex),
                ),
              );
           }
          if (selectedindex==0){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   FavoriteApp(userId:widget.userId!,selectedindex:selectedindex),
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
      body: buildFutureBuilder(),
    );
  }
  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _futureProduct,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          
          return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    
                    width: 60,
              margin: EdgeInsets.all(16.0),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                         children:[IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          if (widget.userId!=0){
                             CartService().addItemToCart(Cart(userId: widget.userId!,productId: snapshot.data[index].id,productName:snapshot.data[index].name,price: snapshot.data[index].price,paid: 'Unpaid',quantity: 0).toMap());
                         print("add");
                          }else{
                            info(context, "You have to login to add Cart");
                          }
                         
                        },
                      ),
                      IconButton(
                        icon: Icon(icon),
                        onPressed: () {
                         if (widget.userId!=0){
                             FavoriteService().addItemToCart(FavoriteProduct(userId: widget.userId!,productId: snapshot.data[index].id,productName:snapshot.data[index].name,price: snapshot.data[index].price,).toMap());
                         print("add");
                         }else{
                          info(context, "You have to login to add Favorite");
                         }
                          
                        },
                      ),]),
                        Text(
                         snapshot.data[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '\$${snapshot.data[index].price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ProductDetailPage(product: Product(id: snapshot.data[index].id,name:snapshot.data[index].name,price: snapshot.data[index].price,description: snapshot.data[index].description,image: snapshot.data[index].image)),
                            ),
                          );
                        }, 
                        child: Text("See More")),),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
              
       );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
}
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detay Pwodwi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(product.image, height: 300,),
            SizedBox(height: 10),
            Text(product.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(product.description, textAlign: TextAlign.center),
            SizedBox(height: 10),
            Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ajoute nan panye
              },
              child: Text('Ajoute nan panye'),
            ),
          ],
        ),
      ),
    );
  }
}

