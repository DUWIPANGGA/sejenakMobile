class PostModels {
  int? postId;
  String? postPicture;
  String? username;
  String? judul;
  int? totalLike;
  int? totalComment;
  bool? isLiked;
  String? deskripsiPost;
  String? createdAt;
  String? updatedAt;

  PostModels({
    this.postId,
    this.postPicture,
    this.username,
    this.judul,
    this.totalLike,
    this.totalComment,
    this.isLiked,
    this.deskripsiPost,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModels.fromJson(Map<String, dynamic> json) => PostModels(
        postId: json['postID'] as int?,
        postPicture: json['post_picture'] as String?,
        username: json['username'] as String?,
        judul: json['judul'] as String?,
        totalLike: json['totalLike'] as int?,
        totalComment: json['totalComment'] as int?,
        isLiked: json['isLiked'] as bool?,
        deskripsiPost: json['deskripsiPost'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'postID': postId,
        'post_picture': postPicture,
        'username': username,
        'judul': judul,
        'totalLike': totalLike,
        'totalComment': totalComment,
        'isLiked': isLiked,
        'deskripsiPost': deskripsiPost,
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
