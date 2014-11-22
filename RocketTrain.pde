
Train[] redtrains = new Train[16]; 
Train[] bluetrains = new Train[16];

Train leftRed;
int leftRedSerial;
float leftRedClock;

Train rightRed;
int rightRedSerial;
float rightRedClock;

Train leftBlue;
int leftBlueSerial;
float leftBlueClock;

Train rightBlue;
int rightBlueSerial;
float rightBlueClock;

Meteor m;
Meteor n, o;
Meteor leftPhoto;
Meteor rightPhoto;
boolean leftYes; //is there a meteor in the left photo?
boolean rightYes;

PFont f;
float timer = 0;
int counter = 0;  //counts photos taken
int metcounter = 0; //counts pairs of meteors made

void setup() {
  size(1200, 400);

 


  f = createFont("Arial", 16, true);
  smooth();
  leftYes = false;
  rightYes = false;
  // Train(color c_, float xpos_, float ypos_, float xspeed_, int serial_, float offset_, int direction_) 
  for (int i = 0; i < redtrains.length; i ++ ) {
    redtrains[i] = new Train(color(250, 120, 120), width/2 - 4 - 70*i, 60, -1, i+1, i*.02, -1);
  }
  for (int i = 0; i < bluetrains.length; i ++ ) {
    bluetrains[i] = new Train(color(120, 120, 250), width/2 + 4 + 70*i, 100, 1, i+1, i*.02, 1);
  }
}

void draw() {
  background(255);
  textFont(f); 
  textAlign(LEFT);
  text("Down arrow key: Time step forward.", 450, 180);
  text("Up arrow key: Time step backward.", 450, 200);
  text("Left-click on a rocket: Take a photo.", 450, 220);
  text("Right-click: Emit meteors from red rocket 5.", 450, 240);




  for (int i = 0; i < redtrains.length; i ++ ) { 
    redtrains[i].display();
    bluetrains[i].display();
  }
  if (metcounter >0) {
    o.display();
    m.display();
    n.display();
    
  }
  //Make a left photo if there's at least one leftclick
  if (counter > 0) {
    noFill();
    stroke(1);
    rect(104, 310, 100, 140);
    Train leftRed = new Train(color(250, 120, 120), 100, 290, 0, leftRedSerial, leftRedClock, -1);
    Train leftBlue = new Train(color(120, 120, 250), 108, 330, 0, leftBlueSerial, leftBlueClock, 1);
    leftRed.display();
    leftBlue.display();
  }
  if (leftYes == true) {
    Meteor leftPhoto = new Meteor(color(0), 100, 310, 0);
    leftPhoto.display();
  }
  if (rightYes == true) {
    Meteor rightPhoto = new Meteor(color(0), 250, 310, 0);
    rightPhoto.display();
  }

  if (counter > 1) {
    noFill();
    stroke(1);
    rect(254, 310, 100, 140);
    Train rightRed = new Train(color(250, 120, 120), 250, 290, 0, rightRedSerial, rightRedClock, -1);
    Train rightBlue = new Train(color(120, 120, 250), 258, 330, 0, rightBlueSerial, rightBlueClock, 1);
    rightRed.display();
    rightBlue.display();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      for (int i = 0; i < redtrains.length; i ++ ) {
        redtrains[i].forward();
        bluetrains[i].forward();
        if (metcounter > 0) {
          m.forward();
          n.forward();
        }
        timer = timer -.000061;
        redtrains[i].clockUpdateForward();
        bluetrains[i].clockUpdateForward();
      }
    } 
    else if (keyCode == DOWN) {
      for (int i = 0; i < redtrains.length; i ++ ) {
        redtrains[i].backward();
        bluetrains[i].backward();
        if (metcounter > 0) {
          m.backward();
          n.backward();
        }
        timer = timer +.000061;
        redtrains[i].clockUpdateBackward();
        bluetrains[i].clockUpdateBackward();
      }
    }
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {  
    for (int i = 0; i < redtrains.length; i ++ ) {
      if (redtrains[i].clickedOn()) { 

        if (counter > 0) {
          rightRedSerial = leftRedSerial;
          rightRedClock = leftRedClock;
          rightBlueSerial = leftBlueSerial;
          rightBlueClock = leftBlueClock;
          rightYes = leftYes;
        }
        leftRedSerial = redtrains[i].serial;
        leftRedClock = redtrains[i].clock;
        counter++;

        //check if a blue rocket or meteor is across
        for (int j = 0; j < bluetrains.length; j ++ ) { 
          if (bluetrains[j].isAcrossFrom(redtrains[i])) {
            leftBlueSerial = bluetrains[j].serial;
            leftBlueClock = bluetrains[j].clock;

            break;
          }
          else {
            leftBlueSerial = 20;
          }
        }

        if (metcounter > 0) {
          if (redtrains[i].meteorCheck(m)==true || redtrains[i].meteorCheck(n)==true) {
            leftYes = true;
          }
          else {
            leftYes = false;
          }
        }
      }
    }
    for (int i = 0; i < bluetrains.length; i ++ ) {
      //Check if a blue train is clicked on
      if (bluetrains[i].clickedOn()) {
        if (counter > 0) {
          rightRedSerial = leftRedSerial;
          rightRedClock = leftRedClock;
          rightBlueSerial = leftBlueSerial;
          rightBlueClock = leftBlueClock;
          rightYes = leftYes;
        }

        leftBlueSerial = bluetrains[i].serial;
        leftBlueClock = bluetrains[i].clock;
        counter++;


        //check if a red rocket or meteor is across
        for (int j = 0; j < redtrains.length; j ++ ) {
          if (redtrains[j].isAcrossFrom(bluetrains[i])) {
            leftRedSerial = redtrains[j].serial;
            leftRedClock = redtrains[j].clock;

            break;
          }
          else {
            leftRedSerial = 20;
          }
        }

        if (metcounter > 0) {
          if (bluetrains[i].meteorCheck(m)==true || bluetrains[i].meteorCheck(n)==true) {
            leftYes = true;
          }
          else {
            leftYes = false;
          }
        }
      }
    }
  }
  if (mouseButton == RIGHT) {
    m = new Meteor(color(0), redtrains[4].xpos, 80, -.142);
    n = new Meteor(color(0), redtrains[4].xpos, 80, .142);  // .14 = light speed
    o = new Meteor(color(190), redtrains[4].xpos, 80, 0);
    metcounter++;
  }
}

