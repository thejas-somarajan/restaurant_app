import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/food_item_controller.dart';
import 'services/supabase_service.dart';
import 'views/dashboard_view.dart';
import 'views/add_item_view.dart';
import 'views/edit_item_view.dart';

// Credentials are injected at build time via --dart-define.
// Run with: flutter run --dart-define-from-file=.env
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  assert(_supabaseUrl.isNotEmpty, 'SUPABASE_URL is not set. Run with --dart-define-from-file=.env');
  assert(_supabaseAnonKey.isNotEmpty, 'SUPABASE_ANON_KEY is not set. Run with --dart-define-from-file=.env');

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  Get.put(
    FoodItemController(
      service: SupabaseService(Supabase.instance.client),
    ),
  );

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Food Items',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const DashboardView()),
        GetPage(name: '/add', page: () => const AddItemView()),
        GetPage(name: '/edit', page: () => const EditItemView()),
      ],
    );
  }
}
