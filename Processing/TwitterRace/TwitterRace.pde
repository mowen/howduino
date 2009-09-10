/*
  Processing prototype for Twitter Race cars.
  */

String raceTime;

String carAChar = "0";
float carAPosition;
color carAColor = color(255, 0, 0);
String carAName;
String[] carATweets;

String carBChar = "1";
float carBPosition;
color carBColor = color(0, 0, 255);
String carBName;
String[] carBTweets;

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
  
  carATweets = new String[5];
  carBTweets = new String[5];
  
  String timelineFile = selectInput();  // Opens file chooser
  if (timelineFile == null)
    println("No timeline was selected...");
  else
    times = loadStrings(timelineFile);
  
  String[] metadata = split(times[0], ",");
  raceTime = metadata[0];
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
  while (split(times[time], "@@@")[0].equals(stepChar)) {
    String car = split(times[time], "@@@")[1];
    String tweet = split(times[time], "@@@")[2];
    if (car.equals(carAChar)) {
      addTweet(car, tweet);
      carAPosition += carIncrement;
    }
    else if (car.equals(carBChar)) {
      addTweet(car, tweet);
      carBPosition += carIncrement;
    }
    time++;
    if (time == times.length - 1) {
      break;
    }
  }
}

void drawTweets() {
  textFont(fontA, 12);

  int i;

  for(i=0; i < carATweets.length; i++) {
    //System.out.println(carATweets[i]);
    text(carATweets[i], 10, 100 - (i * 10));
  }
  
  for(i=0; i < carBTweets.length; i++) {
    //System.out.println(carBTweets[i]);
    text(carBTweets[i], 10, 200 + (i * 10));
  }
}

void addTweet(String car, String tweet) {
  if (car.equals(carAChar)) {
    pushTweet(carATweets, tweet);
  }
  else if (car.equals(carBChar)) {
    pushTweet(carBTweets, tweet);
  }
}

void pushTweet(String[] tweets, String tweet) {
  for (int i=1; i < tweets.length; i++) {
    tweets[i] = tweets[i-1];
  }
  tweets[0] = tweet;
}

void draw() {
  background(0);
  drawStartAndFinishLine();
  fill(255, 255, 255);
  text(raceTime, 15, 40);

  if (time < times.length - 1)
    updateCars();

  drawCarA();
  drawCarB();
  drawTweets();

  step++;
}
