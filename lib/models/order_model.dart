import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderModel extends Equatable {
  final String id;
  final List<ProductModel> products;
  final String status;
  final String user_id;
  final String delivery_date;
  final String order_date;
  final String transaction_id;
  final String total_amount;

  OrderModel(
      {@required this.status,
      @required this.id,
      @required this.delivery_date,
      @required this.user_id,
      @required this.order_date,
      @required this.transaction_id,
      @required this.total_amount,
      @required this.products});

  OrderModel copyWith({
    final String id,
  }) {
    return OrderModel(
      status: this.status,
      delivery_date: this.delivery_date,
      user_id: this.user_id,
      order_date: this.order_date,
      transaction_id: this.transaction_id,
      total_amount: this.total_amount,
      products: this.products,
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props =>
      [id, status, delivery_date, order_date, transaction_id, products];

  factory OrderModel.fromJson(Map<dynamic, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
