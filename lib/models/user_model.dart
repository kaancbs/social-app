import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String nickname;
  final String uid;
  final String profilePic;
  final List<String> following;
  final List<String> followers;
  UserModel({
    required this.name,
    required this.nickname,
    required this.uid,
    required this.profilePic,
    required this.following,
    required this.followers,
  });

  UserModel copyWith({
    String? name,
    String? nickname,
    String? uid,
    String? profilePic,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserModel(
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'nickname': nickname,
      'uid': uid,
      'profilePic': profilePic,
      'following': following,
      'followers': followers,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      nickname: map['nickname'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      following: List<String>.from((map['following'])),
      followers: List<String>.from((map['followers'])),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, nickname: $nickname, uid: $uid, profilePic: $profilePic, following: $following, followers: $followers)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.nickname == nickname &&
        other.uid == uid &&
        other.profilePic == profilePic &&
        listEquals(other.following, following) &&
        listEquals(other.followers, followers);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        nickname.hashCode ^
        uid.hashCode ^
        profilePic.hashCode ^
        following.hashCode ^
        followers.hashCode;
  }
}
