import 'package:flutter/cupertino.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:scidart_io/scidart_io.dart';

class PanTomkpins with ChangeNotifier {
  static const MAX_SIZE = 1000;

  Array bufferArray = Array.fixed(MAX_SIZE);
  int bufferArrayIndex = 0;
  int sampleFrequency = 500;

  int currentHeartRate = 0;

  bool isProcessingArray = false;

  PanTomkpins() {
    print("Pan Tompkins constructor");
  }

  void resetCurrentHeartRate() {
    currentHeartRate = 0;
  }

  void setSampleFrequency(int frequency) {
    sampleFrequency = frequency;
  }

  int addRecordedData(double data) {
    bufferArray[bufferArrayIndex] = data;
    bufferArrayIndex++;

    if (bufferArrayIndex == MAX_SIZE) {
      print("Pan Tompkins array is now full with $MAX_SIZE items");

      bufferArrayIndex = 0;
      Array result = performPanTompkins(bufferArray);
      currentHeartRate = calculateHeartRate(result);
      return currentHeartRate;
    } else {
      return 0;
    }
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

        // printWrapped(bufferArray.toString());

        // var fileName = "raw_data.csv";
        // writeLinesCSV(
        //   Array2d([bufferArray]),
        //   fileName,
        //   delimiter: ',',
        // );
        isProcessingArray = true;
        bufferArrayIndex = 0;
        Array result = performPanTompkins(bufferArray);
        currentHeartRate = calculateHeartRate(result);
        isProcessingArray = false;

        // notifyListeners();
        // Issue when trying to notifyListeners because widget tree is in the process of building it already due to DeviceScanner provider
      }
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
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

    double maxH = arrayAbsMax(integratedData);
    double thresholdValue = mean(integratedData);
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
    Array timeDiffBetweenPeaks = Array.empty();
    int prevIndex = 0;
    for (int currIndex = 0; currIndex < peaksIndex.length; currIndex++) {
      int numSamplesBetweenPeaks =
          peaksIndex[currIndex].toInt() - peaksIndex[prevIndex].toInt();

      if (numSamplesBetweenPeaks < 250) {
        continue;
      } else {
        double lengthInSec = numSamplesBetweenPeaks / sampleFrequency;
        timeDiffBetweenPeaks.add(lengthInSec);
        prevIndex = currIndex;
        print("Number of samples in between: $numSamplesBetweenPeaks");
        print("Length in seconds $lengthInSec");
      }
    }

    print(timeDiffBetweenPeaks);

    heartRate = 60 ~/ mean(timeDiffBetweenPeaks); // In bpm

    return heartRate;
  }
}
