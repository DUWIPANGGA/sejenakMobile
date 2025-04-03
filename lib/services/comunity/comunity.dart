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
  Future<void> commentPost(int id, TextEditingController comment);
  Future<void> replyCommentPost(int id, TextEditingController comment);
  Future<List<PostCommentModels>> getCommentPost(int id);
}

class PostRepository {
  final List<PostModels> posts = [];
}

class ComunityServices implements IPostRepository {
  final PostRepository postRepository = PostRepository();
  late List<PostModels> _posts;
  late UserModels user;
  late DioHttpClient comunity;
  ComunityServices(this.user) {
    _posts = postRepository.posts;
  }
  @override
  Future<void> createPost(PostModels post) async {
    _posts.add(post);
    print("Post berhasil dibuat: ${post.judul}");
  }

  @override
  Future<PostModels?> getPostById(int id) async {
    return _posts.firstWhere((post) => post.postId == id);
  }

  @override
  Future<List<PostModels>> getAllPosts() async {
    try {
      final response = await DioHttpClient.getInstance().get(
        API.allPost,
        data: {
          "username": user.user!.username,
        },
      );
      print("Response: ${response.data['body']['post']}");
      if (response.data['body']['post'] is List) {
        _posts = PostModels.fromJsonList(response.data['body']['post']);
        print("Response: ${_posts}");
        return _posts;
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception("Failed to load posts: ${e.response?.statusCode}");
    }
  }

  @override
  Future<void> updatePost(PostModels post) async {
    int index = _posts.indexWhere((p) => p.postId == post.postId);
    if (index != -1) {
      _posts[index] = post;
      print("Post berhasil diperbarui: ${post.judul}");
    }
  }

  @override
  Future<void> deletePost(int id) async {
    _posts.removeWhere((post) => post.postId == id);
    print("Post dengan ID $id berhasil dihapus");
  }
}

class ComunityAction implements DetailAction {
  late UserModels user;
  ComunityAction(this.user);
  @override
  Future<void> likePost(bool isLiked, int id) async {
    try {
      final response = await DioHttpClient.getInstance().post(
        API.comunity,
        data: {
          "action": "like",
          "id": id,
          "username": user.user?.username,
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
  Future<void> commentPost(int id, TextEditingController comment) async {
    try {
      final response = await DioHttpClient.getInstance().post(
        API.comunity,
        data: {
          "action": "comment",
          "id": id,
          "username": user.user?.username,
          "value": comment.text
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
  Future<void> replyCommentPost(int id, TextEditingController comment) async {
    try {
      final response = await DioHttpClient.getInstance().post(
        API.comunity,
        data: {
          "action": "reply",
          "id": id,
          "username": user.user?.username,
          "value": comment.text
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
  Future<List<PostCommentModels>> getCommentPost(int id) async {
    try {
      final response = await DioHttpClient.getInstance().post(
        API.comunity,
        data: {
          "action": "detail",
          "id": id,
          "username": user.user?.username,
        },
      );
      print("Response: ${response.data['body']['comment']}");
      if (response.data['code'] == 200) {
        print(response.data['body']['comment']);
        return PostCommentModels.fromJsonList(response.data['body']['comment']);
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception("Failed to load posts: ${e.response?.statusCode}");
    }
  }
}
