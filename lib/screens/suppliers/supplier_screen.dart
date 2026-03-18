import 'package:flutter/material.dart';
import '../../models/supplier.dart';
import '../../services/firestore_service.dart';

class SupplierScreen extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  SupplierScreen({super.key});

  void _showForm(BuildContext context, {Supplier? supplier}) {
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final contactController = TextEditingController(text: supplier?.contact ?? '');
    final emailController = TextEditingController(text: supplier?.email ?? '');
    final addressController = TextEditingController(text: supplier?.address ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact Number')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final sup = Supplier(
                id: supplier?.id ?? '',
                name: nameController.text,
                contact: contactController.text,
                email: emailController.text,
                address: addressController.text,
              );
              if (supplier == null) {
                _service.addSupplier(sup);
              } else {
                _service.updateSupplier(sup);
              }
              Navigator.pop(context);
            },
            child: Text(supplier == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: const Text('Are you sure you want to delete this supplier?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _service.deleteSupplier(id);
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
      appBar: AppBar(title: const Text('Suppliers')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Supplier>>(
        stream: _service.getSuppliers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No suppliers yet.'));
          }
          final suppliers = snapshot.data!;
          return ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final sup = suppliers[index];
              return ListTile(
                title: Text(sup.name),
                subtitle: Text('${sup.contact} • ${sup.email}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(context, supplier: sup)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(context, sup.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}