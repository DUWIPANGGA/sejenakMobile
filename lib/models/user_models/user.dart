import 'package:collection/collection.dart';

class User {
  final int? id;
  final dynamic googleId;
  final dynamic googleToken;
  final dynamic googleRefreshToken;
  final String? username;
  final String? email;
  final dynamic emailVerifiedAt;
  final int? premium;
  final dynamic profil;
  final dynamic deskripsiProfil;
  final String? name;
  final int? isAhli;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.googleId,
    this.googleToken,
    this.googleRefreshToken,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.premium,
    this.profil,
    this.deskripsiProfil,
    this.name,
    this.isAhli,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        googleId: json['google_id'] as dynamic,
        googleToken: json['google_token'] as dynamic,
        googleRefreshToken: json['google_refresh_token'] as dynamic,
        username: json['username'] as String?,
        email: json['email'] as String?,
        emailVerifiedAt: json['email_verified_at'] as dynamic,
        premium: json['premium'] as int?,
        profil: json['profil'] as dynamic,
        deskripsiProfil: json['deskripsiProfil'] as dynamic,
        name: json['name'] as String?,
        isAhli: json['isAhli'] as int?,
        role: json['role'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'google_id': googleId,
        'google_token': googleToken,
        'google_refresh_token': googleRefreshToken,
        'username': username,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'premium': premium,
        'profil': profil,
        'deskripsiProfil': deskripsiProfil,
        'name': name,
        'isAhli': isAhli,
        'role': role,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! User) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      googleId.hashCode ^
      googleToken.hashCode ^
      googleRefreshToken.hashCode ^
      username.hashCode ^
      email.hashCode ^
      emailVerifiedAt.hashCode ^
      premium.hashCode ^
      profil.hashCode ^
      deskripsiProfil.hashCode ^
      name.hashCode ^
      isAhli.hashCode ^
      role.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
