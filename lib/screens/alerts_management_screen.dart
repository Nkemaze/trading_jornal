import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../providers/navigation_provider.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_colors.dart';
import 'add_alert_screen.dart';

class AlertsManagementScreen extends StatefulWidget {
  const AlertsManagementScreen({super.key});

  @override
  State<AlertsManagementScreen> createState() => _AlertsManagementScreenState();
}

class _AlertsManagementScreenState extends State<AlertsManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().setBottomNavIndex(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            const Text(
              'Reminders',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.search,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final reminderProvider = context.watch<ReminderProvider>();
    final reminders = reminderProvider.reminders;
    final activeReminders = reminders.where((r) => r.isActive).toList();

    return Stack(
      children: [
        if (reminders.isEmpty)
          _buildEmptyState()
        else
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Reminders',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '${activeReminders.length} ACTIVE',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.33,
                        letterSpacing: 0.05,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...reminders.map((reminder) => _buildReminderCard(reminder)),
              ],
            ),
          ),
        _buildFab(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(25),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No reminders yet',
            style: TextStyle(
              fontSize: 20,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to create your first reminder.',
            style: TextStyle(
              fontSize: 14,
              height: 1.43,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    final now = DateTime.now();
    final diff = reminder.remindAt.difference(now);
    String timeText;
    if (diff.isNegative) {
      timeText = 'Past due';
    } else if (diff.inMinutes < 60) {
      timeText = 'In ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      timeText = 'In ${diff.inHours}h';
    } else {
      timeText = 'In ${diff.inDays}d';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withAlpha(reminder.isActive ? 150 : 75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reminder.isActive ? AppColors.outlineVariant : AppColors.outlineVariant.withAlpha(100),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withAlpha(reminder.isActive ? 25 : 10),
            ),
            child: Icon(
              Icons.update,
              color: reminder.isActive ? AppColors.secondary : AppColors.onSurfaceVariant,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: reminder.isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeText,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _buildToggle(
            value: reminder.isActive,
            onChanged: () {
              context.read<ReminderProvider>().toggleReminder(reminder.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required bool value,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppColors.primaryContainer : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      bottom: 24,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddReminderScreen()),
          );
        },
        child: const Icon(Icons.add_alert, size: 24),
      ),
    );
  }
}
