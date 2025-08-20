import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getproductsItems() async {
    final response = await client.from('products').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> isConnected() async {
    try {
      // Try a "ping" request - list tables, RPC, or something public
      final response = await client
          .from('products') // pick a table with RLS = "true" or anon readable
          .select();
          // .limit(1);
      print('Sige');
      print(response);
      return response.isNotEmpty; // ✅ Means Supabase responded
    } catch (e) {
      print("Connection error: $e");
      return false;
    }
  }
}
