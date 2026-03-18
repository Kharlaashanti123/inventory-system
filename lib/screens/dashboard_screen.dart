import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class DashboardScreen extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back! 👋', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'User',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Inventory System', style: TextStyle(color: Colors.blue[100], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _service.getProducts(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _SummaryCard(
                        title: 'Products',
                        count: count,
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StreamBuilder(
                    stream: _service.getCategories(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _SummaryCard(
                        title: 'Categories',
                        count: count,
                        icon: Icons.category,
                        color: Colors.green,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _service.getSuppliers(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _SummaryCard(
                        title: 'Suppliers',
                        count: count,
                        icon: Icons.local_shipping,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StreamBuilder(
                    stream: _service.getProducts(),
                    builder: (context, snapshot) {
                      final lowStock = snapshot.data?.where((p) => p.quantity <= 5).length ?? 0;
                      return _SummaryCard(
                        title: 'Low Stock',
                        count: lowStock,
                        icon: Icons.warning_amber,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Low Stock Alert
            StreamBuilder(
              stream: _service.getProducts(),
              builder: (context, snapshot) {
                final lowStockItems = snapshot.data?.where((p) => p.quantity <= 5).toList() ?? [];
                if (lowStockItems.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.red[600], size: 18),
                        const SizedBox(width: 6),
                        const Text('Low Stock Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...lowStockItems.map((prod) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2, color: Colors.red[600], size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(prod.name, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red[700]))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Qty: ${prod.quantity}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final MaterialColor color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color[600], size: 20),
          ),
          const SizedBox(height: 12),
          Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }
}