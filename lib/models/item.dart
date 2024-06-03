class Item {
  late int id;
  late String name;
  late String email;
  late String address;
  late String createdAt;
  Item({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.createdAt,
  });
  Item.itinial() {
    id = -1;
    name = '';
    email = '';
    address = '';
    createdAt = '';
  }
  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    address = json['address'] ?? '';
    createdAt = json['createdAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['address'] = address;
    data['createdAt'] = createdAt;

    return data;
  }
}
