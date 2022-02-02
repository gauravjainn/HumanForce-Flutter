// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListModel _$ProductListModelFromJson(Map<String, dynamic> json) {
  return ProductListModel(
    isFilter: json['isFilter'] as bool,
    clothTypeFilter: json['clothTypeFilter'] as String,
    colorFilter: json['colorFilter'] as String,
    subCategoryFilter: json['subCategoryFilter'] as String,
    title: json['title'] as String,
    sub_title: json['sub_title'] as String,
    all_products: (json['all_products'] as List)
        ?.map((e) =>
            e == null ? null : ProductModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : ProductModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    details: json['details'] == null
        ? null
        : ClothTypeDetailModel.fromJson(
            json['details'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductListModelToJson(ProductListModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'sub_title': instance.sub_title,
      'products': instance.products,
      'all_products': instance.all_products,
      'details': instance.details,
      'isFilter': instance.isFilter,
      'clothTypeFilter': instance.clothTypeFilter,
      'colorFilter': instance.colorFilter,
      'subCategoryFilter': instance.subCategoryFilter,
    };
