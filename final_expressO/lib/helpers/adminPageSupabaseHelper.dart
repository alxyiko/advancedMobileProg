import 'dart:io';

import 'package:firebase_nexus/adminPages/analyticsVIew.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSupabaseHelper {
  final SupabaseClient client = Supabase.instance.client;

  Future<bool> isConnected() async {
    try {
      final response = await client.from('Products').select().limit(1);
      return response.isNotEmpty;
    } catch (e) {
      print("Connection error: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final response = await client.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("GetAll error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getById(
      String table, String idColumn, dynamic id) async {
    try {
      final response =
          await client.from(table).select().eq(idColumn, id).maybeSingle();
      return response;
    } catch (e) {
      print("GetById error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> insert(
      String table, Map<String, dynamic> data) async {
    try {
      final response = await client.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      print("Insert error: $e");
      return null;
    }
  }

  Future<String?> uploadProductImage(File file, String productID) async {
    final filePath = 'files/$productID.png'; // folder + filename

    try {
      final response = await client.storage
          .from('product_images') // 👈 bucket name
          .upload(filePath, file);

      // Get a public URL if the bucket is public
      final publicUrl =
          client.storage.from('product_images').getPublicUrl(filePath);

      return publicUrl; // return the URL so you can store it in DB
    } on StorageException catch (e) {
      print('Storage error: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> addNewProduct(
    String name,
    String desc,
    String category,
    String stock,
    String cost,
    String cost,

    
    , File file) async {
    try {

        final response = await insert('Products', {product})











      return {
        'success': true,
        'message': 'User logged in successfully!',
      };
    } catch (e) {
      print('Sign-in error: $e');
      return {
        'success': false,
        'message': 'Something went wrong on our end, try again later.',
      };
    }
  }

  Future<Map<String, dynamic>?> update(String table, String idColumn,
      dynamic id, Map<String, dynamic> data) async {
    try {
      final response = await client
          .from(table)
          .update(data)
          .eq(idColumn, id)
          .select()
          .single();
      return response;
    } catch (e) {
      print("Update error: $e");
      return null;
    }
  }

  Future<bool> delete(String table, String idColumn, dynamic id) async {
    try {
      await client.from(table).delete().eq(idColumn, id);
      return true;
    } catch (e) {
      print("Delete error: $e");
      return false;
    }
  }

  RealtimeChannel listenToTable(
    String table, {
    void Function(Map<String, dynamic> payload)? onInsert,
    void Function(Map<String, dynamic> payload)? onUpdate,
    void Function(Map<String, dynamic> payload)? onDelete,
  }) {
    final channel = client.channel('public:$table');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: table,
          callback: (payload) {
            if (onInsert != null) onInsert(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: table,
          callback: (payload) {
            if (onUpdate != null) onUpdate(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: table,
          callback: (payload) {
            if (onDelete != null) onDelete(payload.oldRecord);
          },
        )
        .subscribe();

    return channel;
  }

  void unsubscribe(RealtimeChannel channel) {
    client.removeChannel(channel);
  }
}
