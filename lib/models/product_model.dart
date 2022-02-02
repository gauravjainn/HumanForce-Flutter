import 'package:equatable/equatable.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product_model.g.dart';

@JsonSerializable(
  anyMap: true,
)
class ProductModel extends Equatable {
  @JsonKey(ignore: true)
  final String dbPath;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkStringNull,
  )
  final String price_batches;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkStringNull,
  )
  final String price_size;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkStringNull,
  )
  final String category;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkStringNull,
  )
  final String id;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkStringNull,
  )
  final String description;

  final List<String> image;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkColorList,
  )
  final List<dynamic> color;
  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkBatchesAndSizeList,
  )
  final List<dynamic> size;

  @JsonKey(
    disallowNullValue: true,
    fromJson: _checkBatchesAndSizeList,
  )
  final List<dynamic> batches;
  final String name;
  final String sub_category;
  @JsonKey(
    disallowNullValue: true,
  )
  final int min_quantity;

  final int quantity_batches;
  final int quantity_size;
  final dynamic selectedColor;
  final String selectedSize;
  final OrderType orderType;
  final String review;
  final List<dynamic> reviews;

  ProductModel(
      {@required this.dbPath,
      @required this.quantity_batches,
      @required this.quantity_size,
      @required this.selectedColor,
      @required this.selectedSize,
      @required this.orderType,
      @required this.id,
      @required this.price_batches,
      @required this.price_size,
      @required this.description,
      @required this.size,
      @required this.category,
      @required this.image,
      @required this.color,
      @required this.batches,
      @required this.sub_category,
      @required this.min_quantity,
      @required this.reviews,
      this.review = "",
      @required this.name});

  @override
  List<Object> get props => [
        id,
        selectedColor,
        selectedSize,
        price_batches,
        price_size,
        image,
        name,
        category,
        sub_category,
      ];

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith(
      {final String dbPath,
      final int quantity_batches,
      final int quantity_size,
      final dynamic selectedColor,
      final String selectedSize,
      final String review,
      final OrderType orderType,
      final List<dynamic> batches,
      final List<dynamic> size}) {
    return ProductModel(
        name: this.name,
        id: this.id,
        sub_category: this.sub_category,
        image: this.image,
        price_batches: this.price_batches,
        price_size: this.price_size,
        color: this.color,
        min_quantity: this.min_quantity,
        category: this.category,
        description: this.description,
        reviews: this.reviews,
        dbPath: dbPath ?? this.dbPath,
        size: size ?? this.size,
        batches: batches ?? this.batches,
        review: review ?? this.review,
        quantity_size: quantity_size ?? this.quantity_size,
        quantity_batches: quantity_batches ?? this.quantity_batches,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedSize: selectedSize ?? this.selectedSize,
        orderType: orderType ?? this.orderType);
  }

  static _checkStringNull(String value) {
    if (value != null) {
      if (value.isNotEmpty) {
        return value;
      }
      throw Exception();
    }
    throw Exception();
  }

  static RegExp colorRegex = RegExp(r'^([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  static List<dynamic> _checkBatchesAndSizeList(List<dynamic> value) {
    if (value != null) {
      if (value.isNotEmpty) {
        for (var item in value) {
          if (item['name'] == null ||
              item['quantity'] == null ||
              item['name'] == "" ||
              item['quantity'] == "") {
            throw Exception();
          }
        }
        return value;
      }
      throw Exception();
    }
    throw Exception();
  }

  static List<dynamic> _checkColorList(List<dynamic> value) {
    if (value != null) {
      if (value.isNotEmpty) {
        for (var item in value) {
          if (item['name'] == null ||
              item['color'] == null ||
              item['name'] == "" ||
              !colorRegex.hasMatch(item['color'])) {
            throw Exception();
          }
        }
        return value;
      }
      throw Exception();
    }
    throw Exception();
  }

  static _checkNullList(List<String> value) {
    if (value != null) {
      if (value.isNotEmpty) {
        return value;
      }
      throw Exception();
    }
    throw Exception();
  }
}
