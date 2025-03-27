class PostReplyComment {
  int? commentReplyId;
  int? commentId;
  String? contentReply;
  String? username;
  String? createdAt;
  String? updatedAt;

  PostReplyComment({
    this.commentReplyId,
    this.commentId,
    this.contentReply,
    this.username,
    this.createdAt,
    this.updatedAt,
  });

  factory PostReplyComment.fromJson(Map<String, dynamic> json) {
    return PostReplyComment(
      commentReplyId: json['commentReplyID'] as int?,
      commentId: json['commentID'] as int?,
      contentReply: json['contentReply'] as String?,
      username: json['username'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'commentReplyID': commentReplyId,
        'commentID': commentId,
        'contentReply': contentReply,
        'username': username,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
