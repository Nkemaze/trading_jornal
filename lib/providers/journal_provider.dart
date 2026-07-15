import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<JournalEntry> _entries = [];
  List<JournalEntry> _currentPairEntries = [];
  String? _currentPairSymbol;
  final bool _isLoading = false;

  JournalProvider(this._db);

  List<JournalEntry> get entries => _entries;
  List<JournalEntry> get currentPairEntries => _currentPairEntries;
  String? get currentPairSymbol => _currentPairSymbol;
  bool get isLoading => _isLoading;

  void loadAllEntries() {
    _entries = _db.getAllEntries();
    notifyListeners();
  }

  void loadEntriesForPair(String pairSymbol) {
    _currentPairSymbol = pairSymbol;
    _currentPairEntries = _db.getEntriesForPair(pairSymbol);
    notifyListeners();
  }

  Future<void> addEntry({
    required String pairSymbol,
    required String content,
    String? title,
    EntryStatus status = EntryStatus.neutral,
    List<String> tags = const [],
    List<String> attachmentUrls = const [],
  }) async {
    await _db.addEntry(
      pairSymbol: pairSymbol,
      content: content,
      title: title,
      status: status,
      tags: tags,
      attachmentUrls: attachmentUrls,
    );
    if (_currentPairSymbol == pairSymbol) {
      loadEntriesForPair(pairSymbol);
    }
    loadAllEntries();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _db.updateEntry(entry);
    if (_currentPairSymbol != null) {
      loadEntriesForPair(_currentPairSymbol!);
    }
    loadAllEntries();
  }

  Future<void> lockEntry(String id) async {
    await _db.lockEntry(id);
    if (_currentPairSymbol != null) {
      loadEntriesForPair(_currentPairSymbol!);
    }
    loadAllEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _db.deleteEntry(id);
    if (_currentPairSymbol != null) {
      loadEntriesForPair(_currentPairSymbol!);
    }
    loadAllEntries();
  }

  int getJournalCountForPair(String pairSymbol) {
    return _db.getEntriesForPair(pairSymbol).length;
  }
}
