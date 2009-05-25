/*
 * TwitterRace
 * 
 * Note that HIGH and LOW are reversed for the car pins.
 *
 * TODO: Introduce a handicap on each car to account for differences in the speed of each car
 */

int redPin = 2;
int bluePin = 3;

int redCar = 0;
int blueCar = 1;
int noCar = 9;

int redCount = 0;
int blueCount = 0;

int lineFeed = 10;

void setup()
{
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);      
  digitalWrite(redPin, HIGH);
  digitalWrite(bluePin, HIGH);
}

void moveCars() {
  int offTime = 25;
  int onTimeCoeff = 20;

  if (redCount > 0)
    digitalWrite(redPin, LOW);

  if (blueCount > 0)
    digitalWrite(bluePin, LOW);
    
  if (redCount == blueCount && redCount != 0) {
    delay(onTimeCoeff*redCount);
    digitalWrite(redPin, HIGH);
    digitalWrite(bluePin, HIGH);
  }
  else if (redCount < blueCount) {
    delay(onTimeCoeff*redCount);              
    digitalWrite(redPin, HIGH);
    delay(onTimeCoeff*(blueCount-redCount));
    digitalWrite(bluePin, HIGH);
  }
  else { // Must be blueCount < redCount
    delay(onTimeCoeff*blueCount);              
    digitalWrite(bluePin, HIGH);
    delay(onTimeCoeff*(redCount-blueCount));
    digitalWrite(redPin, HIGH);
  }
  
  delay(offTime);
}

void readLine() {
  int incomingByte;
  while (incomingByte = Serial.read()) {
    //debugByte(incomingByte);
    if (incomingByte == lineFeed)
      break;
    else {
      incomingByte -= 48;
      if (incomingByte == redCar)
        redCount++;
      else if (incomingByte == blueCar)
        blueCount++;
    }
  }
}

void debugByte(int incomingByte) {
  if (incomingByte == lineFeed)
    Serial.print("\n");
  else
    Serial.print(incomingByte);
}

void loop()
{
  redCount = 0;
  blueCount = 0;
  if (Serial.available() > 0) {
    readLine();
    moveCars();
  }
  else {
    digitalWrite(redPin, HIGH);
    digitalWrite(bluePin, HIGH);
  }
}
