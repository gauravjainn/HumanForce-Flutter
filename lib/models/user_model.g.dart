// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    isUserLoggedIn: json['isUserLoggedIn'] as bool,
    id: json['id'] as String,
    name: json['name'] as String,
    bond: json['bond'] as String,
    customer_id: json['customer_id'] as String,
    joined_from: json['joined_from'] as String,
    retailer_id: json['retailer_id'] as String,
    shop_name: json['shop_name'] as String,
    sellerId: json['sellerId'] as String,
    address: json['address'] as String,
    pincode: json['pincode'] as String,
    all_orders: (json['all_orders'] as List)?.map((e) => e as String)?.toList(),
    mobile_number: json['mobile_number'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'isUserLoggedIn': instance.isUserLoggedIn,
      'id': instance.id,
      'name': instance.name,
      'bond': instance.bond,
      'customer_id': instance.customer_id,
      'joined_from': instance.joined_from,
      'retailer_id': instance.retailer_id,
      'shop_name': instance.shop_name,
      'sellerId': instance.sellerId,
      'address': instance.address,
      'pincode': instance.pincode,
      'mobile_number': instance.mobile_number,
      'all_orders': instance.all_orders,
    };
