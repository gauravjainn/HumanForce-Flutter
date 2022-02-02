import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final bool isUserLoggedIn;
  final String id;
  final String name;
  final String bond;
  final String customer_id;
  final String joined_from;
  final String retailer_id;
  final String shop_name;
  final String sellerId;
  final String address;
  final String pincode;
  final String mobile_number;
  final List<String> all_orders;

  const UserModel(
      {@required this.isUserLoggedIn,
      @required this.id,
      @required this.name,
      @required this.bond,
      @required this.customer_id,
      @required this.joined_from,
      @required this.retailer_id,
      @required this.shop_name,
      @required this.sellerId,
      @required this.address,
      @required this.pincode,
      @required this.all_orders,
      @required this.mobile_number});

  @override
  List<Object> get props => [
        isUserLoggedIn,
        id,
        name,
        bond,
        customer_id,
        joined_from,
        retailer_id,
        shop_name,
        sellerId
      ];

  UserModel copyWith({@required List<String> all_orders}) {
    return UserModel(
      isUserLoggedIn: this.isUserLoggedIn,
      id: this.id,
      name: this.name,
      bond: this.bond,
      customer_id: this.customer_id,
      joined_from: this.joined_from,
      retailer_id: this.retailer_id,
      shop_name: this.shop_name,
      sellerId: this.sellerId,
      address: this.address,
      pincode: this.pincode,
      mobile_number: this.mobile_number,
      all_orders: all_orders ?? this.all_orders,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
