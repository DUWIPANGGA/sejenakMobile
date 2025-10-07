import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_primary_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/components/sejenak_text_field.dart';
import 'package:selena/app/partial/comunity/sejenak_comment_container.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/models/post_comment_models/post_comment_models.dart';
import 'package:selena/models/post_models/post_models.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/services/api.dart';
import 'package:selena/services/comunity/comunity.dart';
import 'package:selena/session/user_session.dart';

class SejenakDetailPost {
  final FocusNode _focusNode = FocusNode();
  final PostModels post;
  late bool reply = false;
  late PostCommentModels commentForReply;
  bool _isLiked;
  int _likeCount;
  late List comments;
  TextEditingController commentInput = TextEditingController();
  SejenakDetailPost({
    required this.post,
  })  : _isLiked = post.isLiked ?? false,
        _likeCount = post.totalLike ?? 0 {
    if (post.postId != null) {
      _loadComments();
    } else {
      print("postId is null, unable to fetch comments.");
    }
  }

  Future<void> _loadComments() async {
    try {
      comments = await ComunityAction(UserSession().user!)
          .getCommentPost(post.postId!);
    } catch (error) {
      print("Error getting comments: $error");
      comments = [];
    }
  }

  Future<void> toggleLike() async {
    final newLikeStatus = !_isLiked;
    final newLikeCount = newLikeStatus ? _likeCount + 1 : _likeCount - 1;

    // Optimistic update
    _isLiked = newLikeStatus;
    _likeCount = newLikeCount;

    try {
      await ComunityAction(UserSession().user!)
          .likePost(newLikeStatus, post.postId!);
    } catch (error) {
      _isLiked = !newLikeStatus;
      _likeCount = newLikeStatus ? _likeCount - 1 : _likeCount + 1;
      print("Error liking post: $error");
      rethrow;
    }
  }

  void showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 1,
              builder: (_, controller) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: SejenakColor.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: SejenakColor.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: controller,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SejenakText(
                                      text:  post.title ?? 'No Title',
                                      type: SejenakTextType.h4,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            post.postPicture ?? '',
                                            width: 35,
                                            height: 35,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 35,
                                              color: SejenakColor.secondary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SejenakText(
                                                text: post!.isAnonymous == true ? 
                                                    'Anonymous':post.user!.username!,
                                                type: SejenakTextType.regular,
                                                maxLines: 1,
                                              ),
                                              SejenakText(
                                                text: post.createdAt != null &&
                                                        post.createdAt!
                                                                .length >=
                                                            10
                                                    ? post.createdAt!
                                                        .substring(0, 10)
                                                    : 'Unknown date',
                                                type: SejenakTextType.small,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (post.postPicture != null && post.postPicture!.isNotEmpty)
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            "${API.endpointImage}storage/${post.postPicture}",
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                      ),


                                    const SizedBox(height: 16),
                                    SejenakText(
                                      text: post.deskripsiPost ??
                                          'No description',
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 100,
                                          child: SejenakPrimaryButton(
                                            text: "$_likeCount",
                                            action: () async {
                                              setState(() {
                                                toggleLike().catchError((e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Failed to update like'),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                            icon: _isLiked
                                                ? 'assets/svg/liked.svg'
                                                : 'assets/svg/like.svg',
                                            paddingX: 0,
                                            paddingY: 9,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                    ),
                                  const SizedBox(height: 24),
                                    Container(
                                      width: double.infinity,
                                      height: 2,
                                      color: SejenakColor.primary,
                                    ),
                        const SizedBox(height: 24),

                                    FutureBuilder<List<PostCommentModels>>(
                                      future:
                                          ComunityAction(UserSession().user!)
                                              .getCommentPost(post.postId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: SejenakCircular());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: SejenakError(
                                              message:
                                                  'belum ada komentar nih..',
                                            ),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                            child: SejenakError(
                                              message: "No comments yet",
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            children: snapshot.data!
                                                .map(
                                                  (comment) =>
                                                      SejenakCommentContainer(
                                                    id: comment.id!,
                                                    postImage: comment
                                                        .user!.profil
                                                        .toString(),
                                                    text: comment
                                                            .content ??
                                                        '',
                                                    name: comment.user!.username ??
                                                        'Anonymous',
                                                    date: comment.createdAt ??
                                                        'Unknown date',
                                                    likes: 0,
                                                    comment: 0,
                                                    isLike: false,
                                                    isMe: false,
                                                    onReplyChanged: (isReply) {
                                                      if (isReply &&
                                                          comment.id !=
                                                              null) {
                                                        commentForReply =
                                                            comment;
                                                        reply = isReply;
                                                        commentInput.text = '';
                                                        String mentionText =
                                                            " @${comment.user!.username!} ";
                                                        if (!commentInput.text
                                                            .contains(
                                                                mentionText)) {
                                                          commentInput.text =
                                                              commentInput
                                                                      .text +
                                                                  mentionText;
                                                        }

                                                        print(
                                                            "Replying to comment ID: ${comment.id}");

                                                        // Gunakan `Future.microtask` untuk memastikan keyboard fokus setelah UI update
                                                        Future.microtask(() {
                                                          if (_focusNode
                                                              .canRequestFocus) {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    _focusNode);
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Column(
                                                      children: comment.replies!
                                                          .map((commentReply) =>
                                                              SejenakCommentContainer(
                                                                id: commentReply
                                                                    .id!,
                                                                text: commentReply
                                                                    .content!,
                                                                postImage:
                                                                    commentReply
                                                                        .user!
                                                                        .profil
                                                                        .toString(),
                                                                name: commentReply
                                                                        .user!.username ??
                                                                    'Anonymous',
                                                                date: commentReply
                                                                        .createdAt ??
                                                                    'Unknown date',
                                                              ))
                                                          .toList(),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: SejenakColor.white,
                            border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Colors.grey[900]!,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SejenakTextField(
                                  text: 'Reply to post',
                                  controller: commentInput,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SejenakPrimaryButton(
                                text: "",
                                icon: "assets/svg/pen.svg",
                                action: () async {
                                  print("reply = $reply");
                                  if (!reply &&
                                      (commentInput.text != " " ||
                                          commentInput.text.isNotEmpty)) {
                                    await ComunityAction(UserSession().user!)
                                        .commentPost(
                                            post.postId!, commentInput);
                                    if (commentInput.text.isNotEmpty) {
                                      commentInput.text = "";
                                      FocusScope.of(context).unfocus();
                                    }
                                  } else {
                                    await ComunityAction(UserSession().user!)
                                        .replyCommentPost(
                                            commentForReply.id!,
                                            commentInput,post.postId!);
                                    if (commentInput.text.isNotEmpty) {
                                      commentInput.text = "";
                                      FocusScope.of(context).unfocus();
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
