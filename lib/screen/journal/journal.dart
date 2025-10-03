import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_calendar.dart';
import 'package:selena/app/components/sejenak_floating_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
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
import 'package:selena/root/sejenak_color.dart';
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
      // backgroundColor: SejenakColor.secondary,
      body: FutureBuilder<List<JournalModels>>(
        future: result,
        builder: (context, snapshot) {
          print("Connection: ${snapshot.connectionState}");
          print("Has Data: ${snapshot.hasData}");
          print("Data: ${snapshot.data}");
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
          }

          List<JournalModels> journals = snapshot.data!;
          return _buildJournalList(journals, context);
        },
      ),
      floatingActionButton: SejenakFloatingButton(
        onPressed: () => SejenakCreateJournal().showCreateContainer(context),
      ),
      endDrawer: SejenakSidebar(user: user),
      bottomNavigationBar: SejenakNavbar(index: 3),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SejenakHeaderPage(
          text: "Journal",
          profile: user!.user!.profil,
        ),
        Expanded(
          child: Center(child: SejenakCircular()),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      children: [
        SejenakHeaderPage(
          text: "Journal",
          profile: user!.user!.profil,
        ),
        Expanded(
          child: SejenakError(message: error),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SejenakHeaderPage(
          text: "Journal",
          profile: user!.user!.profil,
        ),
        
        // Calendar Section dengan container
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: SejenakColor.primary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1.0, color: Colors.grey[900]!),
            boxShadow: const [
              BoxShadow(
                color: SejenakColor.black,
                spreadRadius: 0.4,
                blurRadius: 0,
                offset: Offset(0.3, 4),
              ),
            ],
          ),
          child: SejenakCalendar(),
        ),
        
        // Empty State Message dengan container
        Expanded(
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: SejenakColor.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1.0, color: Colors.grey[900]!),
                boxShadow: const [
                  BoxShadow(
                    color: SejenakColor.black,
                    spreadRadius: 0.4,
                    blurRadius: 0,
                    offset: Offset(0.3, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 64,
                    color: SejenakColor.stroke.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  SejenakText(
                    text: "Belum Ada Journal",
                    type: SejenakTextType.h5,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  SejenakText(
                    text: "Mulai tulis journal pertamamu untuk merefleksikan hari-harimu",
                    type: SejenakTextType.small,
                    color: SejenakColor.stroke,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: SejenakColor.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => SejenakCreateJournal().showCreateContainer(context),
                        child: Center(
                          child: SejenakText(
                            text: "Tulis Journal Pertama",
                            type: SejenakTextType.regular,
                            color: SejenakColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJournalList(List<JournalModels> journals, BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: SejenakHeaderPage(
            text: "Journal",
            profile: user!.user!.profil,
          ),
        ),
        
        // Calendar Section
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //     decoration: BoxDecoration(
        //       color: SejenakColor.primary,
        //       borderRadius: BorderRadius.circular(20),
        //       border: Border.all(width: 1.0, color: Colors.grey[900]!),
        //       boxShadow: const [
        //         BoxShadow(
        //           color: SejenakColor.black,
        //           spreadRadius: 0.4,
        //           blurRadius: 0,
        //           offset: Offset(0.3, 4),
        //         ),
        //       ],
        //     ),
        //     child: SejenakCalendar(),
        //   ),
        // ),
        
        // Journal Stats
        SliverToBoxAdapter(
          child: _buildJournalStats(journals),
        ),
        
        // Journal List Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SejenakText(
                  text: "Journal Saya",
                  type: SejenakTextType.h5,
                  fontWeight: FontWeight.bold,
                ),
                SejenakText(
                  text: "${journals.length} Entri",
                  type: SejenakTextType.small,
                  color: SejenakColor.stroke,
                ),
              ],
            ),
          ),
        ),
        
        // Journal List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final journal = journals[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: SejenakColor.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1.0, color: Colors.grey[900]!),
                    boxShadow: const [
                      BoxShadow(
                        color: SejenakColor.black,
                        spreadRadius: 0.4,
                        blurRadius: 0,
                        offset: Offset(0.3, 4),
                      ),
                    ],
                  ),
                  child: SejenakJournalList(
                    title: journal.title ?? 'Tanpa Judul',
                    text: journal.content ?? 'Tanpa Konten',
                    // date: journal.createdAt?.substring(0, 10) ?? '',
                    // mood: _getMoodFromJournal(journal),
                    action: () async {
                      SejenakMainChat(id: journal.entriesId ?? 0)
                          .showChat(context);
                    },
                  ),
                ),
              );
            },
            childCount: journals.length,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalStats(List<JournalModels> journals) {
    // Hitung statistik
    int totalJournals = journals.length;
    int thisMonth = DateTime.now().month;
    int monthlyJournals = journals.where((journal) {
      if (journal.createdAt == null) return false;
      DateTime journalDate = DateTime.parse(journal.createdAt!);
      return journalDate.month == thisMonth;
    }).length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SejenakColor.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.0, color: Colors.grey[900]!),
        boxShadow: const [
          BoxShadow(
            color: SejenakColor.black,
            spreadRadius: 0.4,
            blurRadius: 0,
            offset: Offset(0.3, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              value: totalJournals.toString(),
              label: "Total Journal",
              icon: Icons.library_books_rounded,
            ),
            _buildStatItem(
              value: monthlyJournals.toString(),
              label: "Bulan Ini",
              icon: Icons.calendar_today_rounded,
            ),
            _buildStatItem(
              value: "7",
              label: "Streak",
              icon: Icons.local_fire_department_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: SejenakColor.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SejenakColor.secondary),
          ),
          child: Icon(
            icon,
            size: 24,
            color: SejenakColor.secondary,
          ),
        ),
        SizedBox(height: 8),
        SejenakText(
          text: value,
          type: SejenakTextType.h5,
          fontWeight: FontWeight.bold,
        ),
        SejenakText(
          text: label,
          type: SejenakTextType.small,
          color: SejenakColor.stroke,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getMoodFromJournal(JournalModels journal) {
    // Logic untuk menentukan mood dari journal
    // Ini bisa disesuaikan dengan data yang ada di model
    if (journal.content?.toLowerCase().contains('senang') ?? false) {
      return '😊';
    } else if (journal.content?.toLowerCase().contains('sedih') ?? false) {
      return '😔';
    } else if (journal.content?.toLowerCase().contains('marah') ?? false) {
      return '😠';
    } else {
      return '😐';
    }
  }
}