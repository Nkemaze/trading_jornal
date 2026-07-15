enum PairStatus { active, closed }

class TradingPair {
  final String symbol;
  final int journalCount;
  final PairStatus status;

  const TradingPair({
    required this.symbol,
    required this.journalCount,
    required this.status,
  });

  static const List<TradingPair> sampleData = [
    TradingPair(
      symbol: 'BTC/USD',
      journalCount: 12,
      status: PairStatus.active,
    ),
    TradingPair(
      symbol: 'NVDA',
      journalCount: 45,
      status: PairStatus.closed,
    ),
    TradingPair(
      symbol: 'EUR/USD',
      journalCount: 8,
      status: PairStatus.active,
    ),
  ];
}
