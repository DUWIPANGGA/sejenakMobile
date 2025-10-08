import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_container.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/partial/main/sejenak_header_page.dart';
import 'package:selena/app/partial/main/sejenak_sidebar.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/meditation_models/meditation_models.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/services/meditation/meditation_service.dart'; // import service kamu
import 'package:selena/session/user_session.dart';
import 'package:url_launcher/url_launcher.dart';

class Meditation extends StatefulWidget {
  final UserModels? user;
final Future<MeditationService> serviceFuture;
  Meditation({super.key}) : user = UserSession().user,
        serviceFuture = MeditationService.create();

  @override
  State<Meditation> createState() => _MeditationState();
}


class _MeditationState extends State<Meditation> {
MeditationModels? dailyMeditation;
  late MeditationService service;
  bool isServiceReady = false;
 bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    service = await MeditationService.create();
    setState(() {
      isServiceReady = true;
    });
    _fetchDailyMeditation();
  }
  Future<void> _fetchDailyMeditation() async {
  try {
    final result = await service.getDailyMeditation();
    setState(() {
      dailyMeditation = result;
      isLoading = false;
    });
  } catch (e) {
    print('❌ Error fetching daily meditation: $e');
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SejenakHeaderPage(
              text: "Meditasi",
              profile: user?.user?.profil,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildWelcomeSection(),
          ),
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
          SliverToBoxAdapter(
            child: _buildDailyWhiteNoise(),
          ),
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SejenakContainer(
        child: Row(
          children: [
            const Icon(Icons.self_improvement_rounded, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SejenakText(
                    text: "Selamat Datang di Ruang Meditasi",
                    type: SejenakTextType.h5,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  SejenakText(
                    text:
                        "Temukan kedamaian dan ketenangan melalui latihan mindfulness",
                    type: SejenakTextType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              title: "Start Meditation",
              subtitle: "Latihan mindfulness",
              icon: Icons.spa_rounded,
              color: SejenakColor.primary,
              onTap: () {
                // Navigate to meditation page
                _navigateToMeditationPage();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              title: "Start Exercise",
              subtitle: "Latihan pernapasan",
              icon: Icons.fitness_center_rounded,
              color: SejenakColor.secondary,
              onTap: () {
                // Navigate to exercise page
                _navigateToExercisePage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.0,
          color: color.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                SejenakText(
                  text: title,
                  type: SejenakTextType.small,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                SejenakText(
                  text: subtitle,
                  type: SejenakTextType.regular,
                  color: SejenakColor.stroke,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyWhiteNoise() {
  return StreamBuilder<PlaybackState?>(
    stream: service.handler.playbackStateStream,
    builder: (context, snapshot) {
      final state = snapshot.data;
      final processingState = state?.processingState ?? AudioProcessingState.idle;
      final isPlaying = state?.playing ?? false;
      final isLoading = processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering;

      if (isLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (errorMessage != null) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SejenakText(
            text: "Gagal memuat data meditasi: $errorMessage",
            type: SejenakTextType.small,
            color: Colors.red,
          ),
        );
      }

      if (dailyMeditation == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: SejenakText(
            text: "Belum ada meditasi harian untuk hari ini.",
            type: SejenakTextType.small,
          ),
        );
      }

      final title = dailyMeditation!.title;
      final desc = "Nikmati sesi ${dailyMeditation!.category} hari ini";

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
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
                    child: const Icon(
                      Icons.spa_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SejenakText(
                          text: title,
                          type: SejenakTextType.h5,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        SejenakText(
                          text: desc,
                          type: SejenakTextType.small,
                          color: SejenakColor.stroke,
                        ),
                      ],
                    ),
                  ),
                  // 🎧 Tombol kontrol audio
                  if (isLoading)
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  else if (isPlaying)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.pause_rounded,
                              color: Colors.black54, size: 30),
                          onPressed: () async => await service.pauseAudio(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop_rounded,
                              color: Colors.redAccent, size: 30),
                          onPressed: () async => await service.stopAudio(),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded,
                          color: Colors.black54, size: 30),
                      onPressed: () async {
                        await service.playAudio(dailyMeditation!);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildMeditationSummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SejenakText(
        text: "Ringkasan Meditasi (coming soon...)",
        type: SejenakTextType.small,
        color: SejenakColor.stroke,
      ),
    );
  }

  Future<void> _launchWhiteNoiseURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _navigateToMeditationPage() {
    // TODO: Implement navigation to meditation page
    // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationListPage()));
    print('Navigate to meditation page');
  }

  void _navigateToExercisePage() {
    // TODO: Implement navigation to exercise page
    // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseListPage()));
    print('Navigate to exercise page');
  }
}