// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_type_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothTypeDetailModel _$ClothTypeDetailModelFromJson(Map<String, dynamic> json) {
  return ClothTypeDetailModel(
    colors: (json['colors'] as List)?.map((e) => e as String)?.toList(),
    categories: json['categories'],
  );
}

Map<String, dynamic> _$ClothTypeDetailModelToJson(
        ClothTypeDetailModel instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'categories': instance.categories,
    };
