/*
 * TwitterRace
 * 
 * Note that HIGH and LOW are reversed for the car pins.
 */

int redPin = 2;
int bluePin = 3;
int sliderPin = 1;

int redCar = 0;
int blueCar = 1;
int noCar = 9;

void setup()
{
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);      
  digitalWrite(redPin, HIGH);
  digitalWrite(bluePin, HIGH);
}

void handleByte(int inputByte) {
  int rate = 500; //analogRead(sliderPin);
  //Serial.println(rate);
  
  int inputCar = inputByte - 48; // 0 = 48, 1 = 49
  int pinOffset = 2; // inputCar + pinOffset should give pin number
  
  if (inputCar == redCar || inputCar == blueCar) {
    digitalWrite(inputCar + pinOffset, LOW);
    delay(50);               
    digitalWrite(inputCar + pinOffset, HIGH);
    delay(rate);
  }
}

void loop()
{
  if (Serial.available() > 0) {
    int incomingByte = Serial.read();
    handleByte(incomingByte);
    Serial.println(incomingByte, DEC);
    Serial.read(); // Read the newline
  }
  else {
    digitalWrite(redPin, HIGH);
    digitalWrite(bluePin, HIGH);
  }
}
