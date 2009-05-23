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

int redPin = 3;                // LED connected to digital pin 13
int potPin = 1;

void setup()                    // run once, when the sketch starts
{
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);      // sets the digital pin as output
}

void loop()                     // run over and over again
{
  int rate = analogRead(potPin);
  Serial.println(rate);
  digitalWrite(redPin, HIGH);   // sets the LED on
  delay(rate);                  // waits for a second
  digitalWrite(redPin, LOW);    // sets the LED off
  delay(50);                  // waits for a second
}
