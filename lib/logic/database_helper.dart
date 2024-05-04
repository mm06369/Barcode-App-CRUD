import 'package:barcode_app/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<bool> addProductToDatabase(ProductModel product) async {
    try {
      DocumentReference docRef = firestoreInstance
          .collection('products')
          .doc(product.barcodeNumber.toString());

      await docRef.set(product.toJson());
      debugPrint('Product saved successfully with ID: ${docRef.id}');
      return true;
    } catch (e) {
      debugPrint('Error saving product: $e');
      return false;
    }
  }

  deleteProductFromDatabase(ProductModel product) async {
    try {
      await firestoreInstance
          .collection('products')
          .doc(product.barcodeNumber.toString())
          .delete();
      debugPrint('Product deleted successfully');
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      // Query the "products" collection
      QuerySnapshot querySnapshot =
          await firestoreInstance.collection('products').get();

      // Map the documents to ProductModel
      List<ProductModel> products = querySnapshot.docs.map((doc) {
        return ProductModel(
          productName: doc['productName'],
          barcodeNumber: doc['barcodeNumber'],
          stock: doc['stock'],
          price: doc['price']
              .toDouble(), // Ensure the price is treated as a double
        );
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return []; // Return an empty list on error
    }
  }

  searchProductInDatabase(String barcode) async {
    try {
      DocumentSnapshot doc = await firestoreInstance
          .collection('products')
          .doc(barcode)
          .get();
      if (doc.exists) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error searching product: $e');
      return null;
    }
  }

  deleteProductfromDatabase(String barcode) async {
    try {
      await firestoreInstance.collection('products').doc(barcode).delete();
      debugPrint('Product deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  updateProductToDatabase(ProductModel product) async {
    try {
      await firestoreInstance
          .collection('products')
          .doc(product.barcodeNumber)
          .update(product.toJson());
      debugPrint('Product updated successfully');
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }
}
