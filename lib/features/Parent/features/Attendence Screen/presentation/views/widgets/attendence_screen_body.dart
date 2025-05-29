import 'package:edunourish/core/utils/constants.dart';
import 'package:edunourish/features/Parent/core/widgets/base_scaffold.dart';
import 'package:edunourish/features/Parent/core/widgets/child_profile_card.dart';
import 'package:flutter/material.dart';

class AttendenceScreenBody extends StatefulWidget {
  const AttendenceScreenBody({super.key});

  @override
  State<AttendenceScreenBody> createState() => _AttendenceScreenBodyState();
}

class _AttendenceScreenBodyState extends State<AttendenceScreenBody> {
  DateTime selectedDate = DateTime.now();
  List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int selectedDay = DateTime.now().day;
  
  // Sample data - replace with your backend data
  final Map<String, dynamic> student = {
    'name': 'John Doe',
    'username': 'john_doe_2024',
    'year': '2023-2024',
    'grade': 'Grade 10'
  };

  final Map<String, Map<String, dynamic>> attendance = {
    '1': {'status': 'Present', 'time': '08:00 AM', 'remarks': 'On time'},
    '4': {'status': 'Absent', 'time': '-', 'remarks': 'Sick leave'},
    '5': {'status': 'Present', 'time': '07:55 AM', 'remarks': 'Early'},
  };

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    return BaseScaffold(
      appBartTitle: 'Attendance',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ChildProfileCard(),
              const SizedBox(height: 16),
              _buildMonthSelector(width),
              const SizedBox(height: 16),
              _buildCalendar(width),
              const SizedBox(height: 16),
              _buildAttendanceDetails(width),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildMonthSelector(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
              selectedDay = -1;
            }),
            icon: const Icon(Icons.arrow_back_ios, color: ourMainColor),
          ),
          Text('${_getMonthName(selectedDate.month)} ${selectedDate.year}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
              selectedDay = -1;
            }),
            icon: const Icon(Icons.arrow_forward_ios, color: ourMainColor),
          ),
        ],
      ),
    );
  }
 

Widget _buildCalendar(double width) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Days of week header
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: daysOfWeek.map((day) {
                return Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: day == 'Sat' || day == 'Fri'
                          ? ourMainColor
                          : Colors.grey.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Calendar days grid
          _buildCalendarGrid(),
        ],
      ),
    ),
  );
}

// Builds the calendar grid for the current month
Widget _buildCalendarGrid() {
  int year = selectedDate.year;
  int month = selectedDate.month;
  int daysInMonth = DateTime(year, month + 1, 0).day;
  int firstWeekday = DateTime(year, month, 1).weekday; // 1 (Mon) to 7 (Sun)
  int leadingEmpty = firstWeekday - 1;

  List<Widget> rows = [];
  List<Widget> days = [];

  // Fill leading empty days
  for (int i = 0; i < leadingEmpty; i++) {
    days.add(buildDayContainer(''));
  }

  // Fill calendar days
  for (int day = 1; day <= daysInMonth; day++) {
    DateTime thisDay = DateTime(year, month, day);
    bool isToday = thisDay.day == DateTime.now().day &&
        thisDay.month == DateTime.now().month &&
        thisDay.year == DateTime.now().year;

    bool isSelected = selectedDay == day &&
        selectedDate.month == selectedDate.month &&
        selectedDate.year == selectedDate.year;

    days.add(
      buildDayContainer(
        day.toString(),
        isSelected: isSelected,
        isToday: isToday,
        onTap: () {
          setState(() {
            selectedDay = day;
            selectedDate = DateTime(year, month, day);
          });
        },
      ),
    );

    // When 7 days are filled, add to rows and reset
    if (days.length == 7) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.from(days),
      ));
      days.clear();
    }
  }

  // Handle the final row (incomplete week)
  if (days.isNotEmpty) {
    while (days.length < 7) {
      days.add(buildDayContainer(''));
    }
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days,
    ));
  }

  return Column(
    children: rows,
  );
}


Widget buildDayContainer(
  String text, {
  bool isSelected = false,
  bool isToday = false,
  VoidCallback? onTap,
}) {
  bool isEmpty = text.isEmpty;

  return GestureDetector(
    onTap: isEmpty ? null : onTap,
    child: Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? ourMainColor
            : isToday
                ? const Color(0xFFF0EDFF)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isToday && !isSelected
            ? Border.all(color: ourMainColor, width: 1)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isEmpty
              ? Colors.transparent
              : isSelected
                  ? Colors.white
                  : Colors.grey.shade800,
        ),
      ),
    ),
  );
}



  Widget _buildAttendanceDetails(double width) {
    String dayKey = selectedDay.toString();
    Map<String, dynamic>? data = attendance[dayKey];
    
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Text(
            selectedDay > 0 ? '$selectedDay ${_getMonthName(selectedDate.month)} ${selectedDate.year}' : 'Select Date',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ourMainColor),
          ),
          const SizedBox(height: 16),
          if (data != null) ...[
            Icon(_getStatusIcon(data['status']), size: 48, color: _getStatusColor(data['status'])),
            const SizedBox(height: 8),
            Text(data['status'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getStatusColor(data['status']))),
            const SizedBox(height: 16),
            _buildDetailRow('Remarks:', data['remarks']),
          ] else if (selectedDay > 0) ...[
            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text('No Data', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ] else ...[
            const Icon(Icons.calendar_today, size: 48, color: ourMainColor),
            const SizedBox(height: 8),
            const Text('Tap a date to view details', style: TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'present': return Colors.green;
      case 'absent': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'present': return Icons.check_circle;
      case 'absent': return Icons.cancel;
      default: return Icons.help;
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}