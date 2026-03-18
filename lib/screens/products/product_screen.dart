import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../models/supplier.dart';
import '../../services/firestore_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirestoreService _service = FirestoreService();
  final searchController = TextEditingController();
  String searchQuery = '';
  String sortBy = 'name';
  bool sortAscending = true;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(product == null ? 'Add Product' : 'Edit Product',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.notes_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: const Icon(Icons.numbers_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                  items: categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))).toList(),
                  onChanged: (val) => setState(() => selectedCategoryId = val),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedSupplierId,
                  decoration: InputDecoration(
                    labelText: 'Supplier',
                    prefixIcon: const Icon(Icons.local_shipping_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _service.deleteProduct(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: StreamBuilder<List<Category>>(
        stream: _service.getCategories(),
        builder: (context, catSnapshot) {
          return StreamBuilder<List<Supplier>>(
            stream: _service.getSuppliers(),
            builder: (context, supSnapshot) {
              return FloatingActionButton.extended(
                onPressed: () => _showForm(
                  context,
                  categories: catSnapshot.data ?? [],
                  suppliers: supSnapshot.data ?? [],
                ),
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              );
            },
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) => setState(() => searchQuery = val.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() {
                                searchController.clear();
                                searchQuery = '';
                              }),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.sort, color: Colors.blue[600]),
                  tooltip: 'Sort',
                  onSelected: (value) {
                    setState(() {
                      if (sortBy == value) {
                        sortAscending = !sortAscending;
                      } else {
                        sortBy = value;
                        sortAscending = true;
                      }
                    });
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'name', child: Row(children: [
                      Icon(sortBy == 'name' ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward) : Icons.sort_by_alpha, size: 18),
                      const SizedBox(width: 8),
                      const Text('Sort by Name'),
                    ])),
                    PopupMenuItem(value: 'price', child: Row(children: [
                      Icon(sortBy == 'price' ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward) : Icons.payments_outlined, size: 18),
                      const SizedBox(width: 8),
                      const Text('Sort by Price'),
                    ])),
                    PopupMenuItem(value: 'quantity', child: Row(children: [
                      Icon(sortBy == 'quantity' ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward) : Icons.numbers_outlined, size: 18),
                      const SizedBox(width: 8),
                      const Text('Sort by Quantity'),
                    ])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _service.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No products yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        Text('Tap + to add a product', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                      ],
                    ),
                  );
                }
                final products = snapshot.data!
                    .where((p) => p.name.toLowerCase().contains(searchQuery))
                    .toList()
                  ..sort((a, b) {
                    int compare;
                    if (sortBy == 'name') {
                      compare = a.name.compareTo(b.name);
                    } else if (sortBy == 'price') {
                      compare = a.price.compareTo(b.price);
                    } else {
                      compare = a.quantity.compareTo(b.quantity);
                    }
                    return sortAscending ? compare : -compare;
                  });
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No results found', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      ],
                    ),
                  );
                }
                return StreamBuilder<List<Category>>(
                  stream: _service.getCategories(),
                  builder: (context, catSnapshot) {
                    return StreamBuilder<List<Supplier>>(
                      stream: _service.getSuppliers(),
                      builder: (context, supSnapshot) {
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: prod.quantity <= 5 ? Colors.red[200]! : Colors.grey[200]!),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: prod.quantity <= 5 ? Colors.red[50] : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.inventory_2, color: prod.quantity <= 5 ? Colors.red[600] : Colors.blue[600], size: 20),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(prod.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                                    if (prod.quantity <= 5)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red[600],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('Low Stock', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Icon(Icons.payments_outlined, size: 12, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text('₱${prod.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                      const SizedBox(width: 12),
                                      Icon(Icons.numbers_outlined, size: 12, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text('Qty: ${prod.quantity}', style: TextStyle(color: prod.quantity <= 5 ? Colors.red[600] : Colors.grey[600], fontSize: 13, fontWeight: prod.quantity <= 5 ? FontWeight.bold : FontWeight.normal)),
                                    ]),
                                    Row(children: [
                                      Icon(Icons.category_outlined, size: 12, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text(category?.name ?? 'N/A', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                      const SizedBox(width: 12),
                                      Icon(Icons.local_shipping_outlined, size: 12, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text(supplier?.name ?? 'N/A', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                    ]),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit_outlined, color: Colors.blue[600], size: 20),
                                      onPressed: () => _showForm(
                                        context,
                                        product: prod,
                                        categories: catSnapshot.data ?? [],
                                        suppliers: supSnapshot.data ?? [],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outlined, color: Colors.red[400], size: 20),
                                      onPressed: () => _confirmDelete(context, prod.id),
                                    ),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}