// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map json) {
  $checkKeys(json, disallowNullValues: const [
    'price_batches',
    'price_size',
    'category',
    'id',
    'description',
    'color',
    'size',
    'batches',
    'min_quantity'
  ]);
  return ProductModel(
    quantity_batches: json['quantity_batches'] as int,
    quantity_size: json['quantity_size'] as int,
    selectedColor: json['selectedColor'],
    selectedSize: json['selectedSize'] as String,
    orderType: _$enumDecodeNullable(_$OrderTypeEnumMap, json['orderType']),
    id: ProductModel._checkStringNull(json['id'] as String),
    price_batches:
        ProductModel._checkStringNull(json['price_batches'] as String),
    price_size: ProductModel._checkStringNull(json['price_size'] as String),
    description: ProductModel._checkStringNull(json['description'] as String),
    size: ProductModel._checkBatchesAndSizeList(json['size'] as List),
    category: ProductModel._checkStringNull(json['category'] as String),
    image: (json['image'] as List)?.map((e) => e as String)?.toList(),
    color: ProductModel._checkColorList(json['color'] as List),
    batches: ProductModel._checkBatchesAndSizeList(json['batches'] as List),
    sub_category: json['sub_category'] as String,
    min_quantity: json['min_quantity'] as int,
    reviews: json['reviews'] as List,
    review: json['review'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('price_batches', instance.price_batches);
  writeNotNull('price_size', instance.price_size);
  writeNotNull('category', instance.category);
  writeNotNull('id', instance.id);
  writeNotNull('description', instance.description);
  val['image'] = instance.image;
  writeNotNull('color', instance.color);
  writeNotNull('size', instance.size);
  writeNotNull('batches', instance.batches);
  val['name'] = instance.name;
  val['sub_category'] = instance.sub_category;
  writeNotNull('min_quantity', instance.min_quantity);
  val['quantity_batches'] = instance.quantity_batches;
  val['quantity_size'] = instance.quantity_size;
  val['selectedColor'] = instance.selectedColor;
  val['selectedSize'] = instance.selectedSize;
  val['orderType'] = _$OrderTypeEnumMap[instance.orderType];
  val['review'] = instance.review;
  val['reviews'] = instance.reviews;
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$OrderTypeEnumMap = {
  OrderType.batches: 'batches',
  OrderType.size: 'size',
};
