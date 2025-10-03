import 'package:collection/collection.dart';

import 'user.dart';

class UserModels {
  final int? code;
  final String? status;
  final String? token;
  final User? user;
  final String? refreshToken;
  final int? expiresIn;
  final int? refreshExpiresIn;
  const UserModels({
    this.code,
    this.status,
    this.token,
    this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.user,
  });

factory UserModels.fromJson(Map<String, dynamic> json) => UserModels(
  code: json['code'] as int?,
  status: json['status'] as String?,
  token: json['access_token'] as String? ?? json['token'] as String?,  // cek dua-duanya
  refreshToken: json['refresh_token'] as String?,
  expiresIn: json['expires_in'] as int?,
  refreshExpiresIn: json['refresh_expires_in'] as int?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> toJson() => {
  'code': code,
  'status': status,
  'access_token': token,
  'refresh_token': refreshToken,
  'expires_in': expiresIn,
  'refresh_expires_in': refreshExpiresIn,
  'user': user?.toJson(),
};
  static List<UserModels> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserModels.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserModels) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      code.hashCode ^ status.hashCode ^ token.hashCode ^ user.hashCode;
}
