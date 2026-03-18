import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/supplier.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== CATEGORIES ====================
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addCategory(Category category) async {
    await _db.collection('categories').add(category.toMap());
  }

  Future<void> updateCategory(Category category) async {
    await _db.collection('categories').doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _db.collection('categories').doc(id).delete();
  }

  // ==================== SUPPLIERS ====================
  Stream<List<Supplier>> getSuppliers() {
    return _db.collection('suppliers').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Supplier.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addSupplier(Supplier supplier) async {
    await _db.collection('suppliers').add(supplier.toMap());
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await _db.collection('suppliers').doc(supplier.id).update(supplier.toMap());
  }

  Future<void> deleteSupplier(String id) async {
    await _db.collection('suppliers').doc(id).delete();
  }

  // ==================== PRODUCTS ====================
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _db.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }
}