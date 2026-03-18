import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/supplier.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green[600],
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red[600],
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  // ==================== CATEGORIES ====================
  Stream<List<Category>> getCategories() {
    return _db
        .collection('categories')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addCategory(Category category) async {
    try {
      await _db.collection('categories').add({
        ...category.toMap(),
        'userId': userId,
      });
      _showSuccess('Category added successfully!');
    } catch (e) {
      _showError('Failed to add category.');
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _db.collection('categories').doc(category.id).update(category.toMap());
      _showSuccess('Category updated successfully!');
    } catch (e) {
      _showError('Failed to update category.');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _db.collection('categories').doc(id).delete();
      _showSuccess('Category deleted successfully!');
    } catch (e) {
      _showError('Failed to delete category.');
    }
  }

  // ==================== SUPPLIERS ====================
  Stream<List<Supplier>> getSuppliers() {
    return _db
        .collection('suppliers')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Supplier.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addSupplier(Supplier supplier) async {
    try {
      await _db.collection('suppliers').add({
        ...supplier.toMap(),
        'userId': userId,
      });
      _showSuccess('Supplier added successfully!');
    } catch (e) {
      _showError('Failed to add supplier.');
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    try {
      await _db.collection('suppliers').doc(supplier.id).update(supplier.toMap());
      _showSuccess('Supplier updated successfully!');
    } catch (e) {
      _showError('Failed to update supplier.');
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await _db.collection('suppliers').doc(id).delete();
      _showSuccess('Supplier deleted successfully!');
    } catch (e) {
      _showError('Failed to delete supplier.');
    }
  }

  // ==================== PRODUCTS ====================
  Stream<List<Product>> getProducts() {
    return _db
        .collection('products')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add({
        ...product.toMap(),
        'userId': userId,
      });
      _showSuccess('Product added successfully!');
    } catch (e) {
      _showError('Failed to add product.');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
      _showSuccess('Product updated successfully!');
    } catch (e) {
      _showError('Failed to update product.');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _db.collection('products').doc(id).delete();
      _showSuccess('Product deleted successfully!');
    } catch (e) {
      _showError('Failed to delete product.');
    }
  }
}