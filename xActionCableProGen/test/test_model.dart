import 'package:json_annotation/json_annotation.dart';

class TestModel {
  @JsonKey(name: 'test')
  String message;

  TestModel({required this.message});

  factory TestModel.fromJson(Map<String, dynamic> json) =>
      TestModel(message: json['test'] as String);
}
