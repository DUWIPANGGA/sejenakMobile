import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_container.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/session/user_session.dart';
import 'package:url_launcher/url_launcher.dart';

class Meditation extends StatelessWidget {
  final UserModels? user;

  Meditation({super.key}) : user = UserSession().user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: SejenakColor.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SejenakHeaderPage(
              text: "Meditasi",
              profile: user!.user!.profil,
            ),
          ),
          
          // Welcome Section
          SliverToBoxAdapter(
            child: _buildWelcomeSection(),
          ),
          
          // Daily White Noise
          SliverToBoxAdapter(
            child: _buildDailyWhiteNoise(),
          ),
          
          // White Noise Links
          SliverToBoxAdapter(
            child: _buildWhiteNoiseLinks(),
          ),
          
          // Breathing Exercises
          SliverToBoxAdapter(
            child: _buildBreathingExercises(context),
          ),
          
          // Grounding Exercises
          SliverToBoxAdapter(
            child: _buildGroundingExercises(context),
          ),
          
          // Meditation Summary
          SliverToBoxAdapter(
            child: _buildMeditationSummary(),
          ),
        ],
      ),
      endDrawer: SejenakSidebar(user: user),
      bottomNavigationBar: SejenakNavbar(index: 2),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // decoration: BoxDecoration(
      //   color: SejenakColor.primary.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(16),
      //   border: Border.all(
      //     width: 1.0,
      //     color: SejenakColor.secondary.withOpacity(0.3),
      //   ),
      // ),
      child: SejenakContainer(
        child: Row(
          children: [
            Icon(
              Icons.self_improvement_rounded,
              size: 40,
              color: SejenakColor.secondary,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SejenakText(
                    text: "Selamat Datang di Ruang Meditasi",
                    type: SejenakTextType.h5,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  SejenakText(
                    text: "Temukan kedamaian dan ketenangan melalui berbagai latihan mindfulness",
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

  Widget _buildDailyWhiteNoise() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SejenakText(
            text: "White Noise Hari Ini",
            type: SejenakTextType.h5,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: SejenakColor.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.0,
                color: SejenakColor.secondary.withOpacity(0.3),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _launchWhiteNoiseURL('https://www.youtube.com/results?search_query=rain+and+thunder+sounds+white+noise');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: SejenakColor.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.waves_rounded,
                          color: SejenakColor.primary,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SejenakText(
                              text: "Suara Hujan & Petir",
                              type: SejenakTextType.h5,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 4),
                            SejenakText(
                              text: "Ideal untuk relaksasi dan tidur nyenyak",
                              type: SejenakTextType.small,
                              color: SejenakColor.stroke,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.play_arrow_rounded,
                        color: SejenakColor.secondary,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          SejenakText(
            text: "Putar white noise ini untuk membantu menenangkan pikiran dan meningkatkan fokus",
            type: SejenakTextType.small,
            color: SejenakColor.stroke,
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteNoiseLinks() {
    final whiteNoiseTypes = [
      {
        'icon': Icons.nature_rounded,
        'title': 'Suara Alam',
        'subtitle': 'Hujan, ombak, angin',
        'url': 'https://www.youtube.com/results?search_query=nature+sounds+white+noise',
        'color': Colors.green,
      },
      {
        'icon': Icons.location_city_rounded,
        'title': 'Suara Perkotaan',
        'subtitle': 'Cafe, kota, hujan',
        'url': 'https://www.youtube.com/results?search_query=city+sounds+white+noise',
        'color': Colors.blue,
      },
      {
        'icon': Icons.music_note_rounded,
        'title': 'Suara Instrumental',
        'subtitle': 'Piano, gitar, flute',
        'url': 'https://www.youtube.com/results?search_query=instrumental+music+relaxation',
        'color': Colors.purple,
      },
      {
        'icon': Icons.psychology_rounded,
        'title': 'Suara Fokus',
        'subtitle': 'Brown noise, pink noise',
        'url': 'https://www.youtube.com/results?search_query=brown+noise+focus',
        'color': Colors.orange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SejenakText(
            text: "Jenis White Noise Lainnya",
            type: SejenakTextType.h5,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Column(
            children: whiteNoiseTypes.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.0,
                    color: (item['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _launchWhiteNoiseURL(item['url'] as String),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SejenakText(
                                  text: item['title'] as String,
                                  type: SejenakTextType.regular,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 4),
                                SejenakText(
                                  text: item['subtitle'] as String,
                                  type: SejenakTextType.small,
                                  color: SejenakColor.stroke,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingExercises(BuildContext context) {
    final breathingExercises = [
      {
        'icon': Icons.air_rounded,
        'title': '4-7-8 Breathing',
        'duration': '5 menit',
        'description': 'Teknik pernapasan untuk mengurangi kecemasan',
        'steps': 'Tarik napas 4 detik, tahan 7 detik, buang napas 8 detik',
        'color': Colors.teal,
      },
      {
        'icon': Icons.square_rounded,
        'title': 'Box Breathing',
        'duration': '4 menit',
        'description': 'Meningkatkan fokus dan ketenangan',
        'steps': 'Tarik napas 4 detik, tahan 4 detik, buang napas 4 detik, tahan 4 detik',
        'color': Colors.blue,
      },
      {
        'icon': Icons.self_improvement_rounded,
        'title': 'Deep Belly Breathing',
        'duration': '3 menit',
        'description': 'Relaksasi otot dan pikiran',
        'steps': 'Tarik napas dalam melalui hidung, buang perlahan melalui mulut',
        'color': Colors.green,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SejenakText(
            text: "Latihan Pernapasan",
            type: SejenakTextType.h5,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Column(
            children: breathingExercises.map((exercise) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: (exercise['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.0,
                    color: (exercise['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _showBreathingGuide(context, exercise);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            exercise['icon'] as IconData,
                            color: exercise['color'] as Color,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SejenakText(
                                      text: exercise['title'] as String,
                                      type: SejenakTextType.regular,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (exercise['color'] as Color).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SejenakText(
                                        text: exercise['duration'] as String,
                                        type: SejenakTextType.small,
                                        color: exercise['color'] as Color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SejenakText(
                                  text: exercise['description'] as String,
                                  type: SejenakTextType.small,
                                  color: SejenakColor.stroke,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroundingExercises(BuildContext context) {
    final groundingExercises = [
      {
        'icon': Icons.format_list_numbered_rounded,
        'title': '5-4-3-2-1 Technique',
        'duration': '3 menit',
        'description': 'Teknik grounding untuk mengatasi serangan panik',
        'steps': 'Sebutkan 5 hal yang dilihat, 4 hal yang dirasakan, 3 hal yang didengar, 2 hal yang dicium, 1 hal yang dikecap',
        'color': Colors.indigo,
      },
      {
        'icon': Icons.visibility_rounded,
        'title': 'Body Scan Meditation',
        'duration': '7 menit',
        'description': 'Meningkatkan kesadaran tubuh',
        'steps': 'Scan seluruh tubuh dari ujung kaki sampai kepala, perhatikan setiap sensasi',
        'color': Colors.purple,
      },
      {
        'icon': Icons.zoom_in_rounded,
        'title': 'Mindful Observation',
        'duration': '5 menit',
        'description': 'Latihan fokus dan perhatian',
        'steps': 'Pilih satu objek dan amati dengan detail selama 5 menit',
        'color': Colors.orange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SejenakText(
            text: "Latihan Grounding",
            type: SejenakTextType.h5,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Column(
            children: groundingExercises.map((exercise) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: (exercise['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.0,
                    color: (exercise['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _showGroundingGuide(context, exercise);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            exercise['icon'] as IconData,
                            color: exercise['color'] as Color,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SejenakText(
                                      text: exercise['title'] as String,
                                      type: SejenakTextType.regular,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (exercise['color'] as Color).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SejenakText(
                                        text: exercise['duration'] as String,
                                        type: SejenakTextType.small,
                                        color: exercise['color'] as Color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SejenakText(
                                  text: exercise['description'] as String,
                                  type: SejenakTextType.small,
                                  color: SejenakColor.stroke,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SejenakContainer(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SejenakText(
              text: "Ringkasan Meditasi",
              type: SejenakTextType.h5,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: SejenakColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1.0,
                  color: SejenakColor.secondary.withOpacity(0.3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          value: "12",
                          label: "Sesi\nMinggu Ini",
                          icon: Icons.self_improvement_rounded,
                          color: Colors.green,
                        ),
                        _buildSummaryItem(
                          value: "45",
                          label: "Total\nMenit",
                          icon: Icons.timer_rounded,
                          color: Colors.blue,
                        ),
                        _buildSummaryItem(
                          value: "7",
                          label: "Hari\nBerturut",
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SejenakColor.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: SejenakColor.stroke.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SejenakText(
                            text: "Pencapaian Terbaru",
                            type: SejenakTextType.regular,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8),
                          SejenakText(
                            text: "• Menyelesaikan 5 sesi breathing exercise berturut-turut",
                            type: SejenakTextType.small,
                            color: SejenakColor.stroke,
                          ),
                          SejenakText(
                            text: "• Total 45 menit meditasi minggu ini",
                            type: SejenakTextType.small,
                            color: SejenakColor.stroke,
                          ),
                          SejenakText(
                            text: "• Streak meditasi 7 hari",
                            type: SejenakTextType.small,
                            color: SejenakColor.stroke,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: 28,
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

  void _launchWhiteNoiseURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showBreathingGuide(BuildContext context, Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SejenakColor.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      exercise['icon'] as IconData,
                      color: exercise['color'] as Color,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    SejenakText(
                      text: exercise['title'] as String,
                      type: SejenakTextType.h5,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SejenakText(
                  text: exercise['description'] as String,
                  type: SejenakTextType.regular,
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (exercise['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (exercise['color'] as Color).withOpacity(0.3)),
                  ),
                  child: SejenakText(
                    text: "Langkah: ${exercise['steps']}",
                    type: SejenakTextType.small,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: exercise['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: SejenakText(
                          text: "Mulai Latihan",
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
        );
      },
    );
  }

  void _showGroundingGuide(BuildContext context, Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SejenakColor.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      exercise['icon'] as IconData,
                      color: exercise['color'] as Color,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    SejenakText(
                      text: exercise['title'] as String,
                      type: SejenakTextType.h5,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SejenakText(
                  text: exercise['description'] as String,
                  type: SejenakTextType.regular,
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (exercise['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (exercise['color'] as Color).withOpacity(0.3)),
                  ),
                  child: SejenakText(
                    text: "Langkah: ${exercise['steps']}",
                    type: SejenakTextType.small,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: exercise['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: SejenakText(
                          text: "Mulai Latihan",
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
        );
      },
    );
  }
}