import 'package:equatable/equatable.dart';
import 'package:human_forces/models/cloth_type_detail_model.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product_list_model.g.dart';

@JsonSerializable()
class ProductListModel extends Equatable {
  final String title;
  final String sub_title;
  final List<ProductModel> products;
  final List<ProductModel> all_products;
  final ClothTypeDetailModel details;
  final bool isFilter;

  final String clothTypeFilter;
  final String colorFilter;
  final String subCategoryFilter;

  const ProductListModel(
      {@required this.isFilter,
      @required this.clothTypeFilter,
      @required this.colorFilter,
      @required this.subCategoryFilter,
      @required this.title,
      @required this.sub_title,
      @required this.all_products,
      @required this.products,
      @required this.details});

  ProductListModel copyWith({
    final bool isFilter,
    final String clothTypeFilter,
    final String colorFilter,
    final String subCategoryFilter,
    final List<ProductModel> products,
  }) {
    return ProductListModel(
      title: this.title,
      sub_title: this.sub_title,
      details: this.details,
      all_products: all_products ?? this.all_products,
      products: products ?? this.products,
      isFilter: isFilter ?? this.isFilter,
      clothTypeFilter: clothTypeFilter ?? this.clothTypeFilter,
      colorFilter: colorFilter ?? this.colorFilter,
      subCategoryFilter: subCategoryFilter ?? this.subCategoryFilter,
    );
  }

  @override
  List<Object> get props => [
        title,
        products,
        details,
        isFilter,
        clothTypeFilter,
        colorFilter,
        subCategoryFilter,
      ];

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListModelToJson(this);
}
