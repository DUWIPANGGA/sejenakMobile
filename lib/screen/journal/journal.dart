import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_calendar.dart';
import 'package:selena/app/partial/chat/sejenak_main_chat.dart';
import 'package:selena/app/partial/journal/sejenak_journal_list.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/post_models/post_models.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/services/comunity/comunity.dart';
import 'package:selena/session/user_session.dart';

class Journal extends StatelessWidget {
  final UserModels? user;
  final ComunityServices comunity;
  final Future<List<PostModels>> result;

  Journal({super.key})
      : user = UserSession().user,
        comunity = ComunityServices(UserSession().user!),
        result = ComunityServices(UserSession().user!).getAllPosts() {
    assert(user != null, "User tidak boleh null!");
  }
// detail journal

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
                  text: "Journal",
                );
              }
              if (index == 0) {
                return SejenakCalendar();
              }

              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SejenakJournalList(
                      title: "fulan",
                      text: "lamo",
                      action: () async {
                        SejenakMainChat(id: index).showChat(context);
                      }));
            },
          );
        },
      ),
      endDrawer: SejenakSidebar(user: user),
      bottomNavigationBar: SejenakNavbar(index: 0),
    );
  }
}
