class AddressModelFields {
  static const String id = "_id";
  static const String tableName = "tables";
  static const String address = "address";
  static const String lat = "lat";
  static const String long = "long";
}

class AddressModel {
  int? id;
  final String address;
  final String lat;
  final String long;

  AddressModel({this.id,required this.address, required this.lat, required this.long});


  AddressModel copyWith({
    String? address,
    String? lat,
    String? long,
    int? id,
  }) {
    return AddressModel(
      address: address ?? this.address,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      id: id ?? this.id,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      id: json[AddressModelFields.id] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AddressModelFields.address: address,
      AddressModelFields.lat: lat,
      AddressModelFields.long: long,
    };
  }
}
