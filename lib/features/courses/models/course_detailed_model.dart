// Models for Course Section

class CourseDetail {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final String educatorName;
  final String educatorImage;
  final String educatorBio;
  final double rating;
  final int studentsEnrolled;
  final String price;
  final String originalPrice;
  final int discount; // Percentage
  final List<String> whatYouWillLearn;
  final List<CourseChapter> chapters;
  final List<CourseReview> reviews;

  CourseDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.educatorName,
    required this.educatorImage,
    required this.educatorBio,
    required this.rating,
    required this.studentsEnrolled,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.whatYouWillLearn,
    required this.chapters,
    required this.reviews,
  });
}

class CourseChapter {
  final String id;
  final String title;
  final String duration;
  final List<CourseLesson> lessons;

  CourseChapter({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessons,
  });
}

enum LessonType { video, pdf, quiz }

class CourseLesson {
  final String id;
  final String title;
  final String duration; // e.g., "10:00" or "5 Pages"
  final LessonType type;
  final String contentUrl; // Video URL or PDF URL
  final bool isLocked;

  CourseLesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.type,
    required this.contentUrl,
    this.isLocked = true,
  });
}

class CourseReview {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String date;

  CourseReview({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
