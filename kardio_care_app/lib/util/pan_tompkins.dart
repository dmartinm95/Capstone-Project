import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:iirjdart/butterworth.dart';

// QRSDetectorOffline is by default tuned for a sampling rate of 250 samples per second

// For example, to change signal sampling rate from 250 to 125 samples per second, divide all parameters by 2: set signal_frequency value to 125, integration_window to 8 samples, findpeaks_spacing to 25 samples and refractory_period to 60 samples.
class PanTomkpins with ChangeNotifier {
  static const MAX_SIZE = 750;

  Array bufferArray = Array.fixed(MAX_SIZE);
  int bufferArrayIndex = 0;

  int currentHeartRate = 0;
  double currentHeartRateVar = 0;

  // Set ECG device frequency in samples per second here.
  double sampleFrequency = 360.0;
  double filterLowcut = 5.0;
  double filterHighcut = 15.0;
  int filterOrder = 1;

  // Change proportionally when adjusting frequency (in samples).
  // The width of the window should be approximately the same as the widest possible QRS complex
  int integrationWindow = 50; // Default value of 15 for 250Hz
  double findpeaksLimit = 0.35; // Default value of 0.35 for 250Hz
  int findpeaksSpacing = 72; // Default value of 50 for 250Hz
  double refractoryPeriod =
      172.8; // Default value of 60 for 250Hz, 200ms * (samples/sec Hz) = # Samples

  double qrsPeakFilteringFactor = 0.125;
  double noisePeakFilteringFactor = 0.125;
  double qrsNoiseDiffWeight = 0.25;

  double thresholdValue = 0.0;
  double thresholdValueII = 0.0;
  double qrsPeakValue = 0.0;
  double noisePeakValue = 0.0;

  Array detectedPeaksIndices = Array.empty();
  Array detectedPeaksValues = Array.empty();
  Array qrsPeaksIndices = Array.empty();
  Array noisePeaksIndices = Array.empty();

  bool skipOdd = false;

  PanTomkpins() {
    print("Pan Tompkins constructor");
  }

  void resetCurrentHeartRate() {
    currentHeartRate = 0;
  }

  void setSampleFrequency(double frequency) {
    sampleFrequency = frequency;
  }

  void setDefaultValues() {
    // thresholdValue = 0.0;
    // qrsPeakValue = 0.0;
    // noisePeakValue = 0.0;
    qrsPeaksIndices.clear();
    noisePeaksIndices.clear();
    detectedPeaksIndices.clear();
    detectedPeaksValues.clear();
  }

  // Method used when recording from all 4 leads
  int addRecordedData(double data) {
    bufferArray[bufferArrayIndex] = data;
    bufferArrayIndex++;

    if (bufferArrayIndex == MAX_SIZE) {
      print("Pan Tompkins array is now full with $MAX_SIZE items");

      bufferArrayIndex = 0;
      setDefaultValues();
      performPanTompkins(bufferArray);
      return currentHeartRate;
    } else {
      return 0;
    }
  }

  // Method used when getting real-time data from a single lead
  void addDataToBuffer(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) continue;

      bufferArray[bufferArrayIndex] = data[i].toDouble();
      bufferArrayIndex++;

