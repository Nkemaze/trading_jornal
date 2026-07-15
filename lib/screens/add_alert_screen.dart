import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_colors.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedTime = 'Tomorrow 9:00 AM';
  bool _repeatEnabled = false;
  DateTime? _customDateTime;

  final List<String> _times = [
    'In 30 minutes',
    'In 1 hour',
    'Tomorrow 9:00 AM',
    'Tomorrow 12:00 PM',
    'Next Monday 9:00 AM',
    'Custom...',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: _buildForm(),
          ),
        ],
      ),
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
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: AppColors.onSurface,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'New Reminder',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _saveReminder,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHAT DO YOU WANT TO BE REMINDED ABOUT?',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            autofocus: true,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. Review my weekly performance',
              hintStyle: const TextStyle(color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'WHEN',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ..._times.map((time) => _buildTimeOption(time)),
          const SizedBox(height: 16),
          _buildRepeatToggle(),
          const SizedBox(height: 24),
          const Text(
            'NOTE (OPTIONAL)',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Any additional details...',
              hintStyle: const TextStyle(color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 8,
                shadowColor: AppColors.primary.withAlpha(51),
              ),
              child: const Text(
                'Set Reminder',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOption(String time) {
    final isCustom = time == 'Custom...';
    final displayText = isCustom && _customDateTime != null
        ? _formatDateTime(_customDateTime!)
        : time;
    final isSelected = _selectedTime == time || (isCustom && _selectedTime == 'Custom...');
    return GestureDetector(
      onTap: () {
        if (isCustom) {
          _pickCustomDateTime();
        } else {
          setState(() => _selectedTime = time);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(25) : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              displayText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatToggle() {
    return GestureDetector(
      onTap: () => setState(() => _repeatEnabled = !_repeatEnabled),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.repeat,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Repeat this reminder',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: _repeatEnabled ? AppColors.primaryContainer : AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _repeatEnabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _repeatEnabled ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCustomDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _customDateTime ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surfaceContainerHigh,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_customDateTime ?? now.add(const Duration(hours: 1))),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: AppColors.onPrimary,
                surface: AppColors.surfaceContainerHigh,
                onSurface: AppColors.onSurface,
              ),
            ),
            child: child!,
          );
        },
      );
      if (time != null) {
        setState(() {
          _customDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _selectedTime = 'Custom...';
        });
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, $hour:$minute $ampm';
  }

  void _saveReminder() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reminder title'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    DateTime remindAt;
    if (_selectedTime == 'Custom...' && _customDateTime != null) {
      remindAt = _customDateTime!;
    } else {
      final now = DateTime.now();
      switch (_selectedTime) {
        case 'In 30 minutes':
          remindAt = now.add(const Duration(minutes: 30));
          break;
        case 'In 1 hour':
          remindAt = now.add(const Duration(hours: 1));
          break;
        case 'Tomorrow 9:00 AM':
          remindAt = DateTime(now.year, now.month, now.day + 1, 9, 0);
          break;
        case 'Tomorrow 12:00 PM':
          remindAt = DateTime(now.year, now.month, now.day + 1, 12, 0);
          break;
        case 'Next Monday 9:00 AM':
          final daysUntilMonday = (8 - now.weekday) % 7;
          final nextMonday = now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
          remindAt = DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 9, 0);
          break;
        default:
          remindAt = now.add(const Duration(hours: 1));
      }
    }

    context.read<ReminderProvider>().addReminder(
      title: _titleController.text.trim(),
      remindAt: remindAt,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      repeatEnabled: _repeatEnabled,
    );
    Navigator.of(context).pop();
  }
}
