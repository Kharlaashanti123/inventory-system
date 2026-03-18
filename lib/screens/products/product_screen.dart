import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../models/supplier.dart';
import '../../services/firestore_service.dart';

class ProductScreen extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  ProductScreen({super.key});

  void _showForm(BuildContext context, {Product? product, required List<Category> categories, required List<Supplier> suppliers}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final descController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final quantityController = TextEditingController(text: product?.quantity.toString() ?? '');
    String? selectedCategoryId = product?.categoryId;
    String? selectedSupplierId = product?.supplierId;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))).toList(),
                  onChanged: (val) => setState(() => selectedCategoryId = val),
                ),
                DropdownButtonFormField<String>(
                  value: selectedSupplierId,
                  decoration: const InputDecoration(labelText: 'Supplier'),
                  items: suppliers.map((sup) => DropdownMenuItem(value: sup.id, child: Text(sup.name))).toList(),
                  onChanged: (val) => setState(() => selectedSupplierId = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final prod = Product(
                  id: product?.id ?? '',
                  name: nameController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  categoryId: selectedCategoryId ?? '',
                  supplierId: selectedSupplierId ?? '',
                );
                if (product == null) {
                  _service.addProduct(prod);
                } else {
                  _service.updateProduct(prod);
                }
                Navigator.pop(context);
              },
              child: Text(product == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _service.deleteProduct(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: StreamBuilder<List<Category>>(
        stream: _service.getCategories(),
        builder: (context, catSnapshot) {
          return StreamBuilder<List<Supplier>>(
            stream: _service.getSuppliers(),
            builder: (context, supSnapshot) {
              return FloatingActionButton(
                onPressed: () => _showForm(
                  context,
                  categories: catSnapshot.data ?? [],
                  suppliers: supSnapshot.data ?? [],
                ),
                child: const Icon(Icons.add),
              );
            },
          );
        },
      ),
      body: StreamBuilder<List<Product>>(
        stream: _service.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products yet.'));
          }
          final products = snapshot.data!;
          return StreamBuilder<List<Category>>(
            stream: _service.getCategories(),
            builder: (context, catSnapshot) {
              return StreamBuilder<List<Supplier>>(
                stream: _service.getSuppliers(),
                builder: (context, supSnapshot) {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final prod = products[index];
                      final category = catSnapshot.data?.firstWhere(
                        (c) => c.id == prod.categoryId,
                        orElse: () => Category(id: '', name: 'N/A', description: ''),
                      );
                      final supplier = supSnapshot.data?.firstWhere(
                        (s) => s.id == prod.supplierId,
                        orElse: () => Supplier(id: '', name: 'N/A', contact: '', email: '', address: ''),
                      );
                      return ListTile(
                        title: Text(prod.name),
                        subtitle: Text('₱${prod.price} • Qty: ${prod.quantity} • ${category?.name} • ${supplier?.name}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showForm(
                                context,
                                product: prod,
                                categories: catSnapshot.data ?? [],
                                suppliers: supSnapshot.data ?? [],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, prod.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}