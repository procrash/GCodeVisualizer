import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

import processing.opengl.*;
//import processing.video.*;

int width = 1920;
int height = 1200;

float rotationX = 0;
float rotationY = 0;
float depth = 100;

float w = 100;
float h = 100;
float x = -w/2;
float y = -h/2;
float z = 0;

class Point {
  float x;
  float y;
  float z;
  
  public Point(String[] pieces) {
    x = float(pieces[1].substring(1));
    y = float(pieces[2].substring(1));
    z = float(pieces[3].substring(1));
  }
}


void setup() {
    //size(width, height, P3D);
    size(1920, 1200, P3D);
    
    colorMode(HSB, 255);
    scale(1, -1, 1); 
    selectInput("Select a file to process:", "fileSelected");
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  depth += e*5;
  println("Wheel:"+depth);
}


boolean fileLoaded = false;
float deltaX = 0;
float deltaY = 0;

void draw() {
  if (fileLoaded) {
    background(255);
    
    if(mousePressed){
       rotationY -= (mouseX-pmouseX) * 0.01;
       rotationX -= (mouseY-pmouseY) * 0.01;
    } 

    translate(width/2+deltaX,height/2+deltaY ,  depth);
    rotateX(rotationX);  
    rotateZ(rotationY);

    scale(1, -1, 1); // Right-handed coordinate system, please. Thank you.

    for (int i=0;i<allpoints.length-1;i++){ 
      if (allpoints[i]!=null && allpoints[i+1]!=null ) {     
        float startX = allpoints[i].x;
        float startY = allpoints[i].y;
        float startZ = allpoints[i].z;

        float destX = allpoints[i+1].x;
        float destY = allpoints[i+1].y;
        float destZ = allpoints[i+1].z;

        stroke(#ff0000, 50);        
        line(startX-centerX,
             startY-centerY,
             startZ,
             destX-centerX,
             destY-centerY,
             destZ);
      }
    }
//    rect(x,y,w,h);
   }
//    box(100,100,100);
    
}


String[] inputfile;
Point[] allpoints;
int numpoints;
int maxpoints = 500000;
float cur_z = 0;

float max_x = 0;
float max_y = 0;
float max_z = 0;

float min_x = 0;
float min_y = 0;
float min_z = 0;

float centerX = 0;
float centerY = 0;
float centerZ = 0;

void fileSelected(File selection) {
  if (selection == null) {
  } else {

  String filename = selection.getAbsolutePath();
  println(filename);
  inputfile = loadStrings(filename);

  allpoints = new Point[maxpoints];
  numpoints = 0;

  // Cycle through all lines
  float e = 0;
  
  boolean not_initialized = true;
  for (int i=0; i<inputfile.length; i++) {
    String pieces[] = split(inputfile[i], ' ');  // deliminate data by spaces

    // Check for G1 code
    if (pieces.length > 2) {
          
      if (pieces[0].equals("G1")) {
        // Add new point
            
        if (numpoints < maxpoints) {
          allpoints[numpoints] = new Point(pieces);

          // Find maximums
          if (allpoints[numpoints].x > max_x || not_initialized) {
            max_x = allpoints[numpoints].x;
          }

          if (allpoints[numpoints].y > max_y || not_initialized) {
            max_y = allpoints[numpoints].y;
          }

          if (allpoints[numpoints].z > max_z || not_initialized) {
            max_z = allpoints[numpoints].z;
          }

    
          // Find minimums
          if (allpoints[numpoints].x < min_x || not_initialized) {
            min_x = allpoints[numpoints].x;
          }

          if (allpoints[numpoints].y < min_y || not_initialized) {
            min_y = allpoints[numpoints].y;
          }

          if (allpoints[numpoints].z < min_z || not_initialized) {
            min_z = allpoints[numpoints].z;
          }
          
          not_initialized = false;
          numpoints ++;
        }        
        
      }
    }
  }  
  
  centerX = (max_x-min_x) / 2;
  centerY = (max_y-min_y) / 2;
  centerZ = (max_z-min_z) / 2;

  fileLoaded = true;
  }
  
}
int step = 1;

void keyPressed() {
  if (key == 'a') {
    step = step / 2;
    if (step==0) step = 1;
  }

  if (key == 's') {
    step = step * 2;
  }  
  
  if (keyCode == LEFT) {
    deltaX--;
  }
  if (keyCode == RIGHT) {
    deltaX++;
  }
  
  if (keyCode == UP) {
    deltaY--;
  }
  if (keyCode == DOWN) {
    deltaY++;
  }
  
}





