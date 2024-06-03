import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_btl/models/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class API {
  //--- Supabase -----
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

  //--- firebase ----
  Future<String> getUrlImageFuture(String uid) async {
    if (uid == '') {
      return '';
    }
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    final isNewUser = data['image'];
    return isNewUser;
  }

  Stream<String> getImageUrlStream(String uid) {
    if (uid == '') {
      return Stream.value('');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data['image'] == 'null') {
        return '';
      } else {
        return data['image'];
      }
    });
  }
}
