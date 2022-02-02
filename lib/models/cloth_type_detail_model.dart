import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloth_type_detail_model.g.dart';

@JsonSerializable()
class ClothTypeDetailModel extends Equatable {
  final List<String> colors;
  final dynamic categories;

  const ClothTypeDetailModel(
      {@required this.colors, @required this.categories});
  @override
  List<Object> get props => [];

  factory ClothTypeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ClothTypeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClothTypeDetailModelToJson(this);
}
