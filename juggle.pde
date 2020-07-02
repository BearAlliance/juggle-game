// Nick Cacace
// Independant Project
// Programming for Media
// 11/24/2014

// "Juggle" a simple classic arcade game, implemented with objects

// Game will start paused, press 'o' to start game, press 'p' to pause
// Press 'r' to restart
// If you miss a ball, your lives will be reduced by one
// If you reach 0 lives, game is overs

//================ Constructor Vairiables ======================

final float g = .6;           // Acceleration due to gravity
final int QUANTITY = 3;       // Number of Balls
final int BUMPERWIDTH = 90;   // Widgh of the bumper
final int INITIALLIVES = 5;   // Initial number of lives

//========================== Setup ==============================
BouncingBall ball1;
Bumper bumper1;
BouncingBall[] balls = new BouncingBall[QUANTITY];
int lives = INITIALLIVES;
int score = 0;
boolean stop = true;
void setup() {
  size(400, 800);
  frameRate(40);
  smooth();
  //font setup
  PFont font;
  font = loadFont("SansSerif-48.vlw");
  textFont(font, 32);
  
  //creates balls
  for (int i = 0; i < QUANTITY; i++) {
    balls[i] = new BouncingBall(color(random(255), 0, 0));
  }
  //creates bumper
  bumper1 = new Bumper(BUMPERWIDTH, 20);
}

//==================== Draw ====================================
void draw() {
  background(#C4C4C4);
  text(lives, 380, 30);                  // lives
  text(score, 10, 30);                   // score
  for (int i = 0; i < QUANTITY; i++) {   // draw the ball motion
  balls[i].ballMotion();
  }
  bumper1.bumperMotion(mouseX); // create the bumper
  
  if (keyPressed){                      
    if (key == 's')                   // start
        stop = false;
    if (key == 'p')                   // pause
        stop = true;
    if (key == 'r') {                 // reset the game
     score = 0;
     lives = INITIALLIVES;
     for (int i = 0; i < QUANTITY; i++) {
       balls[i] = new BouncingBall(color(random(255), random(255), random(255)));
     }
   }
  }
  
  if (lives <= 0) {
    stop = true;
    text("Game Over", 100, 400);
  }
  if (stop) {
    text("< Score", 45, 30);
    text("Lives >", 250, 30);
    text("S - Start The Game", 5, 100);
    text("P - Pause", 5, 150);
    text("R - Restart", 5, 200);
  }
}

//===================  Bumper Class ============================
class Bumper
{
  public float[] location = new float[3];
  float bumperWidth;
  float bumperHeight;
  Bumper(int widthInput, int heightInput) {
    bumperWidth = widthInput;
    bumperHeight = heightInput;
    location[2] = widthInput / 4;
  }

  void bumperMotion(float mouse) {
    rectMode(CENTER);
    fill(#45479B);
    rect(mouse, 750, bumperWidth, bumperHeight);
  }

  public float[] bumperLocation() {
    location[0] = mouseX - (bumperWidth / 2); //left edge
    location[1] = mouseX + (bumperWidth / 2); //right edge
    return location;
  }
}

//==================== BouncingBall Class ========================
class BouncingBall
{
  //ball properties
  float xpos, ypos, velocity, hVelocity, elasticity; //ball position
  color c;
  boolean bottom, bounce;
  //bumper properties
  float leftEdge;
  float rightEdge;

  //constructor
  BouncingBall(color ballColor) {
    xpos = random(400);
    ypos = random (100);
    velocity = random(10);
    hVelocity = random(4);
    elasticity = .99;
    c = ballColor;
    bottom = false;
    stop = true;
    bounce = false;
  }
  
  boolean leftQuarter() {
    leftEdge = bumper1.bumperLocation()[0];
    rightEdge = bumper1.bumperLocation()[1];
    if (xpos >= leftEdge && xpos <= leftEdge + (BUMPERWIDTH / 3))
      return true;
    else
      return false;
  }
  
  boolean rightQuarter() {
    leftEdge = bumper1.bumperLocation()[0];
    rightEdge = bumper1.bumperLocation()[1];
    if (xpos <=rightEdge && xpos >= rightEdge - (BUMPERWIDTH / 3))
      return true;
    else
      return false;
  }

//====================== ballMotion =========================
  void ballMotion() {  
    fill(c);
    ellipse(xpos, ypos, 15, 15); //draw the ball
    //horizontal motion
    if (!stop) {
      xpos += hVelocity;
      if (xpos > 395) { //contact with right edge
        hVelocity = -hVelocity;
      }
      else if (xpos < 5) { //contact with left edge
        hVelocity = -hVelocity;
      }
    }   
    
    //bumper contact
    leftEdge = bumper1.bumperLocation()[0];
    rightEdge = bumper1.bumperLocation()[1];
    
    if (ypos >= 750) {
      if (xpos > leftEdge && xpos < rightEdge) {
        score++;
        bounce = true;
        stop = false;
        velocity *= elasticity;
        if (leftQuarter()){
          hVelocity -= 1.8;
        }
        else if (rightQuarter()) {
          hVelocity += 1.8;
        }
      }
    }
    if (ypos <=10) { //contact with top
      bounce = false;
      velocity *= elasticity;
    }
    if (!bounce && !stop) {
      ypos += velocity; //ball falls
      velocity = velocity + g; //apply gravity
      if (ypos >= height - 5) { //contact with bottom
        ypos = 0;
        velocity = 0;
        lives -=1;
      }
    } 
    if (bounce && !stop) {
      ypos -= velocity; //ball moves up
      velocity -= g; //apply gravity
      if (velocity <= 0) {
        bounce = false; 
       }
     }
   }
}

