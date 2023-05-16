import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';

class FavoriteProduct {
  final int id;
  final int userId;
  final int productId;

  FavoriteProduct({required this.id, required this.userId, required this.productId});

  Map<String, dynamic> toMap() {
  return {
  'id': id,
  'userId': userId,
  'productId': productId,
  };
  }
}
class CartItem {
  final int cartId;
  final int productId;
  final int quantity;

  CartItem({required this.cartId, required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class Cart {
  final int userId;
  final int productId;
  final String productName;
  final bool isPaid;
  const Cart({required this.userId, required this.productId, required this.productName,required this.isPaid});

   Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId':productId,
      'productName': productName,
      'isPaid':isPaid,
    };
  }

}
  Future<void> insertCart(Cart cart) async {
  final Database db = await cartTab();
    await db.insert(
      'Cart',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
Future<void> insertCartItem(CartItem cartItem) async {
  final Database db = await cartTab();
  await db.insert(
    'cartitem',
    cartItem.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
} 
Future<Database> cartTab() async {
  final path = await getDatabasesPath();
  return await openDatabase(
    join(path, 'store.db'),
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE Cart (
          id INTEGER PRIMARY KEY,
          userId INTEGER,
          productId INTEGER,
          productName INTEGER,
          isPaid 
        )
      ''');
      await db.execute('''
        CREATE TABLE Cartitem (
          id INTEGER PRIMARY KEY,
          cartId INTEGER,
          productId INTEGER,
          quantity INTEGER
        )
      ''');
    },
    version: 2,
  );
}

Future<List<Map<String, dynamic>>> getCartWithItems(int cartId) async {
  final Database db = await cartTab();
  return await db.rawQuery('''
    SELECT cart.*, cartitem.productId, cartitem.quantity 
    FROM cart 
    INNER JOIN cartitem ON cart.id = cartitem.cartId 
    WHERE cart.id = $cartId
  ''');
}
