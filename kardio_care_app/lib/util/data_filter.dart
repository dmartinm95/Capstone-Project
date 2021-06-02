import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class DataFilter {
  static const int BUFFER_SIZE = 2500;

  Array buffer = Array.fixed(BUFFER_SIZE);
  Array plottingBuffer = Array.fixed(BUFFER_SIZE);
  int bufferIndex = 0;
  bool isBufferFull = false;

  Ewma ewmaFilter = Ewma(0.2);

  DataFilter() {
    print("Filter Data Constructor");
  }

  void resetBuffer() {
    isBufferFull = false;
    bufferIndex = 0;
  }

  void addDataToBuffer(int data) {
    buffer[bufferIndex] = data.toDouble();
    bufferIndex++;
    if (bufferIndex >= buffer.length) {
      print("===================== Buffer IS FULL =====================");
      isBufferFull = true;
      bufferIndex = 0;

      // // Coefficients for Fs = 250 Hz, Fnotch = 0.67Hz, BW = 5
      // plottingBuffer = lfilter(
      //     Array([0.98039921325956, -1.96068983690122, 0.98039921325956]),
      //     Array([1, -1.96068983690122, 0.960798426519119]),
      //     buffer);

      // // Coefficients for Fs = 250 Hz, Fnotch = 60Hz, BW = 120, Apass = 1.0
      // plottingBuffer = lfilter(
      //     Array([0.110036498530389, -0.0138184978198193, 0.110036498530389]),
      //     Array([1, -0.0138184978198193, -0.779927002939223]),
      //     plottingBuffer);

      // Coefficients for Fs = 275 Hz, Fnotch = 80Hz, BW = 115, Apass = 0.5
      plottingBuffer = lfilter(
          Array([0.42938387187357, 0.218314505274497, 0.42938387187357]),
          Array([1, 0.218314505274497, -0.141232256252859]),
          buffer);
    }
  }

  int getFilteredData() {
    // return ewmaFilter.filter(plottingBuffer[bufferIndex]).toInt();
    return plottingBuffer[bufferIndex].toInt();
  }
}

class Ewma {
  double alpha;
  double output;
  bool hasInitial = false;

  Ewma(double alpha) {
    this.alpha = alpha;
  }

  double filter(double input) {
    if (hasInitial) {
      output = alpha * (input - output) + output;
    } else {
      output = input;
      hasInitial = true;
    }
    return output;
  }
}
