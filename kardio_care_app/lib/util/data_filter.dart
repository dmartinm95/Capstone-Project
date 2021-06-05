import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class DataFilter {
  static const int BUFFER_SIZE = 2500;

  Array buffer = Array.fixed(BUFFER_SIZE);
  Array plottingBuffer = Array.fixed(BUFFER_SIZE);
  int bufferIndex = 0;
  int plotBufferIndex = 0;
  bool isBufferFull = false;

  int downsampleFactor = 1;

  Ewma ewmaFilter = Ewma(0.2);

  DataFilter() {
    print("Filter Data Constructor");
  }

  void resetBuffer() {
    isBufferFull = false;
    bufferIndex = 0;
    plotBufferIndex = 0;
  }

  void addDataToBuffer(int data) {
    buffer[bufferIndex] = data.toDouble();
    bufferIndex++;

    if (bufferIndex >= buffer.length) {
      print(
          "====================================================================================");
      print("BUFFER is full");
      print(
          "====================================================================================");

      // DECENT
      // plottingBuffer = lfilter(
      //     Array([0.272667524669321, 0.0342418710655171, 0.272667524669321]),
      //     Array([1, 0.0342418710655171, -0.454664950661357]),
      //     buffer);

      // BETTER // Coefficients for Fs = 200 Hz, Fnotch = 80Hz, BW = 85, Apass = 5
      plottingBuffer = lfilter(
          Array([0.140352016225952, 0.227094332643167, 0.140352016225952]),
          Array([1, 0.227094332643167, -0.719295967548096]),
          buffer);

      // DECENT // Coefficients for Fs = 210 Hz, Fnotch = 60 Hz, BW = 100, Apass = 0.1
      // plottingBuffer = lfilter(
      //     Array([0.329318072592715, 0.146560330164049, 0.329318072592715]),
      //     Array([1, 0.146560330164049, -0.34136385481457]),
      //     buffer);

      // // Coefficients for Fs = 275 Hz, Fnotch = 80Hz, BW = 115, Apass = 0.5 GOOD
      // plottingBuffer = lfilter(
      //     Array([0.42938387187357, 0.218314505274497, 0.42938387187357]),
      //     Array([1, 0.218314505274497, -0.141232256252859]),
      //     buffer);

      isBufferFull = true;
      bufferIndex = 0;
    }
  }

  int getFilteredData() {
    int dataFiltered = plottingBuffer[plotBufferIndex].toInt();
    // int dataFiltered =
    //     ewmaFilter.filter(plottingBuffer[plotBufferIndex]).toInt();
    plotBufferIndex++;
    if (plotBufferIndex >= plottingBuffer.length) {
      plotBufferIndex = 0;
    }
    return dataFiltered;
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
