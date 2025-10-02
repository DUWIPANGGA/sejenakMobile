class LikeModel {
  int? id;
  int? userId;
  int? postId;
  int? commentId;
  String? createdAt;
  String? updatedAt;

  LikeModel({
    this.id,
    this.userId,
    this.postId,
    this.commentId,
    this.createdAt,
    this.updatedAt,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        postId: json['post_id'] as int?,
        commentId: json['comment_id'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "post_id": postId,
        "comment_id": commentId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
