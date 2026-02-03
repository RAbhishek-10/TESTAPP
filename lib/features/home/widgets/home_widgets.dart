import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../models/home_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';

// --- Carousel Widget ---
class HomeBannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  const HomeBannerCarousel({super.key, required this.banners});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 188.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOutCubic,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            initialPage: 0,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
                    boxShadow: AppTheme.cardShadowList,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
                    child: Stack(
                      children: [
                        appCachedImage(
                          imageUrl: banner.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.accentGradient,
                                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                                ),
                                child: Text(
                                  "Enrol Now",
                                  style: AppTheme.captionStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withOpacity(_currentIndex == entry.key ? 0.9 : 0.2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// --- Quick Actions Grid ---
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.quiz_rounded, 'label': 'Mock Test', 'color': Color(0xFFF59E0B), 'route': '/tests'},
      {'icon': Icons.live_tv_rounded, 'label': 'Live Class', 'color': Color(0xFFEF4444), 'route': '/live'},
      {'icon': Icons.history_edu_rounded, 'label': 'PYQs', 'color': Color(0xFF3B82F6), 'route': '/tests'},
      {'icon': Icons.bookmark_rounded, 'label': 'Bookmarks', 'color': Color(0xFF10B981), 'route': '/profile'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return InkWell(
            onTap: () => context.push(action['route'] as String),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            child: Column(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    border: Border.all(color: (action['color'] as Color).withOpacity(0.15), width: 1.5),
                  ),
                  child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  action['label'] as String,
                  style: AppTheme.captionStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- Section Header ---
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.titleStyle.copyWith(fontSize: 18),
          ),
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "See All",
                style: AppTheme.captionStyle.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Course Card ---
class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isHorizontal;

  const CourseCard({super.key, required this.course, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(left: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadowList,
        border: Border.all(color: AppTheme.textGrey.withOpacity(0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/course/${course.id}'),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with Rating Tag
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
                    child: appCachedImage(
                      imageUrl: course.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppTheme.secondaryOrange),
                          const SizedBox(width: 2),
                          Text(
                            course.rating.toString(),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.educatorName,
                      style: AppTheme.captionStyle,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                    if (course.progress != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress! / 100,
                          backgroundColor: AppTheme.bgLight,
                          color: AppTheme.primaryBlue,
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${course.progress}% Completed",
                        style: const TextStyle(fontSize: 10, color: AppTheme.textGrey, fontWeight: FontWeight.w600),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Horizontal List Builder ---
class HorizontalCourseList extends StatelessWidget {
  final List<CourseModel> courses;
  const HorizontalCourseList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 16),
        itemCount: courses.length,
        itemBuilder: (context, index) => CourseCard(course: courses[index]),
      ),
    );
  }
}

// --- Educator Avatar List ---
class EducatorList extends StatelessWidget {
  final List<EducatorModel> educators;
  const EducatorList({super.key, required this.educators});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: educators.length,
        itemBuilder: (context, index) {
          final edu = educators[index];
          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2), width: 2),
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      width: 74,
                      height: 74,
                      child: appCachedImage(
                        imageUrl: edu.imageUrl,
                        width: 74,
                        height: 74,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(37),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  edu.name,
                  style: AppTheme.captionStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  edu.subject,
                  style: AppTheme.captionStyle.copyWith(fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Loading Shimmer ---
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.textGrey.withOpacity(0.2),
      highlightColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(height: 188, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge))),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(4, (index) => Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppTheme.cardRadius))))),
            const SizedBox(height: 24),
            Container(height: 250, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge))),
          ],
        ),
      ),
    );
  }
}
