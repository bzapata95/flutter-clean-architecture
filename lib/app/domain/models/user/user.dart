import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String username,
    ////////////////////////////////
    @JsonKey(
      name: 'avatar',
      fromJson: avatarPathFormJson,
    )
    String? avatarPath,
  }) = _User;
  const User._();

  String getFormatted() {
    return '$username $id';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

String? avatarPathFormJson(Map<String, dynamic> json) {
  return json['tmdb']?['avatar_path'] as String?;
}
