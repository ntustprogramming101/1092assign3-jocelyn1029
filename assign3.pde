final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24,life,stone1,stone2;
PImage [] imgsoil;int [] soilY ;int soilX;int grid=80;
//groundhog declare
PImage groundhogDownImg,groundhogIdleImg,groundhogLeftImg,groundhogRightImg;
int x,y;int groundhogW=80;
int groundhogLestX, groundhogLestY;
int groundhogMoveTime = 250;//move to next grid need 0.25s
int actionFrame; //groundhog's moving frame 
float lastTime; //time when the groundhog finished moving
int stroll,strollLest;

float playerHealthX, playerHealthY;
float playerHealth_Int = 2;
float playerHealth_Start = 10;
float playerHealth_Spacing = 20;
int PLAYER_HEALTH_MAX = 5;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
//life declare
int lifeX=10,lifeY=10,lifeW=51,lifeSpace=20;

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
  life=loadImage("img/life.png");
  stone1=loadImage("img/stone1.png");
  stone2=loadImage("img/stone2.png");
  groundhogDownImg=loadImage("img/groundhogDown.png");
  groundhogIdleImg=loadImage("img/groundhogIdle.png");
  groundhogLeftImg=loadImage("img/groundhogLeft.png");
  groundhogRightImg=loadImage("img/groundhogRight.png");
  // soil setup
  imgsoil = new PImage[6];
  soilY = new int [4];
  for (int i=0; i<6; i++){
    imgsoil[i] = loadImage("img/soil"+i+".png");
  }

  //player health 
playerHealth = int(playerHealth_Int);
constrain(playerHealth,0 ,PLAYER_HEALTH_MAX);

  //groundhog
  x=grid*4;
  y=grid; 
  frameRate(60);
  lastTime = millis(); // save lastest time call the millis();
  stroll=0;
}

void draw() {
    /* ------ Debug Function ------ 

      //Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

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
	    ellipse(590,50+stroll,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT+stroll, width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
		image(soil8x24, 0, 160+stroll);
    for (int i=0; i<6; i++){
      for (int k=0;k<8;k++){
        soilX=grid*k;
        for (int j=0; j<4; j++){
          soilY[j]=i*4*grid+j*grid+2*grid;
          image(imgsoil[i],soilX,soilY[j]+stroll);
        }
      } 
    }
    // put stones on the soil
    //layer 1-8
    for (int i=0;i<8;i++){
      image(stone1,i*grid,(i+2)*grid+stroll,grid,grid);
    }
    //layer 9-16
    for(int i=0;i<8;i++){
      if (i%4==1||i%4==2){
        for(int j=0;j<8;j++){
          if (j%4==0||j%4==3){
            image(stone1,j*grid,(i+10)*grid+stroll,grid,grid);
          }
        }
      }
      if (i%4==3||i%4==0){
        for(int j=0;j<8;j++){
          if (j%4==1||j%4==2){
            image(stone1,j*grid,(i+10)*grid+stroll,grid,grid);
          }
        }
      }
    }
    //layer 17-24
    for (int i=0;i<8;i++){
      if(i%3==0){
        for(int j=0;j<8;j++){
          if(j%3!=0){
            image(stone1,j*grid,(i+18)*grid+stroll,grid,grid);
            if(j%3==2){
              image(stone2,j*grid,(i+18)*grid+stroll,grid,grid);
            }
          }
        }
      }
      if(i%3==1){
        for(int j=0;j<8;j++){
          if(j%3!=2){
            image(stone1,j*grid,(i+18)*grid+stroll,grid,grid);
            if(j%3==1){
              image(stone2,j*grid,(i+18)*grid+stroll,grid,grid);
            }
          }
        }
      }
      if(i%3==2){
        for(int j=0;j<8;j++){
          if(j%3!=1){
            image(stone1,j*grid,(i+18)*grid+stroll,grid,grid);
            if(j%3==0){
              image(stone2,j*grid,(i+18)*grid+stroll,grid,grid);
            }
          }
        }
      }
    }

      for(int i = 0; i < playerHealth; i++){
      playerHealthX = playerHealth_Start + i * (playerHealth_Spacing + life.width);
      playerHealthY = playerHealth_Start;
      image(life, playerHealthX, playerHealthY);
    }
 

		// Player
    //draw the groundhogDown image between 1-14 frames
      if (downPressed) {
        if (stroll>-(20*grid)){
           actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            stroll -= grid / 15.0;
            image(groundhogDownImg,x,y);
          } else {
            stroll = strollLest- grid;
            downPressed = false;
          }
        }else{
          actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            y += grid / 15.0;
            image(groundhogDownImg,x,y);
          } else {
            y = groundhogLestY + grid;
            downPressed = false;
          }
        }
      }
      //draw the groundhogLeft image between 1-14 frames
      if (leftPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame <15) {
          x -= grid / 15.0;
         image(groundhogLeftImg,x,y);
        } else {
          x= groundhogLestX - grid;
          leftPressed = false;
        }
      }
      //draw the groundhogRight image between 1-14 frames
      if (rightPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame < 15) {
          x += grid / 15.0;
          image(groundhogRightImg,x,y);
        } else {
          x = groundhogLestX + grid;
          rightPressed = false;
        }
      }
      if(!downPressed&&!leftPressed&&!rightPressed){
        image(groundhogIdleImg,x,y);
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
      if (y<grid){
        y=grid;
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
