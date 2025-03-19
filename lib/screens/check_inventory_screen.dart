import 'package:flutter/material.dart';

class CheckInventoryScreen extends StatefulWidget {
  const CheckInventoryScreen({super.key});

  @override
  State<CheckInventoryScreen> createState() => _CheckInventoryScreenState();
}

class _CheckInventoryScreenState extends State<CheckInventoryScreen> {
  final List<Map<String, dynamic>> _dummyInventory = [
    {
      'name': 'Laptop',
      'id': '12345',
      'category': 'Electronics',
      'stockCount': 42,
      'imageUrl': 'https://picsum.photos/200',
    },
    {
      'name': 'Smartphone',
      'id': '67890',
      'category': 'Electronics',
      'stockCount': 28,
      'imageUrl': 'https://picsum.photos/201',
    },
    {
      'name': 'Headphones',
      'id': '11223',
      'category': 'Accessories',
      'stockCount': 15,
      'imageUrl': 'https://picsum.photos/202',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _dummyInventory.length,
        itemBuilder: (context, index) {
          final product = _dummyInventory[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  product['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('ID: ${product['id']}'),
                  Text('Category: ${product['category']}'),
                  Text('In Stock: ${product['stockCount']}'),
                ],
              ),
              onTap: () {
                // TODO: Navigate to detailed view if needed
              },
            ),
          );
        },
      ),
    );
  }
}
