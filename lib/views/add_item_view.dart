import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_item_controller.dart';

class AddItemView extends StatefulWidget {
  const AddItemView({super.key});

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedType = 'veg';

  final FoodItemController _controller = Get.find<FoodItemController>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final quantity = int.parse(_quantityController.text.trim());
      _controller.addItem(name, price, _selectedType, quantity);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) => _controller.validateName(value),
              ),
              const SizedBox(height: 16),
              // Price field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  return _controller.validatePrice(parsed);
                },
              ),
              const SizedBox(height: 16),
              // Type selector
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'veg', child: Text('Veg')),
                  DropdownMenuItem(value: 'non-veg', child: Text('Non-Veg')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Quantity field
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  return _controller.validateQuantity(parsed);
                },
              ),
              const SizedBox(height: 32),
              // Submit button
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
