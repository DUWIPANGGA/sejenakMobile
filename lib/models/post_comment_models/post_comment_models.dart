class PostCommentModels {
  int? commentId;
  String? username;
  int? postId;
  String? contentComment;
  String? createdAt;
  String? updatedAt;

  PostCommentModels({
    this.commentId,
    this.username,
    this.postId,
    this.contentComment,
    this.createdAt,
    this.updatedAt,
  });

  factory PostCommentModels.fromJson(Map<String, dynamic> json) {
    return PostCommentModels(
      commentId: json['commentID'] as int?,
      username: json['username'] as String?,
      postId: json['postID'] as int?,
      contentComment: json['contentComment'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'commentID': commentId,
        'username': username,
        'postID': postId,
        'contentComment': contentComment,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
