// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordingDataAdapter extends TypeAdapter<RecordingData> {
  @override
  final int typeId = 0;

  @override
  RecordingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordingData()
      ..startTime = fields[0] as DateTime
      ..recordingLengthMin = fields[1] as int
      ..tags = (fields[2] as List)?.cast<String>()
      ..heartRateData = (fields[3] as Map)?.cast<DateTime, double>()
      ..heartRateVarData = (fields[4] as Map)?.cast<DateTime, double>()
      ..bloodOxData = (fields[5] as Map)?.cast<DateTime, double>()
      ..rhythms = (fields[6] as List)?.cast<String>()
      ..ekgData = (fields[7] as List)
          ?.map((dynamic e) => (e as List)
              ?.map((dynamic e) => (e as List)?.cast<double>())
              ?.toList())
          ?.toList();
  }

  @override
  void write(BinaryWriter writer, RecordingData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.recordingLengthMin)
      ..writeByte(2)
      ..write(obj.tags)
      ..writeByte(3)
      ..write(obj.heartRateData)
      ..writeByte(4)
      ..write(obj.heartRateVarData)
      ..writeByte(5)
      ..write(obj.bloodOxData)
      ..writeByte(6)
      ..write(obj.rhythms)
      ..writeByte(7)
      ..write(obj.ekgData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
