import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class FavoriteProduct {
  final int id =0;
  final int userId;
  final int productId;
  final int price;
  final String productName;
  FavoriteProduct({id,required this.userId, required this.productId, required this.price, required this.productName});

  Map<String, dynamic> toMap() {
  return {
  'id': id,
  'userId': userId,
  'productId': productId,
  'price':price,
  'productName':productName,
  };
  }
factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id:json['id'],
      userId: json['userId'],
      productId: json['productId'],
      productName:json['productName'],
      price: json['price'],
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
  static const String _cartBoxName = 'box4';
  List<Cart> cartList=List.empty(growable: true);
  Future<void> addItemToCart(Map<String, dynamic> item) async {
    final box =  Hive.box(_cartBoxName);
    box.add(item);
  }

  Future<List<Cart>> getCartItems({required int userId}) async {
    final box =  Hive.box(_cartBoxName);

    for (var el in box.values.toList()) {
      if (el['userId']==userId){
       
       cartList.add((Cart(userId:el['userId'],productId: el['productId'],price: el['price'],productName: el['productName'],paid: el['paid'],quantity: el['quantity'] )));

      }
    }
    return cartList;
  }

  Future<void> removeItemFromCart(int index) async {
    final box =  Hive.box(_cartBoxName);
    box.deleteAt(index);
  }
}

class FavoriteService {
  static const String _cartBoxName = 'fav4';
  List<FavoriteProduct> cartList=List.empty(growable: true);
  Future<void> addItemToCart(Map<String, dynamic> item) async {
    final box =  Hive.box(_cartBoxName);
    box.add(item);
  }

  Future<List<FavoriteProduct>> getCartItems({required int userId}) async {
    final box =  Hive.box(_cartBoxName);
    box.values.toList().forEach((el) {
      if (el['userId']==userId){
      cartList.add(FavoriteProduct(price: el['price'],productId: el['productId'],userId: el['userId'],productName: el['productName'])); 
        }
  });
    return cartList;
  }

  Future<void> removeItemFromCart(int index) async {
    final box =  Hive.box(_cartBoxName);
    box.deleteAt(index);
  }
}
