import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_user_list.dart';
import 'package:selena/app/partial/chat/sejenak_main_chat.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/user_models/user.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/services/chat/chat.dart';
import 'package:selena/session/user_session.dart';

class Chat extends StatelessWidget {
  final UserModels? mySession;
  final ChatServices comunity;
  final Future<List<User>> result;

  Chat({super.key})
      : mySession = UserSession().user,
        comunity = ChatServices(),
        result = ChatServices().getAllKonselor() {
    assert(mySession != null, "User tidak boleh null!");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SejenakCircular());
          } else if (snapshot.hasError) {
            print(snapshot);
            return SejenakError(
              message: snapshot.error.toString(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SejenakError(
              message: "Tidak ada post yang tersedia",
            );
          }

          List<User> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length + 1,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SejenakHeaderPage(
                  text: "Chat",
                  profile: mySession!.user!.profil,
                );
              }
              var user = users[index - 1];
              print("UserModels: ${user.toJson()}");
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SejenakUserList(
                      title: user.username!,
                      image: user.profil ?? "",
                      text: user.deskripsiProfil ??
                          "hello there im ${user.username}",
                      action: () async {
                        SejenakMainChat(id: index).showChat(context);
                      }));
            },
          );
        },
      ),
      endDrawer: SejenakSidebar(user: mySession),
      bottomNavigationBar: SejenakNavbar(index: 3),
    );
  }
}
