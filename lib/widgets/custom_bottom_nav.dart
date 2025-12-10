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
          CustomPaint(
            size: const Size(double.infinity, 90),
            painter: BottomBarPainter(),
          ),

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
class BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.33, 0);

    path.quadraticBezierTo(
        size.width * 0.40, 0, size.width * 0.42, 20);
    path.arcToPoint(
      Offset(size.width * 0.58, 20),
      radius: const Radius.circular(36),
      clockwise: false,
    );
    path.quadraticBezierTo(
        size.width * 0.60, 0, size.width * 0.67, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black26, 12, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
