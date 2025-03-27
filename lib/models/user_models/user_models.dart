import 'package:collection/collection.dart';

import 'user.dart';

class UserModels {
  final int? code;
  final String? status;
  final String? token;
  final User? user;

  const UserModels({this.code, this.status, this.token, this.user});

  factory UserModels.fromJson(Map<String, dynamic> json) => UserModels(
        code: json['code'] as int?,
        status: json['status'] as String?,
        token: json['token'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'token': token,
        'user': user?.toJson(),
      };

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
