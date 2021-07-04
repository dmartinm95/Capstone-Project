import 'package:tflite_flutter/tflite_flutter.dart';

class EKGClassifier {
  Interpreter _interpreter;
  List<double> threshold = [0.124, 0.07, 0.05, 0.278, 0.390, 0.174];
  List<String> rhythmLabels = [
    '1st Degree AV block',
    'Right bundle branch block',
    'Left bundle branch block',
    'Sinus Bradycardia',
    'Atrial Fibrillation',
    'Sinus tachycardia'
  ];

  EKGClassifier({
    Interpreter interpreter,
  }) {
    loadModel(interpreter: interpreter);
  }

  void loadModel({Interpreter interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            'model.tflite',
            // options: InterpreterOptions()..threads = 4,
          );

      // var outputTensors = _interpreter.getOutputTensors();
      // _outputShapes = [];
      // _outputTypes = [];
      // outputTensors.forEach((tensor) {
      //   _outputShapes.add(tensor.shape);
      //   _outputTypes.add(tensor.type);
      // });
    } catch (e) {
      print("Error while creating interpreter: $e");
    }

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
      currRhythm = 'No Abnormal Rhythm';
      for (int i = 0; i < 6; i++) {
        print(batch[i]);
        if (threshold[i] < batch[i]) {
          currRhythm = rhythmLabels[i];
        }
      }
      rhythms.add(currRhythm);
    }
    print('Found rhythms: ' + rhythms.toSet().toList().toString());

    return rhythms;
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;
}
