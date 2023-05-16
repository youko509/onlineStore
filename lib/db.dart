import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class FavoriteProduct {
  final int id =0;
  final int userId;
  final int productId;

  FavoriteProduct({id,required this.userId, required this.productId});

  Map<String, dynamic> toMap() {
  return {
  'id': id,
  'userId': userId,
  'productId': productId,
  };
  }
factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id:json['id'],
      userId: json['userId'],
      productId: json['productId'],
    );

}
}
class Cart {

  final int userId;
  final int productId;
  final int price;
  final String productName;
  final String paid;
  final int quantity;

  const Cart({required this.userId, required this.productId, required this.productName,required this.price,required this.paid, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'price':price,
      'productName':productName,
      'paid':paid,
      'quantity': quantity,
    };
  }
   factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json['userId'],
      productId: json['productId'],
      price:json['price'],
      productName:json['productName'],
      paid:json['paid'],
      quantity: json['quantity'],
    );
  }

}


class CartService {
  static const String _cartBoxName = 'box';
  List<Cart> cartList=List.empty(growable: true);
  Future<void> addItemToCart(Map<String, dynamic> item) async {
    final box =  Hive.box(_cartBoxName);
    box.add(item);
  }

  Future<List<Cart>> getCartItems() async {
    final box =  Hive.box(_cartBoxName);
    box.values.toList().forEach((el) {cartList.add(Cart.fromJson(el)); });
    return cartList;
  }

  Future<void> removeItemFromCart(int index) async {
    final box =  Hive.box(_cartBoxName);
    box.deleteAt(index);
  }
}

class FavoriteSerivice {
  static const String _cartBoxName = 'fav';
  List<FavoriteProduct> cartList=List.empty(growable: true);
  Future<void> addItemToCart(Map<String, dynamic> item) async {
    final box =  Hive.box(_cartBoxName);
    box.add(item);
  }

  Future<List<FavoriteProduct>> getCartItems() async {
    final box =  Hive.box(_cartBoxName);
    box.values.toList().forEach((el) {cartList.add(FavoriteProduct.fromJson(el)); });
    return cartList;
  }

  Future<void> removeItemFromCart(int index) async {
    final box =  Hive.box(_cartBoxName);
    box.deleteAt(index);
  }
}
