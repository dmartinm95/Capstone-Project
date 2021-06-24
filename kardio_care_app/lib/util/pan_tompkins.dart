import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:scidart_io/scidart_io.dart';

class PanTomkpins with ChangeNotifier {
  static const MAX_SIZE = 1000;

  Array bufferArray = Array.fixed(MAX_SIZE);
  int bufferArrayIndex = 0;
  int sampleFrequency = 400;

  int currentHeartRate = 0;
  int previousHeartRate = 0;

  bool isProcessingArray = false;
  File file;
  var sink;
  PanTomkpins() {
    print("Pan Tompkins constructor");
    // file = File("assets\test.txt");
    // sink = file.openWrite();
    // sink.write("Test");
    // writeLinesCSV(data, fileName)
  }

  void setSampleFrequency(int frequency) {
    sampleFrequency = frequency;
  }

  void addDataToBuffer(List<int> data, bool isSingleLead) async {
    if (isProcessingArray) {
      return;
    }

    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) continue;

      bufferArray[bufferArrayIndex] = data[i].toDouble();
      bufferArrayIndex++;

      if (bufferArrayIndex == MAX_SIZE) {
        print("Pan Tompkins array is now full with $MAX_SIZE items");
        isProcessingArray = true;
        bufferArrayIndex = 0;
        // Array result = performPanTompkins(bufferArray);
        // currentHeartRate = calculateHeartRate(result);
        isProcessingArray = false;

        // notifyListeners();
        // Issue when trying to notifyListeners because widget tree is in the process of building it already due to DeviceScanner provider
      }
    }
  }

  Future writeToFile(int data) async {}

  double arrayAbsMax(Array data) {
    return max(arrayMax(data), (arrayMin(data)).abs());
  }

  // Low Pass
  Array lpf(Array data) {
    Array b = Array([1, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1]);
    Array a = Array([1, -2, 1]);

    Array result = lfilter(b, a, data);
    double resultMax = arrayAbsMax(result);
    result = arrayDivisionToScalar(result, resultMax);

    return (result);
  }

  // High Pass
  Array hpf(Array data) {
    Array b = Array([
      -1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      32,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1
    ]);
    Array a = Array([1, 1]);

    Array result = lfilter(b, a, data);
    double resultMax = arrayAbsMax(result);
    result = arrayDivisionToScalar(result, resultMax);

    return (result);
  }

  // Derivative
  Array derivative(Array data) {
    Array b = arrayMultiplyToScalar(
        Array([1, 2, 0, -2, -1]), 1 / 8 * this.sampleFrequency);
    Array result = convolution(b, data, fast: true);

    result = arrayDivisionToScalar(result, arrayMax(result));

    return (result);
  }

  // Integral of Moving Window Integration of ws size
  Array integration(Array data, int windowSize) {
    // TODO: Use windowSize in the future instead of hardcoded values
    Array h = Array([for (int i = 0; i < 31; i += 1) 1.0 / 31]);
    Array result = convolution(data, h);

    Array resultNew = result;
    for (int i = 0; i < data.length; i += 1) {
      resultNew[i] = result[(i + 14) % data.length];
    }
    result = resultNew;
    double resultMax = arrayAbsMax(result);
    result = arrayDivisionToScalar(result, resultMax);
    return (result);
  }

  Array performPanTompkins(Array data) {
    Array result;

    Array lpfData = lpf(data);
    Array hpfData = hpf(lpfData);
    Array derivativeData = derivative(hpfData);
    Array squaringData = arrayPow(derivativeData, 2);

    int windowSize = 22;
    Array integratedData = integration(squaringData, windowSize);

    double maxH = arrayAbsMax(integratedData);
    double thresholdValue = 0.95 * maxH;
    // double thresholdValue = mean(integratedData);
    var peaks = findPeaks(integratedData, threshold: thresholdValue);
    print(peaks);

/*
  [0, 5, ]
  5 - 0 = 5 samples
  5 * (1/400) = 0.125 sec
  return Array[length of peaks - 1]
  heart rate = 60 / average of Array[length peaks - 1]
  heart rate = (1 beat / (average of Array[length peaks - 1]))*(60s/ 1min) -> bpm
  
*/
    result = peaks[0];
    return result;
  }

  // At least 100 samples in between peaks ~ 150 bpm
  // At least 480 samples in between peaks ~ 50 bpm
  int calculateHeartRate(Array peaksIndex) {
    int heartRate = 0;
    Array timeDiffBetweenPeaks = Array.fixed(peaksIndex.length - 1);
    int index = 0;
    for (int i = 1; i < peaksIndex.length; i++) {
      double numSamplesBetweenPeaks = peaksIndex[i] - peaksIndex[i - 1];
      double lengthInSec = numSamplesBetweenPeaks / sampleFrequency;
      timeDiffBetweenPeaks[index] = lengthInSec;
      print("Length in seconds $lengthInSec");
    }

    heartRate = 60 ~/ mean(timeDiffBetweenPeaks); // In bpm

    return heartRate;
  }
}
