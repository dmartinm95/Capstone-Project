import 'package:hive/hive.dart';
part 'data_storage.g.dart';

@HiveType(typeId: 0)
class RecordingData extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int recordingLengthMin;

  @HiveField(2)
  Map<DateTime, double> heartRateData;

  @HiveField(3)
  Map<DateTime, double> heartRateVarData;

  @HiveField(4)
  Map<DateTime, double> bloodOxData;

  @HiveField(5)
  List<String> rhythms;

  @HiveField(6)
  List<List<List<double>>> ekgData;
}

@HiveType(typeId: 1)
class UserInfo {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  int age;

  @HiveField(3)
  double weight;

  @HiveField(4)
  double height;
}
