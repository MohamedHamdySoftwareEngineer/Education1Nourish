// screens/home_student.dart
import 'dart:async';
import 'package:edunourish/core/models/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:edunourish/features/student/providers/student_provider.dart';
import 'attendance_screen.dart';
import 'exams_screen.dart';
import 'food_place_screen.dart';
import 'notifiactions_student_screen.dart';
import 'subject_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  _HomeStudentState createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    final prov = context.read<StudentProvider>();
    prov.newsList;

    _pageController = PageController(initialPage: _currentPage);

    prov.addListener(() {
      if (!prov.isLoading && prov.newsList.isNotEmpty && _timer == null) {
        _timer = Timer.periodic(const Duration(seconds: 3), (_) {
          if (!mounted) return;
          setState(() {
            _currentPage = (_currentPage + 1) % prov.newsList.length;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StudentProvider>();
    if (prov.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: Padding(
          padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: [
                // carousel placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 250,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // indicator placeholder
                Container(
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                // feature‐cards skeleton row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (_) => _shimmerCard()),
                ),
                const SizedBox(height: 20),
                // feature‐cards skeleton row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (_) => _shimmerCard()),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final newsList = prov.newsList;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff2f2f2),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 30),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NotificationsStudentScreen()),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Image(
              image: AssetImage('assets/Intro_Screen_login/EduIcon.png'),
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ◆ Carousel
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 250,
                color: const Color(0xff008f99),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: newsList.length, // dynamic length
                  itemBuilder: (_, index) {
                    final nm = newsList[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsPageStudent(
                            news: nm,
                          ),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(nm.photo, fit: BoxFit.cover),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                nm.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ◆ Page Indicator
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: newsList.length, // dynamic count
            effect: const ExpandingDotsEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor: Color(0xff008f99),
              dotColor: Color(0xff969696),
            ),
            onDotClicked: (i) => _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),

          // ◆ Feature Cards Row 1
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureCard(
                "assets/student/Home_Student/exam.png",
                "Exams",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamsScreen()),
                ),
              ),
              _buildFeatureCard(
                "assets/student/Home_Student/appointment.png",
                "Attendance",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                ),
              ),
            ],
          ),

          // ◆ Feature Cards Row 2
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureCard(
                "assets/student/Home_Student/restaurant.png",
                "Food Place",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FoodPlaceScreen()),
                ),
              ),
              _buildFeatureCard(
                "assets/student/Home_Student/book-stack.png",
                "My Subjects",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubjectScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable feature‐card builder
Widget _buildFeatureCard(String imagePath, String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff008f99), width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 100),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff008f99),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

// News detail page
class NewsPageStudent extends StatelessWidget {
  final News news;

  const NewsPageStudent({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          news.type,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              news.photo,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            news.title,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            news.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          Text(
            'Date: ${news.date.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xff008f99),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmerCard() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: 170,
      height: 170,
      color: Colors.white,
    ),
  );
}
