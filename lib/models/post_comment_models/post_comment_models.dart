import 'package:selena/models/post_reply_comment/post_reply_comment.dart';
import 'package:selena/models/user_models/user.dart';

class PostCommentModels {
  int? id;
  int? postId;
  int? userId;
  String? content;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<PostReplyComment>? replies;

  PostCommentModels({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.replies,
  });

  factory PostCommentModels.fromJson(Map<String, dynamic> json) {
  return PostCommentModels(
    id: json['id'] as int?,
    postId: json['post_id'] as int?,
    userId: json['user_id'] as int?,
    content: json['content'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    replies: (json['replies'] as List?)
            ?.map((r) => PostReplyComment.fromJson(r))
            .toList() 
            ?? [],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'replies': replies?.map((r) => r.toJson()).toList(),
    };
  }

  static List<PostCommentModels> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PostCommentModels.fromJson(json)).toList();
  }
}
