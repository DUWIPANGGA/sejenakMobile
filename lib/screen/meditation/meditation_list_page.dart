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
import 'package:selena/services/meditation/meditation_service.dart';
import 'package:selena/session/user_session.dart';

class MeditationListPage extends StatefulWidget {
  final UserModels? user;
  final Future<MeditationService> serviceFuture = MeditationService.create();

  MeditationListPage({super.key}) : user = UserSession().user;

  @override
  State<MeditationListPage> createState() => _MeditationListPageState();
}

class _MeditationListPageState extends State<MeditationListPage> {
  late MeditationService service;
  bool isServiceReady = false;
  bool isLoading = true;
  String? errorMessage;
  List<MeditationModels> meditationAudios = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    try {
      service = await MeditationService.create();
      setState(() {
        isServiceReady = true;
      });
      await _fetchMeditationAudios();
    } catch (e) {
      print('❌ Error initializing service: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMeditationAudios() async {
    try {
      final result = await service.getAudios();
      setState(() {
        meditationAudios = result;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching meditation audios: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<MeditationModels> get filteredAudios {
    if (searchQuery.isEmpty) {
      return meditationAudios;
    }
    return meditationAudios.where((audio) {
      return audio.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          audio.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (audio.title.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
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
              text: "Daftar Meditasi",
              profile: user?.user?.profil,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSearchSection(),
          ),
          _buildMeditationList(),
        ],
      ),
      endDrawer: SejenakSidebar(user: user),
      bottomNavigationBar: SejenakNavbar(index: 2),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SejenakContainer(
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Cari meditasi...",
            hintStyle: TextStyle(color: SejenakColor.stroke),
            prefixIcon: Icon(Icons.search, color: SejenakColor.stroke),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationList() {
    if (!isServiceReady || isLoading) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                CircularProgressIndicator(color: SejenakColor.primary),
                const SizedBox(height: 16),
                SejenakText(
                  text: "Memuat audio meditasi...",
                  type: SejenakTextType.small,
                  color: SejenakColor.stroke,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              SejenakText(
                text: "Gagal memuat data meditasi",
                type: SejenakTextType.h5,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              SejenakText(
                text: errorMessage!,
                type: SejenakTextType.small,
                color: SejenakColor.stroke,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchMeditationAudios,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SejenakColor.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredAudios.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.audiotrack_rounded, size: 48, color: SejenakColor.stroke),
              const SizedBox(height: 16),
              SejenakText(
                text: searchQuery.isEmpty ? "Belum ada audio meditasi" : "Tidak ditemukan",
                type: SejenakTextType.h5,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              SejenakText(
                text: searchQuery.isEmpty 
                  ? "Audio meditasi akan segera tersedia"
                  : "Coba kata kunci lain",
                type: SejenakTextType.small,
                color: SejenakColor.stroke,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final audio = filteredAudios[index];
          return _buildAudioItem(audio, index);
        },
        childCount: filteredAudios.length,
      ),
    );
  }

  Widget _buildAudioItem(MeditationModels audio, int index) {
    return StreamBuilder<MediaItem?>(
      stream: service.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final currentMediaItem = mediaSnapshot.data;
        final isCurrentAudio = currentMediaItem?.title == audio.title;

        return StreamBuilder<PlaybackState>(
          stream: service.playbackState,
          builder: (context, stateSnapshot) {
            final playbackState = stateSnapshot.data;
            final isPlaying = playbackState?.playing ?? false;
            final isCurrentPlaying = isCurrentAudio && isPlaying;
            final isLoading = playbackState?.processingState == AudioProcessingState.loading ||
                playbackState?.processingState == AudioProcessingState.buffering;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SejenakContainer(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      if (isCurrentAudio && isPlaying) {
                        await service.pauseAudio();
                      } else if (isCurrentAudio && !isPlaying) {
                        await service.resumeAudio();
                      } else {
                        await service.playAudio(audio);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Number indicator
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: SejenakColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: SejenakColor.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: isCurrentPlaying
                                  ? Icon(Icons.equalizer_rounded, 
                                      color: SejenakColor.primary, size: 20)
                                  : SejenakText(
                                      text: '${index + 1}',
                                      type: SejenakTextType.small,
                                      fontWeight: FontWeight.bold,
                                      color: SejenakColor.primary,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Audio info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SejenakText(
                                  text: audio.title,
                                  type: SejenakTextType.h5,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (audio.category.isNotEmpty)
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: SejenakColor.secondary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: SejenakText(
                                          text: audio.category,
                                          type: SejenakTextType.small,
                                          color: SejenakColor.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (audio.title?.isNotEmpty ?? false) ...[
                                  const SizedBox(height: 4),
                                  SejenakText(
                                    text: audio.title!,
                                    type: SejenakTextType.small,
                                    color: SejenakColor.stroke,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Play/Pause button
                          if (isCurrentAudio && isLoading)
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: SejenakColor.primary,
                              ),
                            )
                          else
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isCurrentPlaying 
                                    ? SejenakColor.primary 
                                    : SejenakColor.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCurrentPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: isCurrentPlaying ? Colors.white : SejenakColor.primary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}