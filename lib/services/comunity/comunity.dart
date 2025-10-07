import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:selena/models/post_comment_models/post_comment_models.dart';
import 'package:selena/models/post_models/post_models.dart';
import 'package:selena/models/user_models/user_models.dart';

import '../api.dart';

abstract class IPostRepository {
  Future<void> createPost(PostModels post);
  Future<PostModels?> getPostById(int id);
  Future<List<PostModels>> getAllPosts();
  Future<void> updatePost(PostModels post);
  Future<void> deletePost(int id);
}

abstract class DetailAction {
  Future<void> likePost(bool isLike, int id);
  Future<void> commentPost(int id, TextEditingController commentController);
  Future<void> replyCommentPost(int id, TextEditingController comment,int postId);
  Future<List<PostCommentModels>> getCommentPost(int id);
}

class PostRepository {
  final List<PostModels> posts = [];
}

class ComunityServices implements IPostRepository {
  final PostRepository postRepository = PostRepository();
  late UserModels user;

  List<PostModels>? _cachedPosts;
  DateTime? _lastFetchTime;

  ComunityServices(this.user);

  bool get _isCacheValid {
    if (_cachedPosts == null || _lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 1);
  }
  @override
  Future<void> createPost(PostModels post) async {
    try {
      final formData = FormData.fromMap({
        "title": post.title,
        "content": post.deskripsiPost,
        if (post.postPicture != null)
          "image": await MultipartFile.fromFile(post.postPicture!),
        "is_anonymous": (post.isAnonymous ?? false) ? "1" : "0",
      });

      final response = await DioHttpClient.getInstance().post(
        API.communityCreatePost,
        data: formData,
      );

      print("Response: ${response.data}");

      if (response.data['status'] == "success") {
        final newPost = PostModels.fromJson(response.data['data']);

        // tambah ke cache juga
        _cachedPosts ??= [];
        _cachedPosts!.insert(0, newPost);
        print("✅ Post berhasil dibuat dan ditambahkan ke cache");
      } else {
        throw Exception("Unexpected response: ${response.data}");
      }
    } on DioException catch (e) {
      print("Dio Error (createPost): ${e.message}");
      throw Exception("Gagal membuat post: ${e.response?.data}");
    }
  }
  @override
Future<void> updatePost(PostModels post) async {
  try {
    final isLocalImage = post.postPicture != null && !post.postPicture!.startsWith("posts/");

    final formData = FormData.fromMap({
      "title": post.title,
      "content": post.deskripsiPost,
      if (isLocalImage)
        "image": await MultipartFile.fromFile(post.postPicture!),
      if (!isLocalImage && post.postPicture != null)
        "existing_image": post.postPicture, // kirim path lama biar backend tahu
      "is_anonymous": post.isAnonymous ?? false,
    });

    final response = await DioHttpClient.getInstance().put(
      API.communityUpdatePost(post.postId!),
      data: formData,
    );

    print("Response: ${response.data}");

    if (response.data['status'] == "success") {
      int index = _cachedPosts!.indexWhere((p) => p.postId == post.postId);
      if (index != -1) {
        _cachedPosts![index] = PostModels.fromJson(response.data['data']);
        print("✅ Post berhasil diperbarui: ${post.deskripsiPost}");
      }
    } else {
      throw Exception("Unexpected response format: ${response.data}");
    }
  } on DioException catch (e) {
    print("Dio Error (updatePost): ${e.message}");
    throw Exception("Gagal update post: ${e.response?.statusCode}");
  }
}

  
  @override
  Future<PostModels?> getPostById(int id) async {
    try {
      final response = await DioHttpClient.getInstance().get(
        API.communityDetailPost(id),
      );

      print("Response: ${response.data}");

      if (response.data['status'] == "success") {
        return PostModels.fromJson(response.data['data']);
      } else {
        throw Exception("Unexpected response: ${response.data}");
      }
    } on DioException catch (e) {
      print("Dio Error (getPostById): ${e.message}");
      throw Exception("Gagal memuat post: ${e.response?.statusCode}");
    }
  }

