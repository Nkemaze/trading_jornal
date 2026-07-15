import 'package:hive/hive.dart';

class Reminder extends HiveObject {
  late String id;
  late String title;
  late String? note;
  late DateTime createdAt;
  late DateTime remindAt;
  late bool repeatEnabled;
  late bool isActive;

  Reminder({
    required this.id,
    required this.title,
    this.note,
    required this.createdAt,
    required this.remindAt,
    this.repeatEnabled = false,
    this.isActive = true,
  });
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 2;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Reminder(
      id: fields[0] as String,
      title: fields[1] as String,
      note: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      remindAt: fields[4] as DateTime,
      repeatEnabled: fields[5] as bool,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.note);
    writer.writeByte(3);
    writer.write(obj.createdAt);
    writer.writeByte(4);
    writer.write(obj.remindAt);
    writer.writeByte(5);
    writer.write(obj.repeatEnabled);
    writer.writeByte(6);
    writer.write(obj.isActive);
  }
}
