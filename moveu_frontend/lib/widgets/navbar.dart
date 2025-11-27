import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF40B59F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF37A18D), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(
            index: 0,
            icon: Icons.home,
            isSelected: currentIndex == 0,
          ),
          _navItem(
            index: 1,
            icon: Icons.history,
            isSelected: currentIndex == 1,
          ),
          _navItem(
            index: 2,
            icon: Icons.person,
            isSelected: currentIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
