import 'package:selena/models/post_reply_comment/post_reply_comment.dart';
import 'package:selena/models/user_models/user.dart';

class PostCommentModels {
  int? commentId;
  String? username;
  int? postId;
  String? contentComment;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<PostReplyComment>? replies;

  PostCommentModels({
    this.commentId,
    this.username,
    this.postId,
    this.contentComment,
    this.createdAt,
    this.updatedAt,
    this.replies,
    this.user,
  });

  factory PostCommentModels.fromJson(Map<String, dynamic> json) {
    return PostCommentModels(
      commentId: json['commentID'] as int?,
      username: json['username'] as String?,
      postId: json['postID'] as int?,
      contentComment: json['contentComment'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      replies: json['reply'] != null
          ? (json['reply'] as List)
              .map((reply) => PostReplyComment.fromJson(reply))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentID': commentId,
      'username': username,
      'postID': postId,
      'contentComment': contentComment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(), // Convert User object to JSON
      'reply': replies
          ?.map((r) => r.toJson())
          .toList(), // Convert each PostReplyComment to JSON
    };
  }

  static List<PostCommentModels> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PostCommentModels.fromJson(json)).toList();
  }
}
