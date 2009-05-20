/*
  Processing prototype for Twitter Race cars.
  */

float carAPosition;
color carAColor = color(255, 0, 0);
String carAName;

float carBPosition;
color carBColor = color(0, 0, 255);
String carBName;

float carIncrement = 2;

color white = color(255, 255, 255);

PFont fontA;

int windowHeight = 320;
int windowWidth = 800;

int step = 0;
String[] times;
int time = 1;

void setup() {
  size(windowWidth, windowHeight);
  smooth();

  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 32);
  
  carAPosition = 10.0;
  carBPosition = 10.0;
  
  times = loadStrings("../../timelines/apple_vs_microsoft.txt");

  String[] metadata = split(times[0], ",");
  carAName = split(metadata[1], ":")[1];
  carBName = split(metadata[2], ":")[1];
}

void drawStartAndFinishLine() {
 stroke(255, 255, 255);
 strokeWeight(2);
 line(10, 0, 10, windowHeight);
 line(windowWidth - 10, 0, windowWidth - 10, windowHeight);
}

//void drawCarLine(int baseHeight, color cl) { }

void drawCarA() {
 int lineHeight = 100;
 stroke(0, 0, 255);
 strokeWeight(50);
 line(10, lineHeight, carAPosition, lineHeight);
 fill(255, 255, 255);
 text(carAName, carAPosition - 15.0, lineHeight + 12.0);
}

void drawCarB() {
  int lineHeight = 200;
  stroke(255, 0, 0);
  strokeWeight(50);
  line(10, lineHeight, carBPosition, lineHeight);
  fill(255, 255, 255);
  text(carBName, carBPosition - 15.0, lineHeight + 12.0);
}

void updateCars() {
  String stepChar = Integer.toString(step);  
  while (split(times[time], ' ')[0].equals(stepChar)) {
    if (split(times[time], ' ')[1].equals("0"))
      carAPosition += carIncrement;
    else if (split(times[time], ' ')[1].equals("1"))
      carBPosition += carIncrement;
    time++;
    if (time == times.length - 1)
      break; 
  }
}

void draw() {
  background(0);
  drawStartAndFinishLine();

  if (time < times.length - 1)
    updateCars();

  drawCarA();
  drawCarB();

  step++;
}