      if (bufferArrayIndex == MAX_SIZE) {
        print("Pan Tompkins array is now full with $MAX_SIZE items");
        double maxValueInBufferArray = arrayMax(bufferArray);
        print("Max value in bufferArray: $maxValueInBufferArray");
        bufferArrayIndex = 0;

        if (!skipOdd) {
          setDefaultValues();
          performPanTompkins(bufferArray);
        }

        skipOdd = !skipOdd;
      }
    }
  }

  double arrayAbsMax(Array data) {
    return max(arrayMax(data), (arrayMin(data)).abs());
  }

  Array bandpassFilter(Array data, double lowcut, double highcut,
      double signalFreq, int filterOrder) {
    double nyquistFreq = 0.5 * signalFreq;
    double low = lowcut / nyquistFreq;
    double high = highcut / nyquistFreq;

    Butterworth butterworth = new Butterworth();
    butterworth.bandPass(filterOrder, signalFreq, 10.0, 5.0);
    Array filteredData = Array.empty();
    for (int i = 0; i < data.length; i++) {
      filteredData.add(butterworth.filter(data[i]));
    }

    // Array coeffs = firwin(15, Array([low, high])); From python script
    Array b = Array([0.10935719, 0.0, -0.10935719]);
    Array a = Array([1.0, -1.77719724, 0.78128563]);

    // Array y = lfilter(coeffs, Array([1.0]), data);
    Array y = lfilter(b, a, data);
    return filteredData;
  }

  Array differentiate(Array data) {
    Array y = Array.fixed(data.length - 1);
    double initialData = data[0];

    for (int i = 1; i < data.length; i++) {
      y[i - 1] = data[i] - initialData;
      initialData = data[i];
    }

    return y;
  }

  Array squarring(Array data) {
    Array y = arrayPow(data, 2);
    return y;
  }

  Array movingWindow(Array data) {
    Array y = convolution(data, ones(integrationWindow));
    return y;
  }

  void calculatePeaks(Array data, double limit, int spacing) {
    int len = data.length;
    Array x = zeros(len + 2 * spacing);

    // x[:spacing] = data[0] - 1.e-6
    for (int i = 0; i < spacing; i++) {
      x[i] = data[0] - 0.000001;
    }

    // x[-spacing:] = data[-1] - 1.e-6
    for (int i = x.length - spacing; i < x.length; i++) {
      x[i] = data[data.length - 1] - 0.000001;
    }

    // x[spacing:spacing + len] = data
    int dataIndex = 0;
    for (int i = spacing; i < x.length - spacing; i++) {
      x[i] = data[dataIndex];
      dataIndex++;
    }

    Array peakCandidate = ones(len);

    for (int i = 0; i < spacing; i++) {
      int start = spacing - i - 1;
      Array hB = x.getRangeArray(start, start + len);
      start = spacing;
      Array hC = x.getRangeArray(start, start + len);
      start = spacing + i + 1;
      Array hA = x.getRangeArray(start, start + len);

      Array logicalANDArray = zeros(len);

      // np.logical_and(h_c > h_b, h_c > h_a))
      for (int j = 0; j < len; j++) {
        if (hC[j] > hB[j] && hC[j] > hA[j]) {
          logicalANDArray[j] = 1.0;
        } else {
          logicalANDArray[j] = 0.0;
        }
      }

      // peak_candidate = np.logical_and(peak_candidate, np.logical_and(h_c > h_b, h_c > h_a))
      for (int j = 0; j < len; j++) {
        if (peakCandidate[j] == 1.0 && logicalANDArray[j] == 1.0) {
          peakCandidate[j] = 1.0;
        } else {
          peakCandidate[j] = 0.0;
        }
      }
    }

    // ind = np.argwhere(peak_candidate) Find indices where array element is not 0
    Array indexes = Array.empty();
    Array values = Array.empty();

    for (int i = 0; i < len; i++) {
      if (peakCandidate[i] == 1.0) {
        indexes.add(i.toDouble());
        values.add(data[i]);
      }
    }

    detectedPeaksIndices = Array.fromArray(indexes);
    detectedPeaksValues = Array.fromArray(values);

    print("Indices of peaks from calculatePeaks(): $detectedPeaksIndices");
  }

  void detectQRS() {
    int len = detectedPeaksIndices.length;
    double lastQRSIndex = 0.0;

    for (int i = 0; i < len; i++) {
      double detectedPeakIndex = detectedPeaksIndices[i];
      double detectedPeaksValue = detectedPeaksValues[i];

      try {
        lastQRSIndex = qrsPeaksIndices[qrsPeaksIndices.length - 1];
      } catch (e) {
        print("Error: ${e.toString()}");
        lastQRSIndex = 0;
      }

      // After a valid QRS complex detection, there is a 200 ms refractory period before next one can be detected.
      if (detectedPeakIndex - lastQRSIndex > refractoryPeriod ||
          qrsPeaksIndices.isEmpty) {
        // Peak must be classified either as a noise peak or a QRS peak.
        // To be classified as a QRS peak it must exceed dynamically set threshold value.
        if (detectedPeaksValue > thresholdValue) {
          qrsPeaksIndices.add(detectedPeakIndex);

          //  Adjust QRS peak value used later for setting QRS-noise threshold.
          qrsPeakValue = qrsPeakFilteringFactor * detectedPeaksValue +
              (1 - qrsPeakFilteringFactor) * qrsPeakValue;
        } else if (detectedPeaksValue > thresholdValueII) {
          qrsPeaksIndices.add(detectedPeakIndex);

          qrsPeakValue = 0.25 * detectedPeaksValue + 0.75 * qrsPeakValue;
        } else {
          noisePeaksIndices.add(detectedPeakIndex);

          //  Adjust noise peak value used later for setting QRS-noise threshold.
          noisePeakValue = noisePeakFilteringFactor * detectedPeaksValue +
              (1 - noisePeakFilteringFactor) * noisePeakValue;
        }
        //  Adjust QRS-noise threshold value based on previously detected QRS or noise peaks value.
        thresholdValue = noisePeakValue +
            qrsNoiseDiffWeight * (qrsPeakValue - noisePeakValue);

        thresholdValueII = 0.5 * thresholdValue;
      }
    }

    print("QRS peaks indices: $qrsPeaksIndices");
    print("Noise peaks indices: $noisePeaksIndices");
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

  void performPanTompkins(Array data) {
    // Previous method for calculating the QRS peaks
    // Array lpfData = lpf(data);
    // Array hpfData = hpf(lpfData);
    // Array derivativeData = derivative(hpfData);
    // Array squaringData = arrayPow(derivativeData, 2);
    // int windowSize = 22;
    // Array integratedData = integration(squaringData, windowSize);
    // var peaks = findPeaks(integratedData, threshold: mean(integratedData));
    // result = peaks[0];

    // New method
    print("Bandpass Filter");
    Array bandpassData = bandpassFilter(
        data, filterLowcut, filterHighcut, sampleFrequency, filterOrder);

    print("Differentiate");
    Array derivativeData = differentiate(bandpassData);

    print("Squarring");
    Array squaredData = squarring(derivativeData);

    print("Moving Window");
    Array integration = movingWindow(squaredData);

    print("Calculate peaks");
    calculatePeaks(integration, findpeaksLimit, findpeaksSpacing);

    print("Detect QRS peaks");
    detectQRS();

    print("Calculate HR and HRV");
    calculateHeartRate();

    print("Done Pan Tompkins");
  }

  void calculateHeartRate() {
    Array timeDiffBetweenPeaks = Array.empty();

    Array indices = Array.fromArray(qrsPeaksIndices);
    if (qrsPeaksIndices.length <= 1) {
      print("Only 1 QRS peak detected, using noise peaks instead");
      indices = Array.fromArray(noisePeaksIndices);
    }

    for (int i = 1; i < indices.length; i++) {
      double numberSamplesBetweenPeaks = indices[i] - indices[i - 1];
      // print("Number of samples between peaks: $numberSamplesBetweenPeaks");

      double lengthInSeconds = numberSamplesBetweenPeaks / sampleFrequency;
      // print("Length in seconds: $lengthInSeconds");

      if (lengthInSeconds > 0.5 && lengthInSeconds < 1.3) {
        timeDiffBetweenPeaks.add(lengthInSeconds);
      }
    }

    print("Time difference between peaks (sec) : $timeDiffBetweenPeaks");

    // HRV calculation: RMSSD = SQRT[ (1/N-1) * SUM(i=0 to N-1) of [RR_i+1 - RR_i]^2 ]
    Array heartRateVarInnerSum = Array.empty();
    for (int i = 0; i < timeDiffBetweenPeaks.length - 1; i += 1) {
      double innerValue =
          pow(timeDiffBetweenPeaks[i] - timeDiffBetweenPeaks[i + 1], 2);

      heartRateVarInnerSum.add(innerValue);
    }

    try {
      // In milliseconds (ms)
      currentHeartRateVar = sqrt(mean(heartRateVarInnerSum)) * 1000;
      print("HRV: $currentHeartRateVar (ms).");

      // In beats per minute (bpm)
      currentHeartRate = 60 ~/ mean(timeDiffBetweenPeaks);
      print("HR: $currentHeartRate (bpm). ");
    } catch (e) {
      currentHeartRate = 0;
      currentHeartRateVar = 0;
      print("Error while calculating HRV and HR: ${e.toString()}");
    }
  }
}
