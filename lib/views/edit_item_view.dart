import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_item_controller.dart';
import '../models/food_item.dart';

class EditItemView extends StatefulWidget {
  const EditItemView({super.key});

  @override
  State<EditItemView> createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late String _selectedType;
  late final FoodItem _item;

  final FoodItemController _controller = Get.find<FoodItemController>();

  @override
  void initState() {
    super.initState();
    _item = Get.arguments as FoodItem;
    _nameController = TextEditingController(text: _item.name);
    _priceController = TextEditingController(text: _item.price.toString());
    _quantityController = TextEditingController(text: _item.quantity.toString());
    _selectedType = _item.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final quantity = int.parse(_quantityController.text.trim());
      _controller.updateItem(_item.id, name, price, _selectedType, quantity);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ID field (read-only)
              TextFormField(
                initialValue: _item.id,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'ID',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(height: 16),
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
              // Save button
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
