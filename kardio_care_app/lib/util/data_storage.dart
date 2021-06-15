import 'package:hive/hive.dart';
part 'data_storage.g.dart';

@HiveType(typeId: 0)
class RecordingData extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int recordingLengthMin;

  @HiveField(2)
  List<String> tags;

  @HiveField(3)
  Map<DateTime, double> heartRateData;

  @HiveField(4)
  Map<DateTime, double> heartRateVarData;  

  @HiveField(5)
  Map<DateTime, double> bloodOxData;

  @HiveField(6)
  List<String> rhythms;

  @HiveField(7)
  List<List<List<double>>> ekgData;
}


// class UserInfo {
//   int age;
//   double weight;
//   List<String> name; 
// }
