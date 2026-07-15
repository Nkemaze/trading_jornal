enum EntryStatus { draft, profitable, stopped, neutral }

class JournalEntry {
  final String id;
  final String pairSymbol;
  final DateTime date;
  final String? title;
  final String content;
  final EntryStatus status;
  final bool isLocked;
  final List<String> tags;
  final List<String> attachmentUrls;
  final String? parentId;

  const JournalEntry({
    required this.id,
    required this.pairSymbol,
    required this.date,
    this.title,
    required this.content,
    this.status = EntryStatus.neutral,
    this.isLocked = false,
    this.tags = const [],
    this.attachmentUrls = const [],
    this.parentId,
  });

  static final sampleData = [
    JournalEntry(
      id: '1',
      pairSymbol: 'BTC/USD',
      date: DateTime(2023, 10, 24),
      content:
          'Record your price action observations for BTC/USD today...',
      status: EntryStatus.draft,
      isLocked: false,
      tags: ['nasdaq', 'scalping'],
      attachmentUrls: [],
    ),
    JournalEntry(
      id: '2',
      pairSymbol: 'BTC/USD',
      date: DateTime(2023, 10, 23),
      content:
          'Strong rejection at the \$63k resistance level. Observed heavy volume on the 15m timeframe. Decided to hold position as RSI indicates...',
      status: EntryStatus.profitable,
      isLocked: true,
      tags: [],
      attachmentUrls: ['thumb1'],
    ),
    JournalEntry(
      id: '3',
      pairSymbol: 'BTC/USD',
      date: DateTime(2023, 10, 22),
      content:
          'Initial long entry failed. Stop loss triggered at \$61,200. Market sentiment shift due to macro news. Watching for next accumulation zone.',
      status: EntryStatus.stopped,
      isLocked: true,
      tags: [],
      attachmentUrls: [],
    ),
    JournalEntry(
      id: '4',
      pairSymbol: 'BTC/USD',
      date: DateTime(2023, 10, 21),
      content:
          'Market consolidation phase. Low volatility weekend. Keeping my eye on the 4H EMA cross-over for potential re-entry.',
      status: EntryStatus.neutral,
      isLocked: true,
      tags: [],
      attachmentUrls: ['thumb2'],
    ),
    JournalEntry(
      id: '5',
      pairSymbol: 'BTC/USD',
      date: DateTime(2023, 10, 12),
      title: 'BTC Breakout Long',
      content:
          'Entered long following a successful retest of the \$26.8k support level. Significant volume divergence observed on the 4H timeframe suggested exhaustive selling pressure.\n\nMacro context: Institutional buying signals identified via on-chain data flows. The 200 EMA served as dynamic support throughout the consolidation phase.\n\n"The key here was patience. Watching for the liquidity sweep below the previous daily low before committing capital."',
      status: EntryStatus.profitable,
      isLocked: true,
      tags: ['Breakout', '4H_Timeframe', 'VolumeRetest', 'HighConfidence'],
      attachmentUrls: ['chart1', 'chart2', 'chart3'],
    ),
  ];
}

class HistoricalTrade {
  final String pairSymbol;
  final DateTime date;
  final String position;
  final String entryPrice;
  final String exitPrice;
  final String totalSize;
  final String pnl;
  final String roi;
  final String rrRatio;
  final String grade;
  final String thesis;
  final List<String> tags;
  final List<String> imageUrls;

  const HistoricalTrade({
    required this.pairSymbol,
    required this.date,
    required this.position,
    required this.entryPrice,
    required this.exitPrice,
    required this.totalSize,
    required this.pnl,
    required this.roi,
    required this.rrRatio,
    required this.grade,
    required this.thesis,
    this.tags = const [],
    this.imageUrls = const [],
  });

  static final sampleData = HistoricalTrade(
    pairSymbol: 'BTC / USD',
    date: DateTime(2023, 10, 12, 14, 45),
    position: 'Long / 10x Lev',
    entryPrice: '\$26,842.10',
    exitPrice: '\$28,262.60',
    totalSize: '0.45 BTC',
    pnl: '+\$1,420.50',
    roi: '+2.45% ROI',
    rrRatio: '1:3.4',
    grade: 'A+',
    thesis:
        'Entered long following a successful retest of the \$26.8k support level. Significant volume divergence observed on the 4H timeframe suggested exhaustive selling pressure.\n\nMacro context: Institutional buying signals identified via on-chain data flows. The 200 EMA served as dynamic support throughout the consolidation phase.\n\n"The key here was patience. Watching for the liquidity sweep below the previous daily low before committing capital."',
    tags: ['Breakout', '4H_Timeframe', 'VolumeRetest', 'HighConfidence'],
    imageUrls: ['chart1', 'chart2', 'panoramic'],
  );
}
