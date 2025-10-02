class PostModels {
  int? postId;
  bool? isAnonymous;
  String? postPicture;
  String? username;
  String? deskripsiPost;
  int? totalLike;
  int? totalComment;
  bool? isLiked;
  String? createdAt;
  String? updatedAt;

  PostModels({
    this.postId,
    this.postPicture,
    this.username,
    this.deskripsiPost,
    this.totalLike,
    this.isAnonymous,
    this.totalComment,
    this.isLiked,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModels.fromJson(Map<String, dynamic> json) => PostModels(
        postId: json['id'] as int?,
        postPicture: json['image'] as String?,
        username: json['user']?['username'] as String?, // ambil dari nested user
        deskripsiPost: json['content'] as String?,
        totalLike: (json['likes'] as List?)?.length ?? 0,
        totalComment: (json['comments'] as List?)?.length ?? 0,
        isLiked: json['isLiked'] as bool? ?? false, // default false kalau null
        isAnonymous: json['is_anonymous'] as bool? ?? false, // default false kalau null
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': postId,
        'image': postPicture,
        'username': username,
        'content': deskripsiPost,
        'totalLike': totalLike,
        'totalComment': totalComment,
        'isLiked': isLiked,
        'isAnonymous': isAnonymous,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  static List<PostModels> fromJsonList(dynamic jsonList) {
    if (jsonList is List) {
      return jsonList.map((json) => PostModels.fromJson(json)).toList();
    }
    return [];
  }
}
