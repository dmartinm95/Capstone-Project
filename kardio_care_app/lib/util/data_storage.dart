import 'package:hive/hive.dart';
part 'data_storage.g.dart';


@HiveType(typeId: 0)
class RecordingData extends HiveObject {

  
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int recordingLengthMin;

  @HiveField(2)
  bool abnormalRhythmPresent;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  Map<DateTime, double> heartRateData;

  @HiveField(5)
  Map<DateTime, double> heartRateVarData;

  @HiveField(6)
  Map<DateTime, double> bloodOxData;

  @HiveField(7)
  List<String> rhythms;

  @HiveField(8)
  List<List<List<double>>> ekgData;
}


// class UserInfo {
//   int age;
//   double weight;
//   List<String> name; 
// }
