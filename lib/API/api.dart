import 'package:flutter_btl/models/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class API {
  Stream<List<Item>> getListItem() async* {
    final supabaseClient = Supabase.instance.client;
    final addressStream = supabaseClient.from('items').stream(primaryKey: [
      'id'
    ]).map((listData) => listData.map((e) => Item.fromJson(e)).toList());

    yield* addressStream;
  }

  Future<void> addItem(Item item) async {
    await Supabase.instance.client.from('items').insert({
      'name': item.name,
      'email': item.email,
      'address': item.address,
      'createdAt': item.createdAt,
    });
  }

  Future<void> updateItem(Item item) async {
    await Supabase.instance.client.from('items').update({
      'name': item.name,
      'email': item.email,
      'address': item.address,
      'createdAt': item.createdAt,
    }).match({'id': item.id});
  }

  Future<void> deleteItem(int id) async {
    await Supabase.instance.client.from('items').delete().eq('id', '$id');
  }
}
