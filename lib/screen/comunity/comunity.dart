import 'package:flutter/material.dart';
import 'package:selena/app/component/sejenak_floating_button.dart';
import 'package:selena/app/partial/comunity/sejenak_create_post.dart';
import 'package:selena/app/partial/comunity/sejenak_detail_post.dart';
import 'package:selena/app/partial/comunity/sejenak_post_container.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/post_models/post_models.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/services/comunity/comunity.dart';
import 'package:selena/session/user_session.dart';

class Comunity extends StatelessWidget {
  final UserModels? user;
  final ComunityServices comunity;
  final Future<List<PostModels>> result;

  Comunity({super.key})
      : user = UserSession().user,
        comunity = ComunityServices(UserSession().user!),
        result = ComunityServices(UserSession().user!).getAllPosts() {
    assert(user != null, "User tidak boleh null!");
  }
// detail post

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PostModels>>(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SejenakCircular());
          } else if (snapshot.hasError) {
            return SejenakError(
              message: snapshot.error.toString(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SejenakError(
              message: "Tidak ada post yang tersedia",
            );
          }

          List<PostModels> posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length + 1,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SejenakHeaderPage(
                  text: "Post",
                );
              }

              var post = posts[index - 1];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SejenakPostContainer(
                  title: post.judul ?? "Judul Kosong",
                  postImage: post.postPicture ?? "",
                  text: post.deskripsiPost ?? "Tidak ada konten",
                  likes: post.totalLike ?? 0,
                  comment: post.totalComment ?? 0,
                  isLike: post.isLiked ?? false,
                  commentAction: () => SejenakDetailPost(id: post.postId ?? 0)
                      .showDetail(context),
                ),
              );
            },
          );
        },
      ),
      endDrawer: SejenakSidebar(user: user),
      floatingActionButton: SejenakFloatingButton(
        onPressed: () => SejenakCreatePost(id: 1).showCreateContainer(context),
      ),
      bottomNavigationBar: SejenakNavbar(index: 0),
    );
  }
}
