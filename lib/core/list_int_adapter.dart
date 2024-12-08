import 'package:hive/hive.dart';

class ListIntAdapter extends TypeAdapter<List<int>> {
  @override
  final int typeId = 1;

  @override
  List<int> read(BinaryReader reader) {
    final length = reader.readInt();
    return List.generate(length, (_) => reader.readInt());
  }

  @override
  void write(BinaryWriter writer, List<int> obj) {
    writer.writeInt(obj.length);
    for (final item in obj) {
      writer.writeInt(item);
    }
  }
}
