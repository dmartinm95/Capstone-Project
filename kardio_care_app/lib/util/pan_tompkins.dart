import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class PanTomkpins with ChangeNotifier {
  static const MAX_SIZE = 500;

  Array bufferArray = Array.fixed(MAX_SIZE);
  int bufferArrayIndex = 0;
  int sampleFrequency = 400;

  int currentHeartRate = 0;
  int previousHeartRate = 0;

  ValueNotifier<int> currentHeartRateNotifier = ValueNotifier<int>(null);

  PanTomkpins() {
    print("Pan Tompkins constructor");
  }

  void setSampleFrequency(int frequency) {
    sampleFrequency = frequency;
  }

  void addDataToBuffer(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) continue;

      bufferArray[bufferArrayIndex] = data[i].toDouble();
      bufferArrayIndex++;

      if (bufferArrayIndex == MAX_SIZE) {
        print("Array is now full");
        bufferArrayIndex = 0;
        Array result = performPanTompkins(bufferArray);
        print(result);
        currentHeartRateNotifier.value = mean(result).toInt();
        currentHeartRate = mean(result).toInt();

        // notifyListeners();
        // Issue when trying to notifyListeners because widget tree is in the process of building it already due to DeviceScanner provider
      }
    }
  }

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

    double thresholdValue = mean(integratedData);
    List peaks = findPeaks(integratedData, threshold: thresholdValue);

    result = peaks[0];

    return result;
  }
}
