final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int count=8;

//image
PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24;
PImage [] imgsoil;int [] soilY ;int soilX;
PImage life;
PImage stone1, stone2;

//groundhog declare
PImage groundhogDown,groundhogIdle,groundhogLeft,groundhogRight;
int x,y;int groundhogW=80;
int groundhogLestX, groundhogLestY;
int groundhogMoveTime = 250;//move to next grid need 0.25s
int actionFrame; //groundhog's moving frame 
float lastTime; //time when the groundhog finished moving
int stroll,strollLest;

//soil
int soilWidth = 80;
int soilHeight = 80;

//life declare
int lifeX=10,lifeY=10,lifeW=51,lifeSpace=20;

//boolean
boolean upPressed = false, downPressed = false, leftPressed = false, rightPressed = false;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24 = loadImage("img/soil8x24.png");
  life = loadImage("img/life.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  
  //groundhog
  x=soilHeight*4;
  y=soilHeight; 
  frameRate(60);
  lastTime = millis(); // save lastest time call the millis();
  stroll=0;
  
  //
  imgsoil = new PImage[6];
  soilY = new int [4];
  for (int i=0; i<6; i++){
  imgsoil[i] = loadImage("img/soil"+i+".png");
}
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: 
    // Start Screen
		image(title, 0, 0);
    
    playerHealth=5;
    
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
      }
		}else{
			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

     // Grass
     fill(124, 204, 25);
     noStroke();
     rect(0, soilY - GRASS_HEIGHT, width, GRASS_HEIGHT);
     
    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    image(soil8x24, 0, 160+stroll);
    for (int i=0; i<6; i++){
      for (int k=0;k<8;k++){
        soilX=soilHeight*k;
        for (int j=0; j<4; j++){
          soilY[j]=i*4*soilHeight+j*soilHeight+2*soilHeight;
          image(imgsoil[i],soilX,soilY[j]+stroll);
        }
      } 
    }
    // put stones on the soil
        //layer 1-8
    for (int i=0;i<8;i++){
      image(stone1,i*soilHeight,(i+2)*soilHeight+stroll,soilHeight,soilHeight);
    }
    //layer 9-16
    for(int i=0;i<8;i++){
      if (i%4==1||i%4==2){
        for(int j=0;j<8;j++){
          if (j%4==0||j%4==3){
            image(stone1,j*soilHeight,(i+10)*soilHeight+stroll,soilHeight,soilHeight);
          }
        }
      }
      if (i%4==3||i%4==0){
        for(int j=0;j<8;j++){
          if (j%4==1||j%4==2){
            image(stone1,j*soilHeight,(i+10)*soilHeight+stroll,soilHeight,soilHeight);
          }
        }
      }
    }
    //layer 17-24
    for (int i=0;i<8;i++){
      if(i%3==0){
        for(int j=0;j<8;j++){
          if(j%3!=0){
            image(stone1,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            if(j%3==2){
              image(stone2,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            }
          }
        }
      }
      if(i%3==1){
        for(int j=0;j<8;j++){
          if(j%3!=2){
            image(stone1,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            if(j%3==1){
              image(stone2,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            }
          }
        }
      }
      if(i%3==2){
        for(int j=0;j<8;j++){
          if(j%3!=1){
            image(stone1,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            if(j%3==0){
              image(stone2,j*soilHeight,(i+18)*soilHeight+stroll,soilHeight,soilHeight);
            }
          }
        }
      }
    }
     
    //life
    for(int i=0;i<playerHealth;i++){
      imageMode(CORNER);
      image(life,lifeX+(lifeW+lifeSpace)*i,lifeY);
    }
    
        // Player
    //draw the groundhogDown image between 1-14 frames
      if (downPressed) {
        if (stroll>-(20*soilHeight)){
           actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            stroll -= soilHeight / 15.0;
            image(groundhogDown,x,y);
          } else {
            stroll = strollLest- soilHeight;
            downPressed = false;
          }
        }else{
          actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            y += soilHeight / 15.0;
            image(groundhogDown,x,y);
          } else {
            y = groundhogLestY + soilHeight;
            downPressed = false;
          }
        }
      }
      //draw the groundhogLeft image between 1-14 frames
      if (leftPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame <15) {
          x -= soilHeight / 15.0;
         image(groundhogLeft,x,y);
        } else {
          x= groundhogLestX - soilHeight;
          leftPressed = false;
        }
      }
      //draw the groundhogRight image between 1-14 frames
      if (rightPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame < 15) {
          x += soilHeight / 15.0;
          image(groundhogRight,x,y);
        } else {
          x = groundhogLestX + soilHeight;
          rightPressed = false;
        }
      }
      if(!downPressed&&!leftPressed&&!rightPressed){
        image(groundhogIdle,x,y);
      }
      
      //boundary detection
      if (x>=width-groundhogW){
        x=width-groundhogW;
      }
      if (x<=0){
        x=0;
      }
      if (y>height-groundhogW){
        y=height-groundhogW;
      }
      if (y<soilHeight){
        y=soilHeight;
      }
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
    }

void keyPressed(){

  // Add your moving input code here
  float newTime = millis(); //time when the groundhog started moving
  if (key == CODED) {
    switch (keyCode) {
    case DOWN:
      if (newTime - lastTime > groundhogMoveTime) {
        downPressed = true;
        actionFrame = 0;
        groundhogLestY = y;
        strollLest=stroll;
        lastTime = newTime;
      }
      break;
    case LEFT:
      if (newTime - lastTime > groundhogMoveTime) {
        leftPressed = true;
        actionFrame = 0;
        groundhogLestX = x;
        lastTime = newTime;
      }
      break;
    case RIGHT:
      if (newTime - lastTime > groundhogMoveTime) {
        rightPressed = true;
        actionFrame = 0;
        groundhogLestX = x;
        lastTime = newTime;
      }
      break;
    }
  }
  
	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}

void keyReleased(){
}
