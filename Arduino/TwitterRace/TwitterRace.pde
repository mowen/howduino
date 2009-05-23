/*
 * Blink
 *
 * The basic Arduino example.  Turns on an LED on for one second,
 * then off for one second, and so on...  We use pin 13 because,
 * depending on your Arduino board, it has either a built-in LED
 * or a built-in resistor so that you need only an LED.
 *
 * http://www.arduino.cc/en/Tutorial/Blink
 */

int redPin = 2;
int bluePin = 3;
int potPin = 1;

//int lineFeed = 10;
int redCar = 0;
int blueCar = 1;
int noCar = 9;

void setup()                    // run once, when the sketch starts
{
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);      // sets the digital pin as output
  pinMode(bluePin, OUTPUT);          
  digitalWrite(redPin, HIGH);
  digitalWrite(bluePin, HIGH);
}

/*void readLine() {
  int incomingByte;
  int[15] lines;
  int i = 0;
  while(  = Serial.read()) {
     
  }
} */

void handleByte(int inputByte, int rate) {
  if (inputByte == redCar) {
    digitalWrite(redPin, LOW);
    delay(50);                  // waits for a second
    digitalWrite(redPin, HIGH);    // sets the LED off
    delay(rate);                  // waits for a second
  }
  else if (inputByte == blueCar) {
    digitalWrite(bluePin, LOW);
    delay(50);                  // waits for a second
    digitalWrite(bluePin, HIGH);    // sets the LED off
    delay(rate);                  // waits for a second
  }
}


void loop()                     // run over and over again
{
  int rate = analogRead(potPin);
  Serial.println(rate);
  
  if (Serial.available() > 0) {
	// read the incoming byte:
	int incomingByte = Serial.read() - 48;
        handleByte(incomingByte, rate);
	// say what you got:
	Serial.println(incomingByte, DEC);
        /* digitalWrite(redPin, LOW);
        digitalWrite(bluePin, LOW); */
        //delay(50);
        Serial.read(); // Read the newline
  }
  else {
    digitalWrite(redPin, HIGH);    // sets the LED off
    digitalWrite(bluePin, HIGH);
  }
  /* int rate = analogRead(potPin);
  Serial.println(rate);
  digitalWrite(redPin, HIGH);   // sets the LED on
  delay(rate);                  // waits for a second
  digitalWrite(redPin, LOW);    // sets the LED off
  delay(50);                  // waits for a second
  */
}
