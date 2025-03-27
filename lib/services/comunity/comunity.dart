import 'package:dio/dio.dart';
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

class PostRepository {
  final List<PostModels> posts = [];
}

class ComunityServices implements IPostRepository {
  final PostRepository postRepository = PostRepository();
  final API api = API();
  late List<PostModels> _posts;
  late UserModels user;
  late DioHttpClient comunity;
  ComunityServices(this.user) {
    _posts = postRepository.posts;
    comunity =
        HttpClientBuilder().withDio(Dio()).withToken(user.token!).build();
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
      final response = await comunity.get(
        api.allPost,
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
