import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  Timestamp? createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['id'] ?? '',
      productTitle: map['title'] ?? '',
      productPrice: map['price'] ?? '',
      productCategory: map['category'] ?? '',
      productDescription: map['description'] ?? '',
      productImage: map['image'] ?? '',
      productQuantity: map['quantity'] ?? '',
      createdAt: map['createdAt'],
    );
  }
}
