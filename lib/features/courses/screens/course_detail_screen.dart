import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/course_provider.dart';
import '../models/course_detailed_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_error_state.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));

    return Scaffold(
      body: courseAsync.when(
        data: (course) => _buildBody(context, course),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text('Loading course…', style: TextStyle(fontSize: 14, color: AppTheme.textGrey)),
            ],
          ),
        ),
        error: (err, stack) => EmptyErrorState(
          message: 'Course unavailable',
          subtitle: 'This course couldn\'t be loaded. Try again.',
          icon: Icons.school_outlined,
          onRetry: () => ref.invalidate(courseDetailProvider(courseId)),
        ),
      ),
      bottomNavigationBar: courseAsync.hasValue
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: AppTheme.textGrey.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseAsync.value!.price,
                        style: AppTheme.titleStyle.copyWith(fontSize: 20),
                      ),
                      Text(
                        courseAsync.value!.originalPrice,
                        style: AppTheme.captionStyle.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enrolled Successfully!")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                      ),
                      child: Text("Enroll Now", style: AppTheme.bodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  )
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, CourseDetail course) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                appCachedImage(
                  imageUrl: course.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
            IconButton(icon: const Icon(Icons.bookmark_border_rounded), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Subtitle
                Text(course.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(course.subtitle, style: const TextStyle(fontSize: 14, color: AppTheme.textGrey)),
                const SizedBox(height: 16),
                
                // Stats
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text("${course.rating} Rating", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    const Icon(Icons.people_rounded, color: AppTheme.textGrey, size: 20),
                    const SizedBox(width: 4),
                    Text("${course.studentsEnrolled} Learners", style: const TextStyle(color: AppTheme.textGrey)),
                  ],
                ),
                 const SizedBox(height: 24),

                // Instructor
                _buildSectionTitle("Instructor"),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipOval(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: appCachedImage(
                        imageUrl: course.educatorImage,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  title: Text(course.educatorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(course.educatorBio, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: OutlinedButton(onPressed: (){}, child: const Text("View Profile")),
                ),
                const SizedBox(height: 24),

                // Learning Outcomes
                _buildSectionTitle("What you'll learn"),
                const SizedBox(height: 8),
                ...course.whatYouWillLearn.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(text)),
                    ],
                  ),
                )),
                const SizedBox(height: 24),

                // Curriculum
                _buildSectionTitle("Course Content"),
                const SizedBox(height: 8),
                ...course.chapters.map((chapter) => _buildChapterTile(context, chapter, course.id)),

                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTheme.titleStyle.copyWith(fontSize: 18));
  }

  Widget _buildChapterTile(BuildContext context, CourseChapter chapter, String courseId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
        side: BorderSide(color: AppTheme.textGrey.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        title: Text(chapter.title, style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(chapter.duration, style: AppTheme.captionStyle),
        children: chapter.lessons.map((lesson) => ListTile(
          leading: Icon(
            lesson.type == LessonType.video ? Icons.play_circle_outline : Icons.description,
            color: lesson.isLocked ? Colors.grey : AppTheme.primaryOrange,
          ),
          title: Text(lesson.title),
          subtitle: Text(lesson.duration),
          trailing: lesson.isLocked ? const Icon(Icons.lock, size: 18, color: Colors.grey) : null,
          onTap: !lesson.isLocked ? () {
            context.push('/course/$courseId/lesson/${lesson.id}');
          } : null,
        )).toList(),
      ),
    );
  }
}