class Meteor { 
  color c;
  float xpos;
  float ypos;
  float xspeed;

  Meteor(color c_, float xpos_, float ypos_, float xspeed_) {
    c = c_;
    xpos = xpos_;
    ypos = ypos_;
    xspeed = xspeed_;
  }

  float display() {
    noStroke();
    fill(c);
    ellipse(xpos+4, ypos, 8, 8);
    return xpos;
  }

  void forward() {
    xpos = xpos + xspeed;
  }

  void backward() {
    xpos = xpos - xspeed;
  }
}

class Train { 
  color c;
  float xpos;
  float ypos;
  float xspeed;
  int serial;
  float clock;
  int stored;
  int direction;

  Train(color c_, float xpos_, float ypos_, float xspeed_, int serial_, float offset_, int direction_) {
    c = c_;
    xpos = xpos_;
    ypos = ypos_;
    xspeed = xspeed_;
    serial = serial_;
    clock = offset_;
    stored = 0;
    direction = direction_;
  }

  float display() {
    rectMode(CENTER);
    noStroke();

    //Draw a blank if serial = 20
    if (serial == 20) {
      fill(255); 
      rect(xpos, ypos, 48, 24);
      return 0;
    }

    //Draw rocket
    else {
      fill(c);
      rect(xpos, ypos, 36, 20);
      triangle(xpos- direction*25, ypos, xpos-18*direction, ypos+10, xpos-18*direction, ypos-10); 

      //Write serial number
      fill(0);
      textAlign(CENTER);
      text(serial, xpos-direction*3, ypos+5);

      //Write clockreading
      textAlign(CENTER);
      text(clock, xpos - 2 - 2*direction, ypos+ 5+ 20*direction);
      return clock;
    }
  }

  void forward() {
    xpos = xpos + xspeed;
  }

  void backward() {
    xpos = xpos - xspeed;
  }

  float clockUpdateForward() {
    clock = clock - .000855;
    return clock;
  }

  float clockUpdateBackward() {
    clock = clock + .000855;
    return clock;
  }

  boolean meteorCheck(Meteor q) {
    if (xpos > q.xpos +4 && xpos < q.xpos+10 && direction ==1) {
      return true;
    }
    else if (xpos > q.xpos - 1.5 && xpos < q.xpos+2.5 && direction ==-1) {
      return true;
    }
    else {
      return false;
    }
  }

  boolean clickedOn() {
    if (mouseX < xpos + 10 && mouseX > xpos -10 && mouseY < ypos+10 && mouseY > ypos- 10) {
      return true;
    }
    else {
      return false;
    }
  }

  boolean isAcrossFrom(Train s) {
    if (xpos < s.xpos + 13 && xpos > s.xpos-10 && direction == 1 ) {
      return true;
    }
    if (xpos < s.xpos && xpos > s.xpos -13 && direction == -1 ) {
      return true;
    }
    else {
      return false;
    }
  }
}

