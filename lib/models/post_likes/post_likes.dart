class PostLikes {
  int? likeId;
  int? postId;
  String? username;
  String? createdAt;
  String? updatedAt;

  PostLikes({
    this.likeId,
    this.postId,
    this.username,
    this.createdAt,
    this.updatedAt,
  });

  factory PostLikes.fromJson(Map<String, dynamic> json) => PostLikes(
        likeId: json['likeID'] as int?,
        postId: json['postID'] as int?,
        username: json['username'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'likeID': likeId,
        'postID': postId,
        'username': username,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
