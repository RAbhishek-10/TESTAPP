import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_models.dart';

final homeProvider = FutureProvider<HomeData>((ref) async {
  // Simulate API Network Delay
  await Future.delayed(const Duration(seconds: 2));

  return HomeData(
    banners: [
      BannerModel(
        id: '1',
        imageUrl: 'https://via.placeholder.com/800x400/0D47A1/FFFFFF?text=Start+Your+Preparation',
        title: 'New Batch for JEE 2026',
      ),
      BannerModel(
        id: '2',
        imageUrl: 'https://via.placeholder.com/800x400/FF6F00/FFFFFF?text=Mock+Test+Series',
        title: 'All India Test Series',
      ),
    ],
    continueLearning: [
      CourseModel(
        id: 'c1',
        title: 'Advanced Mathematics',
        imageUrl: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Maths',
        educatorName: 'Dr. Sharma',
        rating: 4.8,
        price: '₹999',
        progress: 45,
      ),
      CourseModel(
        id: 'c2',
        title: 'Physics Mechanics',
        imageUrl: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Physics',
        educatorName: 'H.C. Verma (Fan)',
        rating: 4.9,
        price: '₹1499',
        progress: 10,
      ),
    ],
    recommendedCourses: [
      CourseModel(
        id: 'c3',
        title: 'Complete Python Bootcamp',
        imageUrl: 'https://via.placeholder.com/300x200/FFC107/000000?text=Python',
        educatorName: 'Jose Portilla',
        rating: 4.7,
        price: '₹499',
      ),
      CourseModel(
        id: 'c4',
        title: 'Flutter Masterclass',
        imageUrl: 'https://via.placeholder.com/300x200/0288D1/FFFFFF?text=Flutter',
        educatorName: 'Google Team',
        rating: 5.0,
        price: '₹2999',
      ),
       CourseModel(
        id: 'c5',
        title: 'Chemistry Organic',
        imageUrl: 'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=Chemistry',
        educatorName: 'Pankaj Sir',
        rating: 4.6,
        price: '₹1299',
      ),
    ],
    popularTests: [
      CourseModel(
        id: 't1',
        title: 'JEE Mains Mock 1',
        imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=JEE+Mock',
        educatorName: 'NTA Pattern',
        rating: 4.5,
        price: 'Free',
      ),
      CourseModel(
        id: 't2',
        title: 'NEET Biology Speed Test',
        imageUrl: 'https://via.placeholder.com/300x200/009688/FFFFFF?text=Biology',
        educatorName: 'Bio Experts',
        rating: 4.8,
        price: '₹99',
      ),
    ],
    topEducators: [
      EducatorModel(id: 'e1', name: 'Alakh P.', imageUrl: 'https://via.placeholder.com/100/FF5722/FFFFFF?text=AP', subject: 'Physics'),
      EducatorModel(id: 'e2', name: 'Khan Sir', imageUrl: 'https://via.placeholder.com/100/3F51B5/FFFFFF?text=KS', subject: 'GS'),
      EducatorModel(id: 'e3', name: 'Vikas D.', imageUrl: 'https://via.placeholder.com/100/607D8B/FFFFFF?text=VD', subject: 'History'),
      EducatorModel(id: 'e4', name: 'Aman D.', imageUrl: 'https://via.placeholder.com/100/FFC107/000000?text=AD', subject: 'Coding'),
    ],
  );
});
