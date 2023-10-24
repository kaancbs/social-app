import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String? description;
  final String? link;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> dislikes;
  final int commentCount;
  Post({
    required this.id,
    this.description,
    this.link,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
    required this.commentCount,
  });

  Post copyWith({
    String? id,
    String? description,
    String? link,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? dislikes,
    int? commentCount,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      link: link ?? this.link,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'link': link,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'dislikes': dislikes,
      'commentCount': commentCount,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      description: map['description'],
      link: map['link'],
      uid: map['uid'] ?? '',
      type: map['type'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from((map['likes'])),
      dislikes: List<String>.from((map['dislikes'])),
      commentCount: map['commentCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id,  description: $description, link: $link, uid: $uid, type: $type, createdAt: $createdAt, likes: $likes, dislikes: $dislikes, commentCount: $commentCount)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.link == link &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.dislikes, dislikes) &&
        other.commentCount == commentCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        link.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        dislikes.hashCode ^
        commentCount.hashCode;
  }
}
