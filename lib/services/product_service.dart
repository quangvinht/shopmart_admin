import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopmart_admin/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  static Future<void> createProduct(
    String title,
    XFile image,
    String price,
    String category,
    String des,
    String quantity,
  ) async {
    final productId = Uuid().v4();

    final ref = FirebaseStorage.instance
        .ref()
        .child("productsImages")
        .child("${title}_${productId}.jpg");
    await ref.putFile(File(image!.path));
    final productImageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection("products").doc(productId).set({
      'id': productId.trim(),
      'title': title,
      'price': price,
      'image': productImageUrl,
      'category': category,
      'description': des,
      'quantity': quantity,
      'createdAt': Timestamp.now(),
    });
  }

  static Future<List<ProductModel>> getProducts() async {
    final productsCol = FirebaseFirestore.instance.collection("products");
    final snapshot = await productsCol.get();

    List<ProductModel> products = snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data());
    }).toList();

    return products;
  }

  static Stream<List<ProductModel>> getProductsStream() {
    final productsCol = FirebaseFirestore.instance.collection("products");

    return productsCol.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList();
    });
  }

  static Future<void> updateProduct(
    String title,
    XFile? pickedImage,
    String price,
    String category,
    String des,
    String quantity,
    String productId,
    String productNetworkImage,
  ) async {
    // Khởi tạo biến productImageUrl với giá trị mặc định là productNetworkImage.
    // Nếu pickedImage không null, sẽ cập nhật productImageUrl sau khi tải ảnh lên.
    String productImageUrl = productNetworkImage;

    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("productsImages")
          .child("${title}_$productId.jpg");
      await ref.putFile(File(pickedImage.path));
      productImageUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update({
      'id': productId,
      'title': title,
      'price': price,
      'image': productImageUrl,
      'category': category,
      'description': des,
      'quantity': quantity,
    });
  }
}
