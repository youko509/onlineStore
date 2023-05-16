import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:storeapp/cart.dart';
import 'package:storeapp/db.dart';
import 'package:storeapp/login.dart';

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






class StoreApp extends StatefulWidget {
  const StoreApp({super.key, required this.id, required this.name, required this.email});
  final int id;
  final String name;
  final String email;

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
  @override
void initState() {
    super.initState();
    // synchronous call if you don't care about the result
    () async {
        _futureCategorie = getCategorie();
    }();
    // anonymous function if you want the result
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      drawer:  Drawer(
          
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.brown),
                child:  Text("MyApp"),
                ),
              ListTile(title:const Text("Account"), onTap: (){},),
              ListTile(title:const Text("FAQ"), onTap: (){},),
              ListTile(title:const Text("Logout"), onTap: (){
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
         });
        },
        currentIndex: selectedindex,
        items: [
        BottomNavigationBarItem(label: "Peson",icon:  Icon(Icons.person)),
        BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Cart",icon: Icon(Icons.add_shopping_cart))
      ]),
      body: Container(
        child:buildFutureBuilder(),
      ),
      
    );
  }
  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCategorie,
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          
          return ListView.builder(
                itemCount: snapshot.data.length - 14,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                   
                    children: [SizedBox(
                      child: Row(
                        children: [
                        Image.network('${snapshot.data[index].image}', height: 80,  
                        width: 80  ),
                        
                        Text(
                          '${snapshot.data[index].title}',
                        
                          style: const TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 9, 9, 9)),
                          maxLines: 2,
                        ),
                        Container(
                          padding:const EdgeInsets.only(left: 30.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductsApp(id:snapshot.data[index].id, title: snapshot.data[index].title,)),
                                );
                              }, 
                              child: const Text("Read Me")),
                        )
                        ],
                      ),
                    )]
                    
                    );
                  
                }
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
  const ProductsApp({super.key, required this.id, required this.title});
  final int id;
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
      ),
      bottomNavigationBar:BottomNavigationBar(
        onTap: (index){
         setState(() {
           selectedindex=index;
           if (selectedindex==2){
             Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  const CartApp(),
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
                  return GridTile(
                    child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Image.network('${snapshot.data[index].image}'),
                  Text('${snapshot.data[index].name}'),
                  Text('${snapshot.data[index].description}'),
                  Text('\$${snapshot.data[index].price.toStringAsFixed(2)}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                         insertCart(Cart(userId: 1,productId: snapshot.data[index].id,productName:snapshot.data[index].name,isPaid: false));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          // Ajoute nan lis favori
                        },
                      ),
                      Column(
                      children: [ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ProductDetailPage(product: Product(id: snapshot.data[index].id,name:snapshot.data[index].name,price: snapshot.data[index].price,description: snapshot.data[index].description,image: snapshot.data[index].image)),
                            ),
                          );
                        }, 
                        child: Text("See More")),]
                  )
                    ],
                  ),
                ],
              ),
                );
              }
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

