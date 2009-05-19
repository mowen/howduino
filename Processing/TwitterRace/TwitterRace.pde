/*
  Processing prototype for Twitter Race cars.
  */

import processing.serial.*;

int linefeed = 10; // Linefeed in ASCII
Serial myPort;

float carAPosition;
color carAColor = color(255, 0, 0);

float carBPosition;
color carBColor = color(0, 0, 255);

float carIncrement = 2;

color white = color(255, 255, 255);

PFont fontA;

int windowHeight = 160;
int windowWidth = 320;

int step = 0;
String[] times;
int time = 0;

void setup() {
  size(windowWidth, windowHeight);
  smooth();

  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 32);
  
  carAPosition = 10.0;
  carBPosition = 10.0;
  
  times = loadStrings("../../timelines/swayze_vs_americanidol.txt");
  
//  println(Serial.list());
//  myPort = new Serial(this, Serial.list()[0], 9600);
//  myPort.bufferUntil(linefeed);
}

void drawStartAndFinishLine() {
 stroke(255, 255, 255);
 strokeWeight(2);
 line(10, 0, 10, windowHeight);
 line(windowWidth - 10, 0, windowWidth - 10, windowHeight);
}

//void drawCarLine(int baseHeight, color cl) { }

void drawCarA() {
 int lineHeight = 50;
 stroke(0, 0, 255);
 strokeWeight(25);
 line(10, lineHeight, carAPosition, lineHeight);
 fill(255, 255, 255);
 text("A", carAPosition - 15.0, lineHeight + 12.0);
}

void drawCarB() {
  int lineHeight = 100;
  stroke(255, 0, 0);
  strokeWeight(25);
  line(10, lineHeight, carBPosition, lineHeight);
  fill(255, 255, 255);
  text("B", carBPosition - 15.0, lineHeight + 12.0);
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

//void serialEvent(Serial myPort) {
//   String s = myPort.readStringUntil(linefeed);
//
//  if (s != null)
//    s = trim(s);
//    
//    
//}
