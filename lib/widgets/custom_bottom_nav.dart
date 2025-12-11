import 'package:flutter/material.dart';

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
       

          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => _buildNavItem(
                  index,
                  currentIndex == index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, bool selected) {
    const items = [
      _NavItem(icon: Icons.home_outlined, label: "Home"),
      _NavItem(icon: Icons.dashboard_outlined, label: "Music"),
      _NavItem(icon: Icons.favorite_border, label: "Wishlist"),
      _NavItem(icon: Icons.person_outline, label: "Profile"),
    ];

    final item = items[index];
    final color = selected ? const Color(0xFF7A4DFF) : Colors.grey;

    return GestureDetector(
      onTap: () => onChanged(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: color,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
