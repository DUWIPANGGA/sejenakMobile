import 'package:selena/models/post_comment_models/post_comment_models.dart';
import 'package:selena/models/post_models/post_models.dart';

abstract class GetAction<T> {
  Future<List<T>> get();
}

abstract class PostAction<T> {
  Future<bool> post(int id, T data);
}

abstract class GetDetailAction<T> {
  Future<T> getDetail(int id);
}

abstract class EditAction<T> {
  Future<T> edit(int id, T data);
}

abstract class DeleteAction {
  Future<bool> delete(int id);
}

class CommentGetter implements GetAction<PostCommentModels> {
  @override
  Future<List<PostCommentModels>> get() async => [];
}

class CommentPoster implements PostAction<PostCommentModels> {
  @override
  Future<bool> post(int id, PostCommentModels data) async => true;
}

class CommentDetailGetter implements GetDetailAction<PostCommentModels> {
  @override
  Future<PostCommentModels> getDetail(int id) async => PostCommentModels();
}

class CommentEditor implements EditAction<PostCommentModels> {
  @override
  Future<PostCommentModels> edit(int id, PostCommentModels data) async =>
      PostCommentModels();
}

class CommentDeleter implements DeleteAction {
  @override
  Future<bool> delete(int id) async => true;
}

class ReportGetter implements GetAction<PostModels> {
  @override
  Future<List<PostModels>> get() async => [];
}

class ReportPoster implements PostAction<PostModels> {
  @override
  Future<bool> post(int id, PostModels data) async => true;
}

class ReportDetailGetter implements GetDetailAction<PostModels> {
  @override
  Future<PostModels> getDetail(int id) async => PostModels();
}

class ReportEditor implements EditAction<PostModels> {
  @override
  Future<PostModels> edit(int id, PostModels data) async => PostModels();
}

class ReportDeleter implements DeleteAction {
  @override
  Future<bool> delete(int id) async => true;
}
