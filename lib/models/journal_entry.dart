import 'package:hive/hive.dart';

enum EntryStatus { draft, profitable, stopped, neutral }

class JournalEntry extends HiveObject {
  late String id;
  late String pairSymbol;
  late DateTime date;
  String? title;
  late String content;
  late EntryStatus status;
  late bool isLocked;
  late List<String> tags;
  late List<String> attachmentUrls;
  String? parentId;

  JournalEntry({
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
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 1;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return JournalEntry(
      id: fields[0] as String,
      pairSymbol: fields[1] as String,
      date: fields[2] as DateTime,
      title: fields[3] as String?,
      content: fields[4] as String,
      status: EntryStatus.values[fields[5] as int],
      isLocked: fields[6] as bool,
      tags: (fields[7] as List).cast<String>(),
      attachmentUrls: (fields[8] as List).cast<String>(),
      parentId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer.writeByte(10);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.pairSymbol);
    writer.writeByte(2);
    writer.write(obj.date);
    writer.writeByte(3);
    writer.write(obj.title);
    writer.writeByte(4);
    writer.write(obj.content);
    writer.writeByte(5);
    writer.write(obj.status.index);
    writer.writeByte(6);
    writer.write(obj.isLocked);
    writer.writeByte(7);
    writer.write(obj.tags);
    writer.writeByte(8);
    writer.write(obj.attachmentUrls);
    writer.writeByte(9);
    writer.write(obj.parentId);
  }
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
    thesis: 'Entered long following a successful retest of the \$26.8k support level.',
    tags: ['Breakout', '4H_Timeframe', 'VolumeRetest', 'HighConfidence'],
    imageUrls: ['chart1', 'chart2', 'panoramic'],
  );
}
