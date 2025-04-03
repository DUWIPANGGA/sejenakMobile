import 'package:selena/models/user_models/user.dart';

class PostReplyComment {
  int? commentReplyId;
  int? commentId;
  String? contentReply;
  String? username;
  String? createdAt;
  String? updatedAt;
  User? user;

  PostReplyComment({
    this.commentReplyId,
    this.commentId,
    this.contentReply,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory PostReplyComment.fromJson(Map<String, dynamic> json) {
    return PostReplyComment(
      commentReplyId: json['commentReplyID'] as int?,
      commentId: json['commentID'] as int?,
      contentReply: json['contentReply'] as String?,
      username: json['username'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'commentReplyID': commentReplyId,
        'commentID': commentId,
        'contentReply': contentReply,
        'username': username,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user': user?.toJson(),
      };
}

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
    this.user,
    this.replies,
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
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((reply) => PostReplyComment.fromJson(reply))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'commentID': commentId,
        'username': username,
        'postID': postId,
        'contentComment': contentComment,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user': user?.toJson(),
        'replies': replies?.map((reply) => reply.toJson()).toList(),
      };
}
