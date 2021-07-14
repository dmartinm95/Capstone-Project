import 'dart:isolate';

import "dart:math";

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
        // EKGClassifier classifier = EKGClassifier(
        //   interpreter: Interpreter.fromAddress(isolateData.interpreterAddress),
        // );

        List<List<List<double>>> ekgData = isolateData.ekgData;

        final _random = new Random();

        List<String> rhythmClassifications = [
          '1st Degree AV Block',
          'Bundle Branch Block',
          'Bundle Branch Block',
          'Sinus Bradycardia',
          'Atrial Fibrillation',
          'Sinus Tachycardia'
        ];

        // List<String> results = classifier.classify(ekgData);
        isolateData.responsePort.send([
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
          rhythmClassifications[_random.nextInt(rhythmClassifications.length)],
        ]);
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
