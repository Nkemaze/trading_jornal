import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/trading_pair.dart';
import '../models/journal_entry.dart';
import '../models/reminder.dart';

class DatabaseService {
  static const _pairsBox = 'pairs';
  static const _entriesBox = 'entries';
  static const _remindersBox = 'reminders';
  static const _uuid = Uuid();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TradingPairAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ReminderAdapter());
    await Hive.openBox<TradingPair>(_pairsBox);
    await Hive.openBox<JournalEntry>(_entriesBox);
    await Hive.openBox<Reminder>(_remindersBox);
  }

  // ── Pairs ──

  Box<TradingPair> get _pairs => Hive.box<TradingPair>(_pairsBox);

  List<TradingPair> getAllPairs() => _pairs.values.toList();

  Future<TradingPair> addPair(String symbol) async {
    final pair = TradingPair(
      id: _uuid.v4(),
      symbol: symbol.toUpperCase(),
      journalCount: 0,
      status: PairStatus.active,
    );
    await _pairs.put(pair.id, pair);
    return pair;
  }

  Future<void> updatePair(TradingPair pair) async {
    await _pairs.put(pair.id, pair);
  }

  Future<void> deletePair(String id) async {
    await _pairs.delete(id);
  }

  // ── Journal Entries ──

  Box<JournalEntry> get _entries => Hive.box<JournalEntry>(_entriesBox);

  List<JournalEntry> getAllEntries() => _entries.values.toList();

  List<JournalEntry> getEntriesForPair(String pairSymbol) {
    return _entries.values
        .where((e) => e.pairSymbol == pairSymbol)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  JournalEntry? getEntry(String id) => _entries.get(id);

  Future<JournalEntry> addEntry({
    required String pairSymbol,
    required String content,
    String? title,
    EntryStatus status = EntryStatus.neutral,
    List<String> tags = const [],
    List<String> attachmentUrls = const [],
  }) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      pairSymbol: pairSymbol,
      date: DateTime.now(),
      title: title,
      content: content,
      status: status,
      tags: tags,
      attachmentUrls: attachmentUrls,
    );
    await _entries.put(entry.id, entry);

    // Update pair journal count
    final pair = _pairs.values.firstWhere(
      (p) => p.symbol == pairSymbol,
      orElse: () => _pairs.values.first,
    );
    pair.journalCount = _entries.values
        .where((e) => e.pairSymbol == pairSymbol)
        .length;
    await _pairs.put(pair.id, pair);

    return entry;
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _entries.put(entry.id, entry);
  }

  Future<void> lockEntry(String id) async {
    final entry = _entries.get(id);
    if (entry != null) {
      entry.isLocked = true;
      await _entries.put(id, entry);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entry = _entries.get(id);
    if (entry != null) {
      await _entries.delete(id);
      // Update pair journal count
      try {
        final pair = _pairs.values.firstWhere(
          (p) => p.symbol == entry.pairSymbol,
        );
        pair.journalCount = _entries.values
            .where((e) => e.pairSymbol == entry.pairSymbol)
            .length;
        await _pairs.put(pair.id, pair);
      } catch (_) {}
    }
  }

  // ── Reminders ──

  Box<Reminder> get _reminders => Hive.box<Reminder>(_remindersBox);

  List<Reminder> getAllReminders() => _reminders.values.toList()
    ..sort((a, b) => a.remindAt.compareTo(b.remindAt));

  List<Reminder> getActiveReminders() {
    return _reminders.values.where((r) => r.isActive).toList()
      ..sort((a, b) => a.remindAt.compareTo(b.remindAt));
  }

  Future<Reminder> addReminder({
    required String title,
    required DateTime remindAt,
    String? note,
    bool repeatEnabled = false,
  }) async {
    final reminder = Reminder(
      id: _uuid.v4(),
      title: title,
      note: note,
      createdAt: DateTime.now(),
      remindAt: remindAt,
      repeatEnabled: repeatEnabled,
    );
    await _reminders.put(reminder.id, reminder);
    return reminder;
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _reminders.put(reminder.id, reminder);
  }

  Future<void> toggleReminder(String id) async {
    final reminder = _reminders.get(id);
    if (reminder != null) {
      reminder.isActive = !reminder.isActive;
      await _reminders.put(id, reminder);
    }
  }

  Future<void> deleteReminder(String id) async {
    await _reminders.delete(id);
  }
}
