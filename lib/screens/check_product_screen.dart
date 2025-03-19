import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class CheckProductScreen extends StatefulWidget {
  const CheckProductScreen({super.key});

  @override
  State<CheckProductScreen> createState() => _CheckProductScreenState();
}

class _CheckProductScreenState extends State<CheckProductScreen> {
  bool _nfcAvailable = false;
  bool _productFound = false;
  final Map<String, dynamic> _dummyProduct = {
    'name': 'Sample Product',
    'id': '12345',
    'category': 'Electronics',
    'stockCount': 42,
    'lastUpdated': '2024-02-20',
    'description': 'This is a sample product description',
    'imageUrl': 'https://picsum.photos/200',
  };

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
  }

  Future<void> _checkNfcAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    setState(() {
      _nfcAvailable = isAvailable;
    });
    if (isAvailable) {
      _startNfcReading();
    }
  }

  void _startNfcReading() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Simulate finding product with dummy data
      setState(() {
        _productFound = true;
      });
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _productFound ? _buildProductInfo() : _buildScanPrompt(),
      ),
    );
  }

  Widget _buildScanPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_nfcAvailable)
            const Text('NFC is not available on this device')
          else
            const Text(
              'Hold an NFC tag near the device to check product details',
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _dummyProduct['imageUrl'],
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Name', _dummyProduct['name']),
          _buildInfoRow('ID', _dummyProduct['id']),
          _buildInfoRow('Category', _dummyProduct['category']),
          _buildInfoRow('Stock Count', _dummyProduct['stockCount'].toString()),
          _buildInfoRow('Last Updated', _dummyProduct['lastUpdated']),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(_dummyProduct['description']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
