import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_calendar.dart';
import 'package:selena/app/components/sejenak_floating_button.dart';
import 'package:selena/app/partial/chat/sejenak_main_chat.dart';
import 'package:selena/app/partial/journal/sejenak_create_journal.dart';
import 'package:selena/app/partial/journal/sejenak_journal_list.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/journal_models/journal_models.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/services/journal/journal.dart';
import 'package:selena/session/user_session.dart';

class Journal extends StatelessWidget {
  final UserModels? user;
  final JournalApiService comunity;
  final Future<List<JournalModels>> result;

  Journal({super.key})
      : user = UserSession().user,
        comunity = JournalApiService(),
        result = JournalApiService().getAllJournal() {
    assert(user != null, "User tidak boleh null!");
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<JournalModels>>(
        future: result,
        builder: (context, snapshot) {
          print("Connection: ${snapshot.connectionState}");
          print("Has Data: ${snapshot.hasData}");
          print("Data: ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SejenakCircular());
          } else if (snapshot.hasError) {
            return SejenakError(
              message: snapshot.error.toString(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SejenakHeaderPage(
                  text: "Journal",
                  profile: user!.user!.profil,
                ),
                SejenakCalendar(),
                SizedBox(
                  height: 50,
                ),
                SejenakError(
                  message: "anda belum pernah membuat journal",
                )
              ],
            );
          }

          List<JournalModels> journals = snapshot.data!;

          return ListView.builder(
            itemCount: journals.length + 1,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SejenakHeaderPage(
                      text: "Journal",
                      profile: user!.user!.profil,
                    ),
                    SejenakCalendar(),
                  ],
                );
              }
              final journal = journals[index - 1]; // pastikan indexnya benar!

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SejenakJournalList(
                  title: journal.title ?? 'Tanpa Judul',
                  text: journal.content ?? 'Tanpa Konten',
                  action: () async {
                    // id harus int, jika null default ke 0
                    SejenakMainChat(id: journal.entriesId ?? 0)
                        .showChat(context);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SejenakFloatingButton(
        onPressed: () => SejenakCreateJournal().showCreateContainer(context),
      ),
      endDrawer: SejenakSidebar(user: user),
      bottomNavigationBar: SejenakNavbar(index: 2),
    );
  }
}
