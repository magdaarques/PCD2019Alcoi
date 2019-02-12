// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

import processing.sound.*;

SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 7; // Number of oscillators to use

PVector pos, p_pos;
float vel;

// The kinect stuff is happening in another class
Kinect kinect;
KinectTracker tracker;
PImage img;
PImage lienzo;
color pilla;

PGraphics pg, pg2;

void setup() {
  size(640, 520, P3D);
  //colorMode(HSB, 100);
  
  kinect = new Kinect(this);
  
  tracker = new KinectTracker();
  
  lienzo=loadImage("img.jpg");
  
  pg = createGraphics(width, height);
  pg2 = createGraphics(width, height, P3D);
  
  pos = new PVector(0,0,0);
  p_pos = new PVector(0,0,0);
  vel = 0;

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {
  //background(0);

  // Run the tracking analysis
  tracker.track();

  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  // Display some info
  int t = tracker.getThreshold();
  
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);

  pg.beginDraw();
  pg.image(lienzo, 0, 0, width, height);
  pg.endDraw();
  
  
  pilla = lienzo.get(int(v2.x), int(v2.y));

  
  pg2.beginDraw();
  pg2.background(0);
  
  pg2.noLights();
  //pg2.directionalLight(51, 102, 126, 0, -1, 0);
  pg2.spotLight(255, 255, 255, v2.x, v2.y, v2.z, 0, 0, -1, 160, 0);
  
  pg2.fill(50, 100, 250, 200);
  pg2.ellipse(v1.x, v1.y, 20, 20);
  pg2.fill(100, 250, 50, 200);
  pg2.noStroke();
  pg2.ellipse(v2.x, v2.y, 20, 20);

  PImage img = kinect.getVideoImage();
  
  for (int x = 0; x < img.width; x+=7) {
    for (int y =0; y < img.height; y+=7) {
      
      p_pos = pos.copy();
      pos.x = (int)v2.x;
      pos.y = (int)v2.y;
      pos.z = (int)noise(0.01*frameCount);
      vel = PVector.dist(p_pos, pos);
      
      int index = x+y*img.width;
      float b = brightness(img.pixels[index]);
      color c = color(img.pixels[index]);
      float z = map(b, 0, 254, 0.0, 1.0);
      int size = int(map(b,0,255,5,20));
      //pg2.stroke(pilla);
      pg2.fill( lerpColor(pilla, color(255), z) );
      pg2.pushMatrix();
      pg2.translate(x, y, map(b, 0, 254, -300, -20));
      pg2.box(size, size, size);
      pg2.popMatrix();
    }
  }
  pg2.fill(50, 100, 250, 200);
  pg2.ellipse(v1.x, v1.y, 20, 20);
  pg2.fill(100, 250, 50, 200);
  //noStroke();
  pg2.ellipse(v2.x, v2.y, 20, 20);
  //tracker.display();
  pg2.fill(pilla);
  pg2.rect(0, 0, 100, 100);
  
  pg2.endDraw();
  
  
  //Map pos from 0 to 1
  float yoffset = map(pos.y, 0, height, 0, 1);
  
  //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
  float frequency = pow(1000, yoffset) + 150;
  
  //Use mouseX mapped from -0.5 to 0.5 as a detune argument
  float detune = map(pos.x, 0, width, -0.5, 0.5);
  
  println(vel);

  for (int i = 0; i < numSines; i++) 
  { 
    sineFreq[i] = frequency * (i + 1 * detune * vel) * (1 + noise(pos.z*vel, 0.01*frameCount*pos.x));
    
    //sineFreq[i] = frequency * (i + 1 * detune * -0.01*pos.y) * (1 + noise(pos.z, 0.01*frameCount*pos.x));
    
    //sineFreq[i] = frequency * (i + 1 * detune * -0.5*pos.y) * (1 + noise(pos.z, 0.01*frameCount*pos.x));
    
    // Set the frequencies for all oscillators
    sineWaves[i].freq(sineFreq[i]);
  }
  
  //image(pg, 0,0,width,height);
  image(pg2, 0,0,width,height);
}




// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}
