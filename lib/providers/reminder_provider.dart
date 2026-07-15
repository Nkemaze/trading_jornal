import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import '../services/database_service.dart';

class ReminderProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  ReminderProvider(this._db) {
    loadReminders();
  }

  List<Reminder> get reminders => _reminders;
  List<Reminder> get activeReminders => _reminders.where((r) => r.isActive).toList();
  bool get isLoading => _isLoading;

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();
    _reminders = _db.getAllReminders();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReminder({
    required String title,
    required DateTime remindAt,
    String? note,
    bool repeatEnabled = false,
  }) async {
    await _db.addReminder(
      title: title,
      remindAt: remindAt,
      note: note,
      repeatEnabled: repeatEnabled,
    );
    await loadReminders();
  }

  Future<void> toggleReminder(String id) async {
    await _db.toggleReminder(id);
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    await _db.deleteReminder(id);
    await loadReminders();
  }
}
