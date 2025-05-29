
import 'package:edunourish/features/Parent/core/utils/assets.dart';
import 'package:edunourish/core/utils/constants.dart';
import 'package:edunourish/features/Parent/core/widgets/base_scaffold.dart';
import 'package:edunourish/features/Parent/features/Teacher%20Screen/data/models/teacher_model.dart';

import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class TeacherScreenBody extends StatelessWidget {
  final List<TeacherData> teachers;
  
  const TeacherScreenBody({super.key,required this.teachers});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBartTitle: "Teachers",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  return TeacherCard(teacher: teachers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final TeacherData teacher;

  const TeacherCard({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Teacher Image at the top
            CircleAvatar(
              radius: 60,
              child: ClipOval(
                child: Image.asset(
                  teacherImage,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey.shade700,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Teacher Info
            // Subject Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: ourMainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                teacher.subject.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            // Teacher Name
            Text(
              teacher.username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Teacher Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    teacher.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
          ],
        ),
      ),
    );
  }
}