#include <Arduino.h>

#include <SoftwareSerial.h>

int led = 13;

int txdPin = 2;
int rxdPin = 3;

char buffer[10]; //the ASCII of the integer will be stored in this char array

/* HM-18 Device info
    GENERIC ACCESS 0x1800 (Primary service)
        Device Name
            UUID: 
            Properties: Read
        Appearance
            UUID:
            Properties: Read
        Peripheral Preferred Connection Parameters 
            UUID:
            Properties: Read
        Central Address Resolution
            UUID:
            Properties: Read
    GENERIC ATTRIBUTE

    CUSTOM SERVICE
        Custom Characteristic
            UUID: 0000FFE1-0000-1000-8000-00805F9B34FB
            Properties: Read, Write, Notify, Write_No_Response
            Write Type: Write Request
*/

// Define other serial ports using the SoftwareSerial library
// Avoid using Ardino Uno's one serial port which is in Pin 0 and Pin 1
SoftwareSerial Blue(txdPin, rxdPin);

// Variable used to store the number which is sent from the Android phone
long int data;

char val = 0;
int i;
bool isStreaming;

void waitForOK() {
    while (!Blue.available()) {
    };

    char c = Blue.read();
    Serial.write(c);
    c = Blue.read();
    Serial.write(c);
}

void setup() {
    Serial.begin(9600);
    while (!Serial) {
    };
    i = 0;

    pinMode(led, OUTPUT);
    digitalWrite(led, HIGH);

    Blue.begin(9600);
    isStreaming = true;

    // We can use this to rename the bluetooth module later on
    // Blue.write("AT+NAMEDSD TECH");
    // waitForOK();
}

void loop() {

    if (Blue.available() > 0) {
        val = Blue.read();
        Serial.print(val);

        // Seems to run into an issue when attempting to disconnect and is sending data at the same time
        // to avoid this, we can send a char before attempting to disconnect to stop streaming data
        if (val == '0') {
            isStreaming = false;
            digitalWrite(led, LOW);
        } else if (val == '1') {
            isStreaming = true;
            digitalWrite(led, HIGH);
        }
    }

    if (isStreaming) {
        Blue.write(itoa(i, buffer, 10));
        Serial.println(i);
    }

    i++;
    if (i % 1024 == 0) {
        i = 0;
    }

    // Wait for a bit to keep serial data from saturating
    delay(50);
}