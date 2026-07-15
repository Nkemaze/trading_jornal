import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xB3131313),
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              filledIcon: Icons.home,
              label: 'Home',
              index: 0,
              isSelected: navProvider.currentBottomNavIndex == 0,
              onTap: () => navProvider.setBottomNavIndex(0),
            ),
            _buildNavItem(
              icon: Icons.query_stats,
              label: 'Journal',
              index: 1,
              isSelected: navProvider.currentBottomNavIndex == 1,
              onTap: () => navProvider.setBottomNavIndex(1),
            ),
            _buildNavItem(
              icon: Icons.notifications,
              label: 'Alerts',
              index: 2,
              isSelected: navProvider.currentBottomNavIndex == 2,
              onTap: () => navProvider.setBottomNavIndex(2),
            ),
            _buildNavItem(
              icon: Icons.settings,
              label: 'Settings',
              index: 3,
              isSelected: navProvider.currentBottomNavIndex == 3,
              onTap: () => navProvider.setBottomNavIndex(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? filledIcon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? (filledIcon ?? icon) : icon,
              color: color,
              size: 24,
              weight: isSelected ? 700 : 400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.05,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
