import 'package:edunourish/core/utils/constants.dart';
import 'package:edunourish/features/Parent/core/utils/styles.dart';
import 'package:edunourish/features/Parent/core/widgets/base_scaffold.dart';
import 'package:edunourish/features/Parent/features/Grade/presentation/views/widgets/grade_column.dart';
import 'package:flutter/material.dart';
import 'subject_class.dart';

class GradeScreenBody extends StatefulWidget {
  final int initialIndex;
  const GradeScreenBody({super.key,required this.initialIndex});

  @override
  _GradeScreenBodyState createState() => _GradeScreenBodyState();
}

class _GradeScreenBodyState extends State<GradeScreenBody> {
  bool _firstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _firstLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = [
      Subject(
        name: "Arabic",
        assignmentGrade: 88,
        quizGrade: 85,
        finalGrade: 82,
      ),
      Subject(
        name: "Math",
        assignmentGrade: 85,
        quizGrade: 78,
        finalGrade: 90,
      ),
      Subject(
        name: "PE",
        assignmentGrade: 72,
        quizGrade: 80,
        finalGrade: 75,
      ),
      Subject(
        name: "Science",
        assignmentGrade: 78,
        quizGrade: 75,
        finalGrade: 80,
      ),
      Subject(
        name: "ICT",
        assignmentGrade: 95,
        quizGrade: 92,
        finalGrade: 88,
      ),
      Subject(
        name: "English",
        assignmentGrade: 83,
        quizGrade: 66,
        finalGrade: 89,
      ),
    ];

    return BaseScaffold(
      initialIndex: widget.initialIndex,
      appBartTitle: 'Grades',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final avgGrade = (subject.assignmentGrade +
                        subject.quizGrade +
                        subject.finalGrade) /
                    3;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GradeColumn(
                          label: 'Assignment',
                          grade: subject.assignmentGrade,
                          isAnimated: _firstLoad,
                        ),
                      ),
                      Expanded(
                        child: GradeColumn(
                          label: 'Quiz',
                          grade: subject.quizGrade,
                          isAnimated: _firstLoad,
                        ),
                      ),
                      Expanded(
                        child: GradeColumn(
                          label: 'Final',
                          grade: subject.finalGrade,
                          isAnimated: _firstLoad,
                        ),
                      ),
                      Expanded(
                        child: _buildSubjectColumn(subject.name, avgGrade),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectColumn(String subjectName, double avgGrade) {
    final letterGrade = _getLetterGrade(avgGrade);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 80, maxWidth: 110),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ourMainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            subjectName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: ourMainColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: ourMainColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            letterGrade,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: ourMainColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${avgGrade.toStringAsFixed(1)}%',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: ourMainColor),
        ),
      ],
    );
  }

  String _getLetterGrade(double grade) {
    if (grade >= 90) return 'A';
    if (grade >= 80) return 'B';
    if (grade >= 70) return 'C';
    if (grade >= 60) return 'D';
    return 'F';
  }
}
