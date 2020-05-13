PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

//soil
final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;
final int grid = 80;



int[][] soilHealth;

int pickNum=floor(random(8));


//buttons
final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

//cabbage and soildier
float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;

//player
float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;

//health
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;

//move
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");


  // Load PImage[][] soils
  soils = new PImage[6][5];
  for (int i = 0; i < soils.length; i++) {
    for (int j = 0; j < soils[i].length; j++) {
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  // Load PImage[][] stones
  stones = new PImage[2][5];
  for (int i = 0; i < stones.length; i++) {
    for (int j = 0; j < stones[i].length; j++) {
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  // Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  // Initialize soilHealth
  soilHealth = new int[8][24];
  for (int i = 0; i < soilHealth.length; i++) {
    for (int j = 0; j < soilHealth[i].length; j++) {
      // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;  //all the objects in this array =15


      //AREA A(1-8) : soilHealth
      if (j>=0 && j<8) {
        if (j==i) {
          soilHealth[i][j] = 30;
          println(soilHealth[i][j]);
        }
      }//AREA A(1-8) : soilHealth

      //AREA B(8-16): soilHealth
      if (j>=8 && j<16 ) {
        if (j%4==1||j%4==2) {
          if (i%4==0||i%4==3) {
            soilHealth[i][j] = 30;
          }
        }
      } //AREA B(8-16): soilHealth A 
      if (j>=8 && j<16 ) {
        if (j%4==0||j%4==3) {
          if (i%4==1||i%4==2) {
            soilHealth[i][j] = 30;
          }
        }
      } //AREA B(8-16): soilHealth B

      //AREA C(16-24): soilHealth C
      //stone1
      if (j>=16 && j<24 ) {
        if (j==16||j==19||j==22) {
          if (i%3==1||i%3==2) {
            soilHealth[i][j] = 30;
          }
          if (i%3==2) {
            soilHealth[i][j] = 45;
          }
        }//i
      }//if i>=16 <24

      if (j>=16 && j<24 ) {
        if (j==17||j==20||j==23) {
          if (i%3==0||i%3==1) {
            soilHealth[i][j] = 30;
          }
          if (i%3==1) {
            soilHealth[i][j] = 45;
          }
        }//i
      }//if i>=16 <24

      if (j>=16 && j<24 ) {
        if (j==18||j==21) {
          if (i%3==0||i%3==2) {
            soilHealth[i][j] = 30;
          }
          if (i%3==0) {
            soilHealth[i][j] = 45;
          }
        }//if
      }//AREA C(16-24): soilHealth C
    }//NASTED LOOP
  }//NASTED LOOP

  //empty
      for (int a =1; a<24; a++) {
         for (int j = 1; j <= 1+ floor(random(0, 2)); j++) {
        int pickcol = floor(random(0, 8));
          soilHealth[pickcol][a] = 0;
        
      }
    }//for pickNum



  // Initialize soidiers and their position
  soldierX = new float[6];
  soldierY = new float[6];

  for (int i=0; i<6; i++) {
    soldierX[i]=random(0, 640);
    soldierY[i]=floor(random(0+i*4, 4+i*4))*grid;
  }


  // Initialize cabbages and their position
  cabbageX = new float[6];
  cabbageY = new float[6];

  for (int i=0; i<6; i++) {
    cabbageX[i]=floor(random(0, 8))*grid;
    cabbageY[i]=floor(random(0+i*4, 4+i*4))*grid;
  }
}//void setup

void draw() {

  switch (gameState) {

  case GAME_START: // Start Screen
    image(title, 0, 0);
    if (START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    }

    break;

  case GAME_RUN: // In-Game
    // Background
    image(bg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);

    // CAREFUL!
    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
    pushMatrix();
    translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

    // Ground

    fill(124, 204, 25);
    noStroke();
    rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 24; j++) {


        // NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
        int areaIndex = floor(j / 4);
        int mapFrameImg =3; 
        image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
          
          
        // Change this part to show soil and stone images based on soilHealth value
        
        //30
        if (soilHealth[i][j]==30) {
          image(stones[0][4], grid*i, grid*j);
          image(stones[0][4], grid*i, grid*j);
        }
        
        
        //45
        if (soilHealth[i][j]==45) {
          image(stones[01][4], grid*i, grid*j);
          image(stones[1][4], grid*i, grid*j);
        }

        if (soilHealth[i][j]==0) {
          image(soils[areaIndex][0], i * SOIL_SIZE, j * SOIL_SIZE);
        }
        
        
        
        
      }
    }




    // Groundhog

    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if (playerMoveTimer == 0) {
       if(playerRow<23){
      if (soilHealth[playerCol][playerRow+1]==0) {
      // Check if "player is NOT at the bottom AND the soil under the player is empty"
      // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
      // > Else then determine player's action based on input state
      playerMoveDirection = DOWN;
      playerMoveTimer = playerMoveDuration;
    }
       }
      if (leftState) {

        groundhogDisplay = groundhogLeft;

        // Check left boundary
        if (playerCol > 0) {
          // HINT:
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)
          if (playerY==-grid) {
            playerMoveDirection = LEFT;
            playerMoveTimer = playerMoveDuration;
            
          } else if (playerRow>-1 ) {  
            if (soilHealth[playerCol-1][playerRow]>0) {
              playerMoveDirection = LEFT;
              playerX=playerCol*grid;
              if (playerMoveDirection == LEFT) {
                soilHealth[playerCol-1][playerRow]--;
              }
            } else {///pass it
              playerMoveDirection = LEFT;
              playerMoveTimer = playerMoveDuration;
            }//else
          }//row>-1
        }
      } else if (rightState) {

        groundhogDisplay = groundhogRight;

        // Check right boundary
        if (playerCol < SOIL_COL_COUNT - 1) {

          if (playerY==-grid) {
            playerMoveDirection = RIGHT;
            playerMoveTimer = playerMoveDuration;
          } else if (playerRow>-1) {  
            if (soilHealth[playerCol+1][playerRow]>0) {
              playerMoveDirection = RIGHT;
              playerX=playerCol*grid;

              if (playerMoveDirection == RIGHT) {
                soilHealth[playerCol+1][playerRow]--;
              }
            } else {///pass it
              playerMoveDirection = RIGHT;
              playerMoveTimer = playerMoveDuration;
            }//else
          }//row>-1
        }
      } else if (downState) {

        groundhogDisplay = groundhogDown;

        // Check bottom boundary

        // HINT:
        // We have already checked "player is NOT at the bottom AND the soil under the player is empty",
        // and since we can only get here when the above statement is false,
        // we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
        if (playerRow < SOIL_ROW_COUNT - 1) {

          // > If so, dig it and decrease its health

          // For requirement #3:
          // Note that player never needs to move down as it will always fall automatically,
          // so the following 2 lines can be removed once you finish requirement #3
          if (soilHealth[playerCol][playerRow+1]>0) {

            playerMoveDirection = DOWN;
            playerY=playerRow*grid;

            if (playerMoveDirection == DOWN) {
              soilHealth[playerCol][playerRow+1]--;
            }
          } else {///pass it
            playerMoveDirection = DOWN;
            playerMoveTimer = playerMoveDuration;
          }//else
        }
      }
    }

    // If player is now moving?
    // (Separated if-else so player can actually move as soon as an action starts)
    // (I don't think you have to change any of these)

    if (playerMoveTimer > 0) {

      playerMoveTimer --;
      switch(playerMoveDirection) {

      case LEFT:
        groundhogDisplay = groundhogLeft;
        if (playerMoveTimer == 0) {
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        } else {
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }
        break;

      case RIGHT:
        groundhogDisplay = groundhogRight;
        if (playerMoveTimer == 0) {
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        } else {
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

      case DOWN:
        groundhogDisplay = groundhogDown;
        if (playerMoveTimer == 0) {
          playerRow++;
          playerY = SOIL_SIZE * playerRow;
        } else {
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }
    }

    image(groundhogDisplay, playerX, playerY);




    // Cabbages// > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for (int i=0; i<6; i++) {
      image(cabbage, cabbageX[i], cabbageY[i]);

      if (playerHealth<5) {
        int groundHog_W =80;
        int cabbage_W=80;
        if (cabbageX[i]<playerX+groundHog_W&& cabbageX[i]+cabbage_W>playerX
          && cabbageY[i]<playerY+groundHog_W&& cabbageY[i]+cabbage_W>playerY) {
          cabbageX[i]=2000;
          cabbageY[i]=2000;
          playerHealth++;
        }
      }//playerhealth
    }
    // Soldiers
    for (int i=0; i<6; i++) {
      soldierX[i]+=soldierSpeed;
      soldierX[i]%=640+80;
      image(soldier, soldierX[i], soldierY[i]);
    }

    //touch the soldier ///unfinished

    for (int i=0; i<6; i++) {
      int groundHog_W =80;
      int soldier_W=80;
      if (soldierX[i]<playerX+groundHog_W&& soldierX[i]+soldier_W>playerX
        && soldierY[i]<playerY+groundHog_W&& soldierY[i]+soldier_W>playerY) {
          
          
        leftState = false;
        rightState = false;
        downState = false;
        playerMoveTimer = 0;
        playerX=4*grid;
        playerY=-grid;
        playerCol=4;
        playerRow=-1;
        playerHealth-=1;
        soilHealth[4][0]=15;
      }
    }//for

    // > Remember to stop player's moving! (reset playerMoveTimer)
    // > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
    // > Remember to reset the soil under player's original position!






    // Demo mode: Show the value of soilHealth on each soil
    // (DO NOT CHANGE THE CODE HERE!)
    if (demoMode) {	

      fill(255);
      textSize(26);
      textAlign(LEFT, TOP);

      for (int i = 0; i < soilHealth.length; i++) {
        for (int j = 0; j < soilHealth[i].length; j++) {
          text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }
    }

    popMatrix();

    // Health UI
    float lifeX = 10; 
    float lifeY = 10;
    float lifeSpacing = 70;


    for (int j=0; j<playerHealth; j++) {
      if (playerHealth<PLAYER_MAX_HEALTH) {
        lifeX = 10+j*lifeSpacing;
        image(life, lifeX, lifeY);
      } else {
        playerHealth=PLAYER_MAX_HEALTH;
        lifeX = 10+j*lifeSpacing;
        image(life, lifeX, lifeY);
      }//else
    }//for

    if (playerHealth==0) {
      gameState=2;
    }

    break;

  case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);

    if (START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;

        // Initialize player
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth = 2;

          // Initialize soilHealth
  soilHealth = new int[8][24];
  for (int i = 0; i < soilHealth.length; i++) {
    for (int j = 0; j < soilHealth[i].length; j++) {
      // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;  //all the objects in this array =15


      //AREA A(1-8) : soilHealth
      if (j>=0 && j<8) {
        if (j==i) {
          soilHealth[i][j] = 30;
          println(soilHealth[i][j]);
        }
      }//AREA A(1-8) : soilHealth

      //AREA B(8-16): soilHealth
      if (j>=8 && j<16 ) {
        if (j%4==1||j%4==2) {
          if (i%4==0||i%4==3) {
            soilHealth[i][j] = 30;
          }
        }
      } //AREA B(8-16): soilHealth A 
      if (j>=8 && j<16 ) {
        if (j%4==0||j%4==3) {
          if (i%4==1||i%4==2) {
            soilHealth[i][j] = 30;
          }
        }
      } //AREA B(8-16): soilHealth B

      //AREA C(16-24): soilHealth C
      //stone1
      if (j>=16 && j<24 ) {
        if (j==16||j==19||j==22) {
          if (i%3==1||i%3==2) {
            soilHealth[i][j] = 30;
          }
          if (i%3==2) {
            soilHealth[i][j] = 45;
          }
        }//i
      }//if i>=16 <24

      if (j>=16 && j<24 ) {
        if (j==17||j==20||j==23) {
          if (i%3==0||i%3==1) {
            soilHealth[i][j] = 30;
          }
          if (i%3==1) {
            soilHealth[i][j] = 45;
          }
        }//i
      }//if i>=16 <24

      if (j>=16 && j<24 ) {
        if (j==18||j==21) {
          if (i%3==0||i%3==2) {
            soilHealth[i][j] = 30;
          }
          if (i%3==0) {
            soilHealth[i][j] = 45;
          }
        }//if
      }//AREA C(16-24): soilHealth C
    }//NASTED LOOP
  }//NASTED LOOP

  //empty
      for (int a =1; a<24; a++) {
         for (int j = 1; j <= 1+ floor(random(0, 2)); j++) {
        int pickcol = floor(random(0, 8));
          soilHealth[pickcol][a] = 0;
        
      }
    }//for pickNum

         // Initialize soidiers and their position
  soldierX = new float[6];
  soldierY = new float[6];

  for (int i=0; i<6; i++) {
    soldierX[i]=random(0, 640);
    soldierY[i]=floor(random(0+i*4, 4+i*4))*grid;
  }


  // Initialize cabbages and their position
  cabbageX = new float[6];
  cabbageY = new float[6];

  for (int i=0; i<6; i++) {
    cabbageX[i]=floor(random(0, 8))*grid;
    cabbageY[i]=floor(random(0+i*4, 4+i*4))*grid;
  }

        
        
        
      }
    } else {

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }
}

void keyPressed() {
  if (key==CODED) {
    switch(keyCode) {
    case LEFT:
      leftState = true;
      break;
    case RIGHT:
      rightState = true;
      break;
    case DOWN:
      downState = true;
      break;
    }
  } else {
    if (key=='b') {
      // Press B to toggle demo mode
      demoMode = !demoMode;
    }
  }

  switch(key) {
  case 'a':
    if (playerHealth > 0) playerHealth --;
    break;

  case 'd':
    if (playerHealth < PLAYER_MAX_HEALTH) playerHealth ++;
    break;
  }
}

void keyReleased() {
  if (key==CODED) {
    switch(keyCode) {
    case LEFT:
      leftState = false;
      break;
    case RIGHT:
      rightState = false;
      break;
    case DOWN:
      downState = false;
      break;
    }
  }
}
