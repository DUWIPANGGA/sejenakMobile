import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selena/app/components/sejenak_floating_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/partial/comunity/sejenak_create_post.dart';
import 'package:selena/app/partial/main/sejenak_circular.dart';
import 'package:selena/app/partial/main/sejenak_error.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/post_models/post_models.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/screen/profile/profile.dart';
import 'package:selena/services/api.dart';
import 'package:selena/services/comunity/comunity.dart';
import 'package:selena/session/user_session.dart';

class Dashboard extends StatelessWidget {
  final UserModels? mySession;
  final ComunityServices comunity;
  final Future<List<PostModels>> recentPosts;

  Dashboard({super.key})
      : mySession = UserSession().user,
        comunity = ComunityServices(UserSession().user!),
        recentPosts = ComunityServices(UserSession().user!).getAllPosts() {
    assert(mySession != null, "User tidak boleh null!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SejenakHeaderPage(
              text: "Dashboard",
              profile: mySession!.user!.profil,
            ),
          ),
          
          // Streak & Daily Challenge Section
          SliverToBoxAdapter(
            child: _buildStreakSection(),
          ),
          
          // Stats Section
          SliverToBoxAdapter(
            child: _buildStatsSection(),
          ),
          
          // Quick Actions - Menu Utama
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),
          
          // Daily Challenge
          SliverToBoxAdapter(
            child: _buildDailyChallenge(),
          ),
          
          // Recent Posts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SejenakText(
                text: "Post Terbaru Komunitas",
                type: SejenakTextType.h5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Recent Posts List
          _buildRecentPostsList(),
        ],
      ),
      endDrawer: SejenakSidebar(user: mySession),
      floatingActionButton: SejenakFloatingButton(
        onPressed: () => SejenakCreatePost(id: 1).showCreateContainer(context),
      ),
      bottomNavigationBar: SejenakNavbar(index: 0),
    );
  }

  Widget _buildStreakSection() {
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
          children: [
            // Streak Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SejenakText(
                    text: "Streak Hari Ini",
                    type: SejenakTextType.regular,
                    color: SejenakColor.stroke,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      SejenakText(
                        text: "7",
                        type: SejenakTextType.h4,
                        fontWeight: FontWeight.bold,
                        color: SejenakColor.secondary,
                      ),
                      SizedBox(width: 4),
                      SejenakText(
                        text: "hari berturut-turut",
                        type: SejenakTextType.small,
                        color: SejenakColor.stroke,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SejenakText(
                    text: "Lanjutkan untuk menjaga streak-mu!",
                    type: SejenakTextType.small,
                    color: SejenakColor.stroke,
                  ),
                ],
              ),
            ),
            
            // Fire Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: SejenakColor.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: SejenakColor.secondary),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/fire.svg',
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    SejenakColor.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
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
              icon: 'assets/svg/post_icon.svg',
              value: "12",
              label: "Post",
            ),
            _buildStatItem(
              icon: 'assets/svg/like.svg',
              value: "45",
              label: "Like Diterima",
            ),
            _buildStatItem(
              icon: 'assets/svg/journal.svg',
              value: "8",
              label: "Journal",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: SejenakColor.light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SejenakColor.stroke.withOpacity(0.3)),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                SejenakColor.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SejenakText(
          text: value,
          type: SejenakTextType.h5,
          fontWeight: FontWeight.bold,
        ),
        SejenakText(
          text: label,
          type: SejenakTextType.small,
          color: SejenakColor.stroke,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SejenakText(
              text: "Menu Utama",
              type: SejenakTextType.h5,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionItem(
                  icon: 'assets/svg/community.svg',
                  label: 'Komunitas',
                  onTap: () {
                    // Navigate to community page
                  },
                ),
                _buildActionItem(
                  icon: 'assets/svg/article.svg',
                  label: 'Artikel',
                  onTap: () {
                    // Navigate to articles page
                  },
                ),
                _buildActionItem(
                  icon: 'assets/svg/chat_bot.svg',
                  label: 'Chat Bot',
                  onTap: () {
                    // Navigate to chat bot
                  },
                ),
                _buildActionItem(
                  icon: 'assets/svg/expert_chat.svg',
                  label: 'Chat Ahli',
                  onTap: () {
                    // Navigate to expert chat
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionItem(
                  icon: 'assets/svg/journal.svg',
                  label: 'Tulis Journal',
                  onTap: () {
                    // Navigate to journal
                  },
                ),
                _buildActionItem(
                  icon: 'assets/svg/challenge.svg',
                  label: 'Challenge',
                  onTap: () {
                    // Navigate to challenges
                  },
                ),
                _buildActionItem(
                  icon: 'assets/svg/profile.svg',
                  label: 'Profil',
                  onTap: () {
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Profile()),
);
                  },
                ),
                Container(
                  width: 50,
                  height: 50,
                  // Empty container for alignment
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: SejenakColor.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: SejenakColor.secondary),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  SejenakColor.secondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SejenakText(
            text: label,
            type: SejenakTextType.small,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallenge() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SejenakText(
                  text: "Daily Challenge",
                  type: SejenakTextType.h5,
                  fontWeight: FontWeight.bold,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SejenakColor.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SejenakColor.secondary),
                  ),
                  child: SejenakText(
                    text: "Hari 7",
                    type: SejenakTextType.small,
                    fontWeight: FontWeight.bold,
                    color: SejenakColor.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SejenakText(
              text: "Tuliskan 3 hal yang kamu syukuri hari ini",
              type: SejenakTextType.regular,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: SejenakColor.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SejenakText(
                        text: "Lakukan Challenge",
                        type: SejenakTextType.regular,
                        color: SejenakColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: SejenakColor.light,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: SejenakColor.stroke.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/check.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        SejenakColor.stroke,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPostsList() {
    return FutureBuilder<List<PostModels>>(
      future: recentPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Center(child: SejenakCircular()),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: SejenakError(
              message: snapshot.error.toString(),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
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
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SejenakText(
                    text: "Belum ada post terbaru",
                    type: SejenakTextType.regular,
                    color: SejenakColor.stroke,
                  ),
                ),
              ),
            ),
          );
        }

        List<PostModels> posts = snapshot.data!.take(3).toList(); // Limit to 3 posts

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var post = posts[index];
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: post.isAnonymous ?? false
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      color: SejenakColor.light,
                                      child: Icon(
                                        Icons.no_accounts,
                                        size: 20,
                                        color: SejenakColor.stroke,
                                      ),
                                    )
                                  : post.user?.profil == null
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          color: SejenakColor.light,
                                          child: Icon(Icons.person, size: 20),
                                        )
                                      : Image.network(
                                          "${API.endpointImage}storage/${post.user?.profil}",
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 30,
                                              height: 30,
                                              color: SejenakColor.light,
                                              child: Icon(Icons.person, size: 20),
                                            );
                                          },
                                        ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SejenakText(
                                    text: post.isAnonymous ?? false
                                        ? 'Anonymous'
                                        : post.user?.username ?? "anonymous",
                                    type: SejenakTextType.regular,
                                    maxLines: 1,
                                  ),
                                  SejenakText(
                                    text: post.createdAt?.substring(0, 10) ?? "",
                                    type: SejenakTextType.small,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/svg/humberger_menu.svg',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SejenakText(
                          text: post.title ?? "Judul Kosong",
                          type: SejenakTextType.h5,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 4),
                        SejenakText(
                          text: post.deskripsiPost != null && post.deskripsiPost!.length > 100
                              ? "${post.deskripsiPost!.substring(0, 100)}..."
                              : post.deskripsiPost ?? "Tidak ada konten",
                          type: SejenakTextType.small,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/like.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    SejenakColor.stroke,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  (post.totalLike ?? 0).toString(),
                                  style: TextStyle(
                                    fontFamily: "Exo2",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/comment.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    SejenakColor.stroke,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  (post.totalComment ?? 0).toString(),
                                  style: TextStyle(
                                    fontFamily: "Exo2",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: posts.length,
          ),
        );
      },
    );
  }
}