import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 50 + kToolbarHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey.shade300,
                  ),
                  child: Tab(icon: Icon(Icons.mic)),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 50 + kToolbarHeight,
                  child: Tab(icon: Icon(Icons.chat)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
