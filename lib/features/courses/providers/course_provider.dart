import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/models/home_models.dart';
import '../models/course_detailed_model.dart';

// --- State Classes ---

// 1. Categories
final categoriesProvider = Provider<List<String>>((ref) {
  return ["All", "JEE", "NEET", "UPSC", "Class 10", "Class 12", "Coding"];
});

// 2. Selected Category State
final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => "All";

  void setCategory(String category) {
    state = category;
  }
}


// 3. Filtered Courses (Uses Home/CourseModel for the list view)
final filteredCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1)); // Mock Delay
  final category = ref.watch(selectedCategoryProvider);
  
  // Return dummy list based on category (mock logic)
  return List.generate(10, (index) {
    return CourseModel(
      id: 'c_$index',
      title: category == "All" ? "Course Title $index" : "$category Mastery $index",
      imageUrl: "https://via.placeholder.com/300x200/${(index % 2 == 0) ? '0D47A1' : 'FF6F00'}/FFFFFF?text=Course+$index",
      educatorName: "Educator ${index + 1}",
      rating: 4.0 + (index % 10) / 10,
      price: index % 3 == 0 ? "Free" : "₹${(index + 1) * 500}",
    );
  });
});

// 4. Course Detail Provider (Family to fetch by ID)
final courseDetailProvider = FutureProvider.family<CourseDetail, String>((ref, id) async {
  await Future.delayed(const Duration(seconds: 1)); // Mock
  
  return CourseDetail(
    id: id,
    title: "Complete Flutter Development Bootcamp with Dart",
    subtitle: "Officially created in collaboration with the Google Flutter team.",
    thumbnailUrl: "https://via.placeholder.com/800x400/0288D1/FFFFFF?text=Flutter+Bootcamp",
    educatorName: "Dr. Angela Yu",
    educatorImage: "https://via.placeholder.com/100?text=A",
    educatorBio: "Angela is a developer and teacher. She is the lead instructor at the London App Brewery.",
    rating: 4.8,
    studentsEnrolled: 12500,
    price: "₹499",
    originalPrice: "₹3,999",
    discount: 88,
    whatYouWillLearn: [
      "Build beautiful, fast and native-quality apps",
      "Become a fully-fledged Flutter developer",
      "Build iOS and Android apps with a single codebase",
    ],
    chapters: [
      CourseChapter(
        id: "ch1",
        title: "Introduction to Flutter",
        duration: "30 Mins",
        lessons: [
          CourseLesson(
            id: "l1",
            title: "What is Flutter?",
            duration: "05:00",
            type: LessonType.video,
            contentUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4", // Sample Video
            isLocked: false,
          ),
          CourseLesson(
            id: "l2",
            title: "Setup on Windows",
            duration: "15:00",
            type: LessonType.video,
            contentUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
            isLocked: false,
          ),
          CourseLesson(
            id: "l3",
            title: "Course Resources",
            duration: "2 Pages",
            type: LessonType.pdf,
            contentUrl: "",
            isLocked: false,
          ),
        ],
      ),
      CourseChapter(
        id: "ch2",
        title: "Dart Basics",
        duration: "2 Hours",
        lessons: [
          CourseLesson(
             id: "l4",
             title: "Variables and Constants",
             duration: "20:00",
             type: LessonType.video,
             contentUrl: "",
             isLocked: true,
          ),
          CourseLesson(
             id: "l5",
             title: "Control Flow",
             duration: "25:00",
             type: LessonType.video,
             contentUrl: "",
             isLocked: true,
          ),
        ],
      ),
    ],
    reviews: [
      CourseReview(
        userName: "Rahul Kumar",
        userImage: "https://via.placeholder.com/50",
        rating: 5.0,
        comment: "Best course ever! Explained very clearly.",
        date: "2 days ago",
      ),
      CourseReview(
        userName: "Priya S.",
        userImage: "https://via.placeholder.com/50",
        rating: 4.5,
        comment: "Great content, but audio could be better.",
        date: "1 week ago",
      ),
    ],
  );
});
