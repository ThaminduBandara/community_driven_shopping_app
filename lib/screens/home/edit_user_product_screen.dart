import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/product.dart';

class EditUserProductScreen extends StatefulWidget {
  final Product product;

  const EditUserProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditUserProductScreen> createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _warrantyController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _categoryController;
  late TextEditingController _shopNameController;
  late TextEditingController _shopAddressController;
  late TextEditingController _shopTownController;
  late TextEditingController _customerServiceController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _warrantyController =
        TextEditingController(text: widget.product.warranty.toString());
    _brandController = TextEditingController(text: widget.product.brand);
    _modelController = TextEditingController(text: widget.product.model);
    _categoryController = TextEditingController(text: widget.product.category);
    _shopNameController = TextEditingController(text: widget.product.shopName);
    _shopAddressController =
        TextEditingController(text: widget.product.shopAddress);
    _shopTownController = TextEditingController(text: widget.product.shopTown);
    _customerServiceController =
        TextEditingController(text: widget.product.customerService);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _warrantyController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _categoryController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopTownController.dispose();
    _customerServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Edit Product'),
          backgroundColor: Colors.transparent,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Product Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                // Product Image Preview
                if (widget.product.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.images[0].url,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[800],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                // Product Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  icon: Icons.shopping_bag,
                ),
                const SizedBox(height: 16),
                // Category and Brand Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _categoryController,
                        label: 'Category',
                        icon: Icons.category,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _brandController,
                        label: 'Brand',
                        icon: Icons.business,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Model and Price Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _modelController,
                        label: 'Model',
                        icon: Icons.devices,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: 'Price (LKR)',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Warranty and Customer Service Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _warrantyController,
                        label: 'Warranty (months)',
                        icon: Icons.shield,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _customerServiceController,
                        label: 'Customer Service',
                        icon: Icons.support_agent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Shop Name
                _buildTextField(
                  controller: _shopNameController,
                  label: 'Shop Name',
                  icon: Icons.store,
                ),
                const SizedBox(height: 16),
                // Shop Address
                _buildTextField(
                  controller: _shopAddressController,
                  label: 'Shop Address',
                  icon: Icons.location_on,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                // Shop Town
                _buildTextField(
                  controller: _shopTownController,
                  label: 'Town/City',
                  icon: Icons.location_city,
                ),
                const SizedBox(height: 32),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _updateProduct,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: !_isLoading,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _warrantyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      widget.product.name = _nameController.text;
      widget.product.price = double.parse(_priceController.text);
      widget.product.warranty = int.parse(_warrantyController.text);
      widget.product.brand = _brandController.text;
      widget.product.model = _modelController.text;
      widget.product.category = _categoryController.text;
      widget.product.shopName = _shopNameController.text;
      widget.product.shopAddress = _shopAddressController.text;
      widget.product.shopTown = _shopTownController.text;
      widget.product.customerService = _customerServiceController.text;

      await widget.product.updateProduct();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
