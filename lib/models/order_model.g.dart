// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map json) {
  return OrderModel(
    status: json['status'] as String,
    id: json['id'] as String,
    delivery_date: json['delivery_date'] as String,
    user_id: json['user_id'] as String,
    order_date: json['order_date'] as String,
    transaction_id: json['transaction_id'] as String,
    total_amount: json['total_amount'] as String,
    products: (json['products'] as List)
        ?.map((e) => e == null ? null : ProductModel.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'products': instance.products?.map((e) => e?.toJson())?.toList(),
      'status': instance.status,
      'user_id': instance.user_id,
      'delivery_date': instance.delivery_date,
      'order_date': instance.order_date,
      'transaction_id': instance.transaction_id,
      'total_amount': instance.total_amount,
    };
