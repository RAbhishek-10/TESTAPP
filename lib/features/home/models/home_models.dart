// Models for Home Data

class HomeData {
  final List<BannerModel> banners;
  final List<CourseModel> continueLearning;
  final List<CourseModel> recommendedCourses;
  final List<CourseModel> popularTests;
  final List<EducatorModel> topEducators;

  HomeData({
    required this.banners,
    required this.continueLearning,
    required this.recommendedCourses,
    required this.popularTests,
    required this.topEducators,
  });
}

class BannerModel {
  final String id;
  final String imageUrl;
  final String title;

  BannerModel({required this.id, required this.imageUrl, required this.title});
}

class CourseModel {
  final String id;
  final String title;
  final String imageUrl;
  final String educatorName;
  final double rating;
  final String price;
  final int? progress; // 0-100 for continue learning

  CourseModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.educatorName,
    required this.rating,
    required this.price,
    this.progress,
  });
}

class EducatorModel {
  final String id;
  final String name;
  final String imageUrl;
  final String subject;

  EducatorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.subject,
  });
}
