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
      ..heartRateData = (fields[2] as Map)?.cast<DateTime, double>()
      ..heartRateVarData = (fields[3] as Map)?.cast<DateTime, double>()
      ..bloodOxData = (fields[4] as Map)?.cast<DateTime, double>()
      ..rhythms = (fields[5] as List)?.cast<String>()
      ..ekgData = (fields[6] as List)
          ?.map((dynamic e) => (e as List)
              ?.map((dynamic e) => (e as List)?.cast<double>())
              ?.toList())
          ?.toList();
  }

  @override
  void write(BinaryWriter writer, RecordingData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.recordingLengthMin)
      ..writeByte(2)
      ..write(obj.heartRateData)
      ..writeByte(3)
      ..write(obj.heartRateVarData)
      ..writeByte(4)
      ..write(obj.bloodOxData)
      ..writeByte(5)
      ..write(obj.rhythms)
      ..writeByte(6)
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

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 1;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo()
      ..firstName = fields[0] as String
      ..lastName = fields[1] as String
      ..age = fields[2] as int
      ..weight = fields[3] as double
      ..height = fields[4] as double;
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
