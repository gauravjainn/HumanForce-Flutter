import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel extends Equatable {
  final Map<dynamic, dynamic> data;

  const HomeModel({@required this.data});

  @override
  List<Object> get props => [data];

  factory HomeModel.fromJson(Map<dynamic, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
