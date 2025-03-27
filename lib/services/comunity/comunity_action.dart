import 'package:selena/models/post_comment_models/post_comment_models.dart';
import 'package:selena/models/post_models/post_models.dart';

import 'blueprint_comunity_action.dart';

abstract class ComunityActionFactory<T> {
  GetAction<T> createGetter();
  PostAction<T> createPoster();
  GetDetailAction<T> createDetailGetter();
  EditAction<T> createEditor();
  DeleteAction createDeleter();
}

class CommentFactory implements ComunityActionFactory<PostCommentModels> {
  @override
  GetAction<PostCommentModels> createGetter() => CommentGetter();

  @override
  PostAction<PostCommentModels> createPoster() => CommentPoster();

  @override
  GetDetailAction<PostCommentModels> createDetailGetter() =>
      CommentDetailGetter();

  @override
  EditAction<PostCommentModels> createEditor() => CommentEditor();

  @override
  DeleteAction createDeleter() => CommentDeleter();
}

class ReportFactory implements ComunityActionFactory<PostModels> {
  @override
  GetAction<PostModels> createGetter() => ReportGetter();

  @override
  PostAction<PostModels> createPoster() => ReportPoster();

  @override
  GetDetailAction<PostModels> createDetailGetter() => ReportDetailGetter();

  @override
  EditAction<PostModels> createEditor() => ReportEditor();

  @override
  DeleteAction createDeleter() => ReportDeleter();
}

// void comunityAction<T>(ComunityActionFactory<T> factory, T dummyData) async {
//   final getter = factory.createGetter();
//   final poster = factory.createPoster();
//   final detailGetter = factory.createDetailGetter();
//   final editor = factory.createEditor();
//   final deleter = factory.createDeleter();

//   await getter.get();
//   await poster.post(1, dummyData);
//   await detailGetter.getDetail(1);
//   await editor.edit(1, dummyData);
//   await deleter.delete(1);
// }

/*
contoh penggunaan

void main() {
  runAction(CommentFactory(), PostCommentModels());
  runAction(ReportFactory(), PostModels());
}
 */
