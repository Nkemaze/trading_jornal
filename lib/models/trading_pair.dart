import 'package:hive/hive.dart';

enum PairStatus { active, closed }

class TradingPair extends HiveObject {
  late String id;
  late String symbol;
  late int journalCount;
  late PairStatus status;

  TradingPair({
    required this.id,
    required this.symbol,
    required this.journalCount,
    required this.status,
  });
}

class TradingPairAdapter extends TypeAdapter<TradingPair> {
  @override
  final int typeId = 0;

  @override
  TradingPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return TradingPair(
      id: fields[0] as String,
      symbol: fields[1] as String,
      journalCount: fields[2] as int,
      status: PairStatus.values[fields[3] as int],
    );
  }

  @override
  void write(BinaryWriter writer, TradingPair obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.symbol);
    writer.writeByte(2);
    writer.write(obj.journalCount);
    writer.writeByte(3);
    writer.write(obj.status.index);
  }
}
