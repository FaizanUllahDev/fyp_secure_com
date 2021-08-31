import 'dart:convert';

class FriendsModel {
  String name;
  String phone;
  String _status;
  String role;
  bool isSelected;

  String get status => this._status;

  set status(String value) => this._status = value;

  FriendsModel(this.name, this.phone, this._status, this.role, this.isSelected);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      '_status': _status,
      'role': role,
      'isSelected': isSelected,
    };
  }

  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      map['name'],
      map['phone'],
      map['_status'],
      map['role'],
      map['isSelected'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendsModel.fromJson(String source) =>
      FriendsModel.fromMap(json.decode(source));
}
