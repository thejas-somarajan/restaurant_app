import 'dart:developer' as developer;

import 'package:get/get.dart';
import '../models/food_item.dart';
import '../services/supabase_service.dart';

class FoodItemController extends GetxController {
  final SupabaseService service;

  FoodItemController({required this.service});

  final RxList<FoodItem> items = <FoodItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    errorMessage.value = '';
    developer.log('=== fetchItems() called ===', name: 'FoodItemController');
    try {
      final result = await service.fetchItems();
      developer.log(
        'Fetched ${result.length} item(s) from food_items table.',
        name: 'FoodItemController',
      );
      if (result.isEmpty) {
        developer.log(
          'WARNING: No items returned. Check Supabase anonKey, RLS policies, and table data.',
          name: 'FoodItemController',
        );
      } else {
        for (final item in result) {
          developer.log(
            '[Item] id=${item.id} | name=${item.name} | price=${item.price} | type=${item.type} | qty=${item.quantity}',
            name: 'FoodItemController',
          );
        }
      }
      items.assignAll(result);
    } catch (e, stackTrace) {
      developer.log(
        'ERROR fetching items: $e',
        name: 'FoodItemController',
        error: e,
        stackTrace: stackTrace,
      );
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(
      String name, double price, String type, int quantity) async {
    if (validateName(name) != null ||
        validatePrice(price) != null ||
        validateQuantity(quantity) != null) {
      return;
    }
    final item = FoodItem(
      id: '',
      name: name,
      price: price,
      type: type,
      quantity: quantity,
      updatedAt: DateTime.now(),
    );
    try {
      await service.addItem(item);
      await fetchItems();
      Get.snackbar('Success', 'Item added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateItem(
      String id, String name, double price, String type, int quantity) async {
    if (validateName(name) != null ||
        validatePrice(price) != null ||
        validateQuantity(quantity) != null) {
      return;
    }
    final item = FoodItem(
      id: id,
      name: name,
      price: price,
      type: type,
      quantity: quantity,
      updatedAt: DateTime.now(),
    );
    try {
      await service.updateItem(item);
      await fetchItems();
      Get.snackbar('Success', 'Item updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await service.deleteItem(id);
      await fetchItems();
      Get.snackbar('Success', 'Item deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? validatePrice(double? value) {
    if (value == null || value <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  String? validateQuantity(int? value) {
    if (value == null || value < 0) {
      return 'Quantity cannot be negative';
    }
    return null;
  }
}
