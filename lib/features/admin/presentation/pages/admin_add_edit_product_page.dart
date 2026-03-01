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
  State<AdminAddEditProductPage> createState() => _AdminAddEditProductPageState();
}

class _AdminAddEditProductPageState extends State<AdminAddEditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController();
  final _desc = TextEditingController();
  final _sku = TextEditingController();

  String selectedCategory = 'Electronics';

  final List<File> pickedImages = [];
  final List<String> uploadedImages = [];

  bool uploadingImages = false;
  bool publishImmediately = true;
  bool featuredProduct = false;

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
      _sku.text = widget.product['sku']?.toString() ?? '';
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
      backgroundColor: const Color(0xFFF2F3F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.product == null ? 'Add New Product' : 'Edit Product', style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Center(child: Text('Draft', style: TextStyle(color: Color(0xFF19C8DC), fontSize: 18, fontWeight: FontWeight.w500))))],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminProductSaved) {
            Navigator.pop(context);
          }
          if (state is AdminProductError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                  const Text('Product Images', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32 / 2)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 38),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD0D5DD), style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Color(0xFFD8F5F9),
                            child: Icon(Icons.cloud_upload_rounded, color: Color(0xFF19C8DC), size: 30),
                          ),
                          SizedBox(height: 14),
                          Text('Upload main product photo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                          SizedBox(height: 6),
                          Text('Drag and drop or click to upload (max 5MB)', style: TextStyle(color: Color(0xFF667084))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...uploadedImages.map((url) => _PreviewImage.network(url, onDelete: () => setState(() => uploadedImages.remove(url)))),
                      ...pickedImages.map((file) => _PreviewImage.file(file, onDelete: () => setState(() => pickedImages.remove(file)))),
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD0D5DD)),
                          ),
                          child: const Icon(Icons.add, color: Color(0xFF19C8DC)),
                        ),
                      ),
                    ],
                  ),
                  if (uploadingImages)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 26),
                  const Text('Basic Information', style: TextStyle(fontSize: 34 / 2, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _styledField(
                    controller: _name,
                    hint: 'e.g. Premium Wireless Headphones',
                    label: 'Product Name',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _styledField(
                          controller: _sku,
                          hint: 'WH-001',
                          label: 'SKU',
                          validator: (_) => null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: _inputDecoration('Category'),
                          items: const [
                            DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                            DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
                            DropdownMenuItem(value: 'Books', child: Text('Books')),
                            DropdownMenuItem(value: 'Essentials', child: Text('Essentials')),
                          ],
                          onChanged: (v) => setState(() => selectedCategory = v ?? selectedCategory),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _styledField(
                          controller: _price,
                          hint: '0.00',
                          label: 'Price',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _styledField(
                          controller: _qty,
                          hint: '0',
                          label: 'Stock Quantity',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Product Description', style: TextStyle(fontSize: 34 / 2, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _desc,
                    maxLines: 6,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    decoration: _inputDecoration('Describe your product here...'),
                  ),
                  const SizedBox(height: 14),
                  _toggleTile(
                    title: 'Publish Immediately',
                    subtitle: 'Make this product live after saving',
                    value: publishImmediately,
                    onChanged: (v) => setState(() => publishImmediately = v),
                  ),
                  const SizedBox(height: 10),
                  _toggleTile(
                    title: 'Featured Product',
                    subtitle: 'Show in home screen recommendations',
                    value: featuredProduct,
                    onChanged: (v) => setState(() => featuredProduct = v),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BC8DE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: saving || uploadingImages ? null : _save,
                      child: saving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Product', style: TextStyle(fontSize: 24 / 1.3, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _styledField({
    required TextEditingController controller,
    required String hint,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      decoration: _inputDecoration(hint).copyWith(labelText: label),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
    );
  }

  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667084))),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF1BC8DE),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;

  const _PreviewImage._({required this.child, required this.onDelete});

  factory _PreviewImage.network(String url, {required VoidCallback onDelete}) {
    return _PreviewImage._(
      onDelete: onDelete,
      child: Image.network(url, fit: BoxFit.cover, width: 74, height: 74),
    );
  }

  factory _PreviewImage.file(File file, {required VoidCallback onDelete}) {
    return _PreviewImage._(
      onDelete: onDelete,
      child: Image.file(file, fit: BoxFit.cover, width: 74, height: 74),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
        Positioned(
          right: -8,
          top: -8,
          child: IconButton(
            constraints: const BoxConstraints(),
            icon: const CircleAvatar(radius: 10, child: Icon(Icons.close, size: 12)),
            onPressed: onDelete,
          ),
        )
      ],
    );
  }
}
