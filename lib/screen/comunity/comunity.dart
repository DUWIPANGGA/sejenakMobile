import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_floating_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
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
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/services/api.dart';
import 'package:selena/services/comunity/comunity.dart';
import 'package:selena/session/user_session.dart';

class Comunity extends StatelessWidget {
  final UserModels? mySession;
  final ComunityServices comunity;
  final ComunityAction comunityAction;
  final Future<List<PostModels>> result;

  Comunity({super.key})
      : mySession = UserSession().user,
        comunity = ComunityServices(UserSession().user!),
        comunityAction = ComunityAction(UserSession().user!),
        result = ComunityServices(UserSession().user!).getAllPosts() {
    assert(mySession != null, "User tidak boleh null!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: SejenakColor.background,
      body: FutureBuilder<List<PostModels>>(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
          }

          List<PostModels> posts = snapshot.data!;
          return _buildCommunityContent(posts, context);
        },
      ),
      endDrawer: SejenakSidebar(user: mySession),
      floatingActionButton: SejenakFloatingButton(
        onPressed: () => SejenakCreatePost(id: 1).showCreateContainer(context),
      ),
      bottomNavigationBar: SejenakNavbar(index: 1),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SejenakHeaderPage(
          text: "Komunitas",
          profile: mySession!.user!.profil,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SejenakCircular(),
                SizedBox(height: 16),
                SejenakText(
                  text: "Memuat cerita komunitas...",
                  type: SejenakTextType.small,
                  color: SejenakColor.stroke,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      children: [
        SejenakHeaderPage(
          text: "Komunitas",
          profile: mySession!.user!.profil,
        ),
        Expanded(
          child: SejenakError(
            message: error,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        SejenakHeaderPage(
          text: "Komunitas",
          profile: mySession!.user!.profil,
        ),
        
        // Community Stats
        _buildCommunityStats(0, 0, 0),
        
        // Empty State
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 80,
                  color: SejenakColor.stroke.withOpacity(0.3),
                ),
                SizedBox(height: 20),
                SejenakText(
                  text: "Komunitas Masih Sepi",
                  type: SejenakTextType.h4,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                SejenakText(
                  text: "Jadilah yang pertama berbagi cerita dan pengalaman untuk menginspirasi orang lain",
                  type: SejenakTextType.small,
                  color: SejenakColor.stroke,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: SejenakColor.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => SejenakCreatePost(id: 1).showCreateContainer(context),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: SejenakColor.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            SejenakText(
                              text: "Buat Post Pertama",
                              type: SejenakTextType.regular,
                              color: SejenakColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityContent(List<PostModels> posts, BuildContext context) {
    // Hitung statistik komunitas
    int totalLikes = posts.fold(0, (sum, post) => sum + (post.totalLike ?? 0));
    int totalComments = posts.fold(0, (sum, post) => sum + (post.totalComment ?? 0));
    int activeUsers = posts.map((post) => post.user?.id ?? 0).toSet().length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: SejenakHeaderPage(
            text: "Komunitas",
            profile: mySession!.user!.profil,
          ),
        ),
        
        // Community Stats
        SliverToBoxAdapter(
          child: _buildCommunityStats(totalLikes, totalComments, activeUsers),
        ),
        
        // Welcome Message
        SliverToBoxAdapter(
          child: _buildWelcomeMessage(),
        ),
        
        // Posts Header dengan sorting
        SliverToBoxAdapter(
          child: _buildPostsHeader(posts.length),
        ),
        
        // Posts List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var post = posts[index];
              return _buildPostItem(post, context);
            },
            childCount: posts.length,
          ),
        ),
        
        // Load More Indicator
        SliverToBoxAdapter(
          child: _buildLoadMoreIndicator(),
        ),
      ],
    );
  }

  Widget _buildCommunityStats(int totalLikes, int totalComments, int activeUsers) {
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
              icon: Icons.favorite_rounded,
              value: totalLikes.toString(),
              label: "Total Likes",
              color: Colors.red[400]!,
            ),
            _buildStatItem(
              icon: Icons.chat_bubble_rounded,
              value: totalComments.toString(),
              label: "Komentar",
              color: Colors.blue[400]!,
            ),
            _buildStatItem(
              icon: Icons.people_rounded,
              value: activeUsers.toString(),
              label: "Aktif",
              color: Colors.green[400]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
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

  Widget _buildWelcomeMessage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SejenakColor.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.0, color: SejenakColor.secondary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.emoji_objects_rounded,
              color: SejenakColor.secondary,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SejenakText(
                    text: "Selamat datang di Komunitas!",
                    type: SejenakTextType.regular,
                    fontWeight: FontWeight.bold,
                    color: SejenakColor.secondary,
                  ),
                  SizedBox(height: 4),
                  SejenakText(
                    text: "Bagikan pengalamanmu, beri dukungan, dan temukan inspirasi dari sesama",
                    type: SejenakTextType.small,
                    color: SejenakColor.stroke,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsHeader(int postCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SejenakText(
            text: "Cerita Komunitas",
            type: SejenakTextType.h5,
            fontWeight: FontWeight.bold,
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: SejenakColor.light,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: SejenakColor.stroke.withOpacity(0.2)),
          //   ),
          //   child: SejenakText(
          //     text: "$postCount Post",
          //     type: SejenakTextType.small,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPostItem(PostModels post, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SejenakPostContainer(
        title: post.title ?? "Judul Kosong",
        profile: post.user?.profil == null ? "" : "${API.endpointImage}storage/${post.user?.profil}",
        postImage: post.postPicture == null ? "" : "${API.endpointImage}storage/${post.postPicture}",
        text: post.deskripsiPost ?? "Tidak ada konten",
        likes: post.totalLike ?? 0,
        isAnonymous: post.isAnonymous ?? false,
        comment: post.totalComment ?? 0,
        name: post.user?.username ?? "anonymous",
        isLike: post.isLikedByMe(mySession?.user?.id),
        date: post.createdAt!.substring(0, 10),
        commentAction: () => SejenakDetailPost(post: post).showDetail(context),
        likeAction: (bool isLiked, int postID) async {
          comunityAction.likePost(isLiked, post.postId!);
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(16),
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
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: SejenakColor.secondary,
            size: 32,
          ),
          SizedBox(height: 8),
          SejenakText(
            text: "Kamu sudah sampai akhir!",
            type: SejenakTextType.regular,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          SejenakText(
            text: "Terima kasih telah menjadi bagian dari komunitas yang saling mendukung",
            type: SejenakTextType.small,
            color: SejenakColor.stroke,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: SejenakColor.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SejenakColor.secondary),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  // Refresh posts
                },
                child: Center(
                  child: SejenakText(
                    text: "Muat Ulang",
                    type: SejenakTextType.small,
                    color: SejenakColor.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}