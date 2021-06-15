import 'package:tflite_flutter/tflite_flutter.dart';

class EKGClassifier {
  Interpreter _interpreter;
  List<double> threshold = [0.124, 0.07, 0.05, 0.278, 0.390, 0.174];
  List<String> rhythmLabels = [
    '1st degree AV block',
    'Right bundle branch block',
    'Left bundle branch block',
    'Sinus bradycardia',
    'Atrial fibrillation',
    'Sinus tachycardia'
  ];

  EKGClassifier() {
    _loadModel();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset('model.tflite');
    print('Loaded tensorflow model');
  }

  // take in multiple batches // (N, 4096, 12),
  // output a list of strings of the rhythm for each (4096) batch
  List<String> classify(List<List<List<double>>> ekgData) {
    print('Classifying EKG data');
    // allocate output list
    List<dynamic> output =
        List<double>.filled(6 * ekgData.length, 0).reshape([ekgData.length, 6]);

    // run the inference on the ekg data
    _interpreter.run(ekgData, output);

    return convertToRhythms(output.cast());
  }

  List<String> convertToRhythms(List<List<double>> output) {
    List<String> rhythms = [];
    String currRhythm;

    for (List<double> batch in output) {
      currRhythm = "No Abnormal Rhythm";
      for (int i = 0; i < 6; i++) {
        if (threshold[i] < batch[i]) {
          currRhythm = rhythmLabels[i];
        }
      }
      rhythms.add(currRhythm);
    }
    print('Found rhythms: ' + rhythms.toSet().toList().toString());

    return rhythms;
  }
}
