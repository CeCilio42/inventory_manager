import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _nfcData = 'No NFC tag detected';
  bool _nfcAvailable = false;
  final TextEditingController _nameController = TextEditingController();
  File? _image;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _startNfcReading() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        _nfcData = tag.data.toString();
      });
      _showFormDialog(tag.data.toString());
    });
  }

  Future<void> _showFormDialog(String nfcData) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('NFC Tag Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('NFC Data: $nfcData'),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Image.file(_image!, height: 100),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle save logic here
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
        title: const Text('Add Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_nfcAvailable)
              const Text('NFC is not available on this device')
            else
              const Text('Hold an NFC tag near the device'),
            const SizedBox(height: 20),
            Text(
              _nfcData,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
