import 'package:flutter/material.dart';
import 'package:edunourish/core/models/grades.dart';
import '../../../../core/widgets/base_scaffold.dart';

class GradeScreen extends StatelessWidget {
  final int initialIndex;
  const GradeScreen({super.key , required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Example static data (you can remove or replace this)
    final grades = [
  Grades(examId: 'French_Assignment', obtainedMarks: '80', grade: 'A', studentIDg: '1'),
  Grades(examId: 'Math_Quiz',       obtainedMarks: '65', grade: 'C', studentIDg: '1'),
  Grades(examId: 'Science_Final',   obtainedMarks: '90', grade: 'A+', studentIDg: '1'),
  Grades(examId: 'Arabic_Assignment', obtainedMarks: '75', grade: 'B', studentIDg: '1'),
  Grades(examId: 'PE_Quiz',         obtainedMarks: '85', grade: 'A', studentIDg: '1'),
];


    if (grades.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No grades available.')),
      );
    }

    return BaseScaffold(
       appBartTitle: 'Grades',
       initialIndex: initialIndex,
       child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: grades.length,
        itemBuilder: (context, i) => GradeCard(grade: grades[i]),
      ),
    );
  }
}

class GradeCard extends StatelessWidget {
  final Grades grade;
  const GradeCard({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "French",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green.shade50,
                  child: Text(
                    grade.grade,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Icons.assignment, 'Assignment', 80),
                _buildStat(Icons.help_outline, 'Quiz', 50),
                _buildStat(Icons.school, 'Final', 70),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, double value) {
    final color = Colors.teal;
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Text('${value.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
