import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../core/theme/app_theme.dart';

class LessonPlayerScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerScreen({super.key, required this.courseId, required this.lessonId});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> with TickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    const videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      showControls: true,
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: AppTheme.primaryBlue,
        handleColor: AppTheme.primaryBlue,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white54,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: AppTheme.primaryBlue,
        handleColor: AppTheme.primaryBlue,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white54,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off_rounded, color: Colors.white.withOpacity(0.9), size: 48),
              const SizedBox(height: 12),
              Text(
                'Video unavailable',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Learning Mode", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Premium Video Player Area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                  : Chewie(controller: _chewieController!),
            ),
          ),

          // Content Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.textGrey,
              indicatorColor: AppTheme.primaryBlue,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Resources"),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildResourcesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          "01. Introduction to Mobile Architecture",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textDark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 12),
        const Text(
          "In this session, we deep dive into the fundamental principles of mobile application architecture. We explore how Flutter manages widgets under the hood and why it's a revolutionary choice for cross-platform development.",
          style: TextStyle(color: AppTheme.textGrey, fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 32),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             _buildActionButton(Icons.thumb_up, "1.2k Likes", Colors.blue),
             _buildActionButton(Icons.share, "Share", Colors.indigo),
             _buildActionButton(Icons.file_download, "Download", Colors.teal),
          ],
        ),
        
        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 24),
        
        const Text("Table of Contents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        _buildTimelineItem("02:15", "Architecture Overview", true),
        _buildTimelineItem("10:45", "Widget Tree Deep Dive", false),
        _buildTimelineItem("24:10", "State Management Patterns", false),
        _buildTimelineItem("45:00", "Production Best Practices", false),
      ],
    );
  }

  Widget _buildTimelineItem(String time, String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.bgLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          if (isCompleted) 
            const Icon(Icons.check_circle, color: Colors.green, size: 20)
          else 
            const Icon(Icons.play_circle_outline, color: AppTheme.textGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textGrey)),
      ],
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildResourceItem("Lesson_Slides.pdf", "2.4 MB", Icons.picture_as_pdf, Colors.red),
        _buildResourceItem("Sample_Code.zip", "15.8 MB", Icons.folder_zip, Colors.orange),
        _buildResourceItem("Reading_List.txt", "12 KB", Icons.description, Colors.blue),
      ],
    );
  }

  Widget _buildResourceItem(String name, String size, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(size, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
              ],
            ),
          ),
          const Icon(Icons.download, color: AppTheme.textGrey),
        ],
      ),
    );
  }
}
