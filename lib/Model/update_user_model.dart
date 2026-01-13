// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:notes/Enum/keys_enum.dart';

class UpdateUserModel {
  final String? name;


  UpdateUserModel({
     this.name,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.name.valueKey: name,
    };
  }

  factory UpdateUserModel.fromMap(Map<String, dynamic> map) {
    return UpdateUserModel(
      name: map[KeysEnum.name.valueKey] as String?,
    );
  }
}
