import 'package:flutter/foundation.dart';
import '../models/trading_pair.dart';
import '../services/database_service.dart';

class PairProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<TradingPair> _pairs = [];
  bool _isLoading = false;

  PairProvider(this._db) {
    loadPairs();
  }

  List<TradingPair> get pairs => _pairs;
  bool get isLoading => _isLoading;
  bool get isEmpty => _pairs.isEmpty;

  Future<void> loadPairs() async {
    _isLoading = true;
    notifyListeners();
    _pairs = _db.getAllPairs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPair(String symbol) async {
    await _db.addPair(symbol);
    await loadPairs();
  }

  Future<void> deletePair(String id) async {
    await _db.deletePair(id);
    await loadPairs();
  }

  Future<void> updatePair(TradingPair pair) async {
    await _db.updatePair(pair);
    await loadPairs();
  }

  Future<void> refreshPairs() async {
    _pairs = _db.getAllPairs();
    notifyListeners();
  }
}