  @override
  Future<List<PostModels>> getAllPosts() async {
    print("chache status = $_cachedPosts");
    if (_isCacheValid) {
      print("📦 Mengambil data dari cache...");
      return _cachedPosts!;
    }

    try {
      print("🌐 Fetching data dari API...");
      final response = await DioHttpClient.getInstance().get(
        API.community,
        queryParameters: {
          "username": user.user!.username,
        },
      );

      print("Response: ${response.data}");

      if (response.data['posts'] is List) {
        _cachedPosts = PostModels.fromJsonList(response.data['posts']);
        _lastFetchTime = DateTime.now(); // update waktu ambil terakhir
        print("✅ Data post disimpan ke cache ${_cachedPosts}" );
        return _cachedPosts!;
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioException catch (e) {
      print("❌ Dio Error (getAllPosts): ${e.message}");
      throw Exception("Failed to load posts: ${e.response?.statusCode}");
    }
  }
@override
  Future<void> deletePost(int id) async {
    try {
      final response = await DioHttpClient.getInstance().delete(
        API.communityDeletePost(id),
      );

      print("Response: ${response.data}");

      if (response.data['status'] == "success") {
        _cachedPosts!.removeWhere((post) => post.postId == id);
        print("🗑️ Post dengan ID $id berhasil dihapus");
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      print("Dio Error (deletePost): ${e.message}");
      throw Exception("Gagal menghapus post: ${e.response?.statusCode}");
    }
  }
}

class ComunityAction implements DetailAction {
  late UserModels user;
  ComunityAction(this.user);
  @override
  Future<void> likePost(bool isLiked, int id) async {
    try {
      final response = await DioHttpClient.getInstance().post(
        API.communityLikeToggle,
        data: {
          "post_id": id,
        },
      );
      print("Response: ${response.data}");
      if (response.data['code'] == 200) {
        print(response.data['code']);
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception("Failed to load posts: ${e.response?.statusCode}");
    }
  }

  @override
  Future<void> commentPost(int postId, TextEditingController commentController) async {
  try {
    final response = await DioHttpClient.getInstance().post(
      API.communityComments,
      data: {
        "post_id": postId,
        "content": commentController.text
      },
    );
    
    print("Response: ${response.data}");
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Comment posted successfully");
      commentController.clear(); // Clear input setelah berhasil
    } else {
      throw Exception("Failed to post comment: ${response.statusCode}");
    }
  } on DioException catch (e) {
    print("Dio Error: ${e.message}");
    print("Error Response: ${e.response?.data}");
    throw Exception("Failed to post comment: ${e.response?.statusCode ?? 'Network error'}");
  }
}

  @override
Future<void> replyCommentPost(int commentId, TextEditingController commentController, int postId) async {
  try {
    final response = await DioHttpClient.getInstance().post(
      API.communityReplies, // pastikan ini mengarah ke "/comments"
      data: {
        "post_id": postId,
        "comment_id": commentId, // id komentar yang dibalas
        "content": commentController.text,
      },
    );

    print("Response: ${response.data}");

    if (response.data['success'] == true) {
      print("Reply berhasil dikirim: ${response.data['data']}");
    } else {
      throw Exception("Unexpected response format: ${response.data}");
    }
  } on DioException catch (e) {
    print("Dio Error: ${e.message}");
    throw Exception("Failed to reply comment: ${e.response?.statusCode}");
  }
}


@override
Future<List<PostCommentModels>> getCommentPost(int postId) async {
  try {
    final response = await DioHttpClient.getInstance().get(
      API.communityCommentDetail(postId), 
    );

    print("Response: ${response.data}");

    if (response.data['success'] == true) {
      final List<dynamic> commentList = response.data['data'];
      return PostCommentModels.fromJsonList(commentList);
    } else {
      throw Exception("Unexpected response format: ${response.data}");
    }
  } on DioException catch (e) {
    print("Dio Error: ${e.message}");
    throw Exception("Failed to load comments: ${e.response?.statusCode}");
  }
}
}

