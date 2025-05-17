import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;

  const CustomIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 28),
    );
  }
}
