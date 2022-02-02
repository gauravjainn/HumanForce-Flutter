import 'package:human_forces/models/product_model.dart';

enum OrderType { batches, size }

class ProductSelectorModel {
  OrderType orderType;
  dynamic selectedColor;
  int quantity_batches;
  int quantity_size;
  String selectedSizes;
  ProductModel productModel;
  String catergory;
  String sub_catergory;

  ProductSelectorModel({
    this.selectedColor,
    this.productModel,
    this.quantity_batches,
    this.quantity_size,
    this.selectedSizes,
    this.orderType,
    this.catergory,
    this.sub_catergory,
  });

  ProductSelectorModel copyWith({
    final int quantity_batches,
    final int quantity_size,
    final dynamic selectedColor,
    final String selectedSizes,
    final OrderType orderType,
  }) {
    return ProductSelectorModel(
      productModel: this.productModel,
      quantity_size: quantity_size ?? this.quantity_size,
      quantity_batches: quantity_batches ?? this.quantity_batches,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      orderType: orderType ?? this.orderType,
      catergory: catergory ?? this.catergory,
      sub_catergory: sub_catergory ?? this.sub_catergory,
    );
  }
}
