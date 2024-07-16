import 'package:json_annotation/json_annotation.dart';

part 'test_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TestModel {
  @JsonKey(name: 'test')
  String message;

  TestModel({required this.message});
}
