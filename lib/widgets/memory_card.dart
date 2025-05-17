import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFF0DC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFFFCC),
            foregroundColor: Colors.black,
          ),
          onPressed: () {},
          child: Text("View Memories"),
        ),
      ),
    );
  }
}
