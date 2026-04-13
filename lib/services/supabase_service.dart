import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  Future<List<FoodItem>> fetchItems() async {
    developer.log('Querying food_items table...', name: 'SupabaseService');
    final response = await _client
        .from('food_items')
        .select()
        .order('created_at', ascending: false);
    developer.log(
      'Raw response from Supabase: $response',
      name: 'SupabaseService',
    );
    final items = (response as List).map((e) => FoodItem.fromJson(e)).toList();
    developer.log(
      'Parsed ${items.length} FoodItem(s) successfully.',
      name: 'SupabaseService',
    );
    return items;
  }

  Future<void> addItem(FoodItem item) async {
    await _client.from('food_items').insert(item.toJson());
  }

  Future<void> updateItem(FoodItem item) async {
    await _client
        .from('food_items')
        .update(item.toJson())
        .eq('id', item.id);
  }

  Future<void> deleteItem(String id) async {
    await _client.from('food_items').delete().eq('id', id);
  }
}
