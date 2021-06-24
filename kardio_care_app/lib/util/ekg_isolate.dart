import 'dart:isolate';

import 'package:kardio_care_app/util/ekg_classifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Manages separate Isolate for EKG inference
class EKGIsolate {
  static const String DEBUG_NAME = "InferenceIsolate";

  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      if (isolateData != null) {
        EKGClassifier classifier = EKGClassifier(
          interpreter: Interpreter.fromAddress(isolateData.interpreterAddress),
        );

        List<List<List<double>>> ekgData = isolateData.ekgData;

        List<String> results = classifier.classify(ekgData);
        isolateData.responsePort.send(results);
      }
    }
  }
}

// Data to pass between Isolate
class IsolateData {
  int interpreterAddress;
  List<List<List<double>>> ekgData;
  SendPort responsePort;

  IsolateData(
    this.interpreterAddress,
    this.ekgData,
  );
}
