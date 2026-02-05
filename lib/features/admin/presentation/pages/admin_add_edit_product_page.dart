import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';

import 'package:shopsphere/features/admin/data/datasources/admin_remote_data_source.dart';

class AdminAddEditProductPage extends StatefulWidget {
  final dynamic product;
  const AdminAddEditProductPage({super.key, this.product});

  @override
  State<AdminAddEditProductPage> createState() =>
      _AdminAddEditProductPageState();
}

class _AdminAddEditProductPageState extends State<AdminAddEditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController();
  final _desc = TextEditingController();

  String selectedCategory = 'Electronics';

  /// Images
  final List<File> pickedImages = [];
  final List<String> uploadedImages = [];

  bool uploadingImages = false;

  final picker = ImagePicker();
  final remote = AdminRemoteDataSource();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _name.text = widget.product['name'];
      _price.text = widget.product['price'].toString();
      _qty.text = widget.product['quantity'].toString();
      _desc.text = widget.product['description'] ?? '';
      selectedCategory = widget.product['category'];
      uploadedImages.addAll(
        List<String>.from(widget.product['images'] ?? []),
      );
    }
  }

  Future<void> pickImages() async {
    final images = await picker.pickMultiImage(imageQuality: 75);
    if (images.isEmpty) return;

    setState(() {
      pickedImages.addAll(images.map((e) => File(e.path)));
    });
  }

  Future<void> uploadImages() async {
    if (pickedImages.isEmpty) return;

    setState(() => uploadingImages = true);

    final urls = await remote.uploadImagesPublic(images: pickedImages);

    uploadedImages.addAll(urls);
    pickedImages.clear();

    setState(() => uploadingImages = false);
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (pickedImages.isNotEmpty) {
      await uploadImages();
    }

    if (widget.product == null) {
      context.read<AdminBloc>().add(
        AddProduct(
          name: _name.text.trim(),
          description: _desc.text.trim(),
          category: selectedCategory,
          price: double.parse(_price.text),
          quantity: int.parse(_qty.text),
          images: uploadedImages,
        ),
      );
    } else {
      context.read<AdminBloc>().add(
        UpdateProduct(
          id: widget.product['id'],
          name: _name.text.trim(),
          description: _desc.text.trim(),
          category: selectedCategory,
          price: double.parse(_price.text),
          quantity: int.parse(_qty.text),
          images: uploadedImages,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null
            ? 'Add New Product'
            : 'Edit Product'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminProductSaved) {
            Navigator.pop(context);
          }
          if (state is AdminProductError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final saving = state is AdminProductSaving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ─── IMAGES ───
                  Text('Product Images',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...uploadedImages.map(
                            (url) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ...pickedImages.map(
                            (file) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add, color: Colors.teal),
                        ),
                      ),
                    ],
                  ),

                  if (uploadingImages)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),

                  const SizedBox(height: 24),

                  /// ─── BASIC INFO ───
                  TextFormField(
                    controller: _name,
                    decoration:
                    const InputDecoration(labelText: 'Product Name'),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _price,
                          decoration:
                          const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _qty,
                          decoration:
                          const InputDecoration(labelText: 'Stock Qty'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration:
                    const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Electronics', child: Text('Electronics')),
                      DropdownMenuItem(
                          value: 'Fashion', child: Text('Fashion')),
                      DropdownMenuItem(
                          value: 'Books', child: Text('Books')),
                    ],
                    onChanged: (v) =>
                        setState(() => selectedCategory = v!),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _desc,
                    decoration:
                    const InputDecoration(labelText: 'Description'),
                    maxLines: 4,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),

                  /// ─── SAVE ───
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: saving || uploadingImages ? null : _save,
                      child: saving
                          ? const CircularProgressIndicator()
                          : const Text('Save Product'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
