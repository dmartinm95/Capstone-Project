import 'dart:ffi';

import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class PanTomkpins {
  Array dataList;
  int sampleFrequency;

  PanTomkpins(Array dataList, int sampleFrequency) {
    this.dataList = dataList;
    this.sampleFrequency = sampleFrequency;
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

  Future<Array> performPanTompkins(Array data) async {
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
