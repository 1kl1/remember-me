import 'package:flutter/material.dart';
import 'utils/date_util.dart';
import 'widgets/custom_icon_button.dart';
import 'widgets/memory_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateText =
        "Good evening, today is ${getWeekday(today.weekday)},\n${getMonth(today.month)} ${today.day}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.menu, color: Colors.teal),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(dateText, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            MemoryCard(),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(icon: Icons.mic),
                CustomIconButton(icon: Icons.camera_alt),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.teal,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ""),
        ],
      ),
    );
  }
}
