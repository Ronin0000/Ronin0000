import java.util.*;
import controlP5.*;

ControlP5 cp5;

float money = 20;

int GAME = 1;
int STORE = 2;
int INVENTORY = 3;
int gameStatus = GAME;

//Weather: 1 = sunny, 2 = cloudy, 3 = rainy, 4= stormy
int weather = 1;

int worldSizeX = 5000;
int worldSizeY = 5000;

int worldEdgeX = 0;
int worldEdgeY = 0;

int selectedItem = 1;
int selectedItemInventory = 1;

int characterMovingValue = 5;

int spacingDistance = 115;
int negativeDistance = 93;
int yDistance = 80;

boolean succesful = false;
boolean succesful2 = false;

int CurrentScreenPosiotionX = 0;
int CurrentScreenPosiotionY = 0;

int CurrentScreenPosiotionXEnd = width;
int CurrentScreenPosiotionYEnd = height;

int numberOfTrees = 3000;

int placingItem = 0;

String updatedWeather;

int playerHandItem;

boolean controlsDisplayed = false;

//X,Y,Xend,Yend,Shape,Alpha,red green, blue
//1 == Square; 2 == Circle
int[] objectProperties = {10,10,20,20,1,255,255,255,255};
int numberOfObjects = objectProperties.length/9;

//1= THING, 2 = Quantity;
int[] playerItems = {};
int numberOfPlayerItems = playerItems.length/2;

int lastMinute = minute();

//1 = Wheat, 2 = Grapes, 3 = Corn, 4 = Barely
//Thing, Price
int[] storeProperties = {1, 5};
int numberOfStoreObjects = storeProperties.length/2;

int amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls = 50;//The space at the edge of the screen where the character moves

void setup() {
  
  changeCropStage();
   
  if(weather == 1){
    updatedWeather = "Sunny";
  }else if(weather == 2){
    updatedWeather = "Cloudy";
  }else if(weather == 3){
    updatedWeather = "Rainy";
  }else{
    updatedWeather = "Stormy";
  }
  
  size(800, 800);
   
  for(int i = 0;i<=numberOfTrees;i++){
    weatherChange();
    numberOfObjects = objectProperties.length/9;
    int x = int(random(10,4490));
    int y = int(random(10,4490));
    int randomSize;
    int randomNumber = int(random(0,3));
    if(randomNumber == 0 || randomNumber == 1){
      randomSize = int(random(20,30));
    }else{
      randomSize = int(random(5,10));
    }
    
    for(int j = 2;j < numberOfObjects;j++){
      var dx = (objectProperties[j*9-9] + objectProperties[j*9-7]) - (x + randomSize);
      var dy = (objectProperties[j*9-8] + objectProperties[j*9-7]) - (y + randomSize);
      var distance = Math.sqrt(dx * dx + dy * dy);
      while(distance < objectProperties[j*9-7] + objectProperties[j*9-7]) {
        x = int(random(10,4490));
        y = int(random(10,4490));
        dx = (objectProperties[j*9-9] + objectProperties[j*9-7]) - (x + randomSize);
        dy = (objectProperties[j*9-8] + objectProperties[j*9-7]) - (y + randomSize);
        distance = Math.sqrt(dx * dx + dy * dy);
      }
    }
    objectProperties = append(objectProperties,x);
    objectProperties = append(objectProperties,y);
    objectProperties = append(objectProperties,randomSize);
    objectProperties = append(objectProperties,randomSize);
    objectProperties = append(objectProperties,2);
    objectProperties = append(objectProperties,255);
    if(randomNumber == 0 || randomNumber == 1){
      objectProperties = append(objectProperties,0);
      objectProperties = append(objectProperties,int(random(200,255)));
      objectProperties = append(objectProperties,0);
    }else{
      objectProperties = append(objectProperties,int(random(100,190)));
      objectProperties = append(objectProperties,int(random(100,190)));
      objectProperties = append(objectProperties,int(random(100,190)));
    }
  }

}

void draw() {
  if(lastMinute<minute()){
    lastMinute = minute();
    changeWeather();
    weatherChange();
    changeCropStage();
  }
  playerHandItem = selectedItemInventory;
  ellipseMode(RADIUS);
  numberOfObjects = objectProperties.length/9;
  CurrentScreenPosiotionXEnd = CurrentScreenPosiotionX+400;
  CurrentScreenPosiotionYEnd = CurrentScreenPosiotionY+400;
  
  color backgroundColor = color(0,255,0);
  if(weather == 3 || weather == 4)
  {
    colorMode(HSB, 255);
    color weatherBackgroundColor = color(hue(backgroundColor), saturation(backgroundColor)*0.75, brightness(backgroundColor)*0.75);
    background(weatherBackgroundColor);
    colorMode(RGB, 255);
  }
  else
  {
    background(backgroundColor);
  }

  if(gameStatus == GAME){
    stroke(0);
    for(int i = 1;i < numberOfObjects+1;i++){
      color baseColor = color(objectProperties[i*9-1],objectProperties[i*9-2],objectProperties[i*9-3],objectProperties[i*9-4]);
      if(weather == 3 || weather == 4)
      {
        colorMode(HSB, 255);
        color weatherColor = color(hue(baseColor), saturation(baseColor)*0.75, brightness(baseColor)*0.75, alpha(baseColor));
        fill(weatherColor);
      }
      else
      {
        fill(baseColor);
      }
      
      if(objectProperties[i*9-5] == 1){
        rect(objectProperties[i*9-9]-CurrentScreenPosiotionX,objectProperties[i*9-8]-CurrentScreenPosiotionY,objectProperties[i*9-7],objectProperties[i*9-6]);
      }else if(objectProperties[i*9-5] == 2){
        ellipse(objectProperties[i*9-9]-CurrentScreenPosiotionX,objectProperties[i*9-8]-CurrentScreenPosiotionY,objectProperties[i*9-7],objectProperties[i*9-6]);
      }else if(objectProperties[i*9-5] == 3){
        int x = objectProperties[i*9-9]-CurrentScreenPosiotionX;
        int y = objectProperties[i*9-8]-CurrentScreenPosiotionY;
        arc(x, y, 10, 10, 0, HALF_PI);
        arc(x+10, y, 10, 10, 0, HALF_PI);
        arc(x+20, y, 10, 10, 0, HALF_PI);
        arc(x+30, y, 10, 10, 0, HALF_PI);
        arc(x, y+15, 10, 10, 0, HALF_PI);
        arc(x+10, y+15, 10, 10, 0, HALF_PI);
        arc(x+20, y+15, 10, 10, 0, HALF_PI);
        arc(x+30, y+15, 10, 10, 0, HALF_PI);
        arc(x, y+30, 10, 10, 0, HALF_PI);
        arc(x+10, y+30, 10, 10, 0, HALF_PI);
        arc(x+20, y+30, 10, 10, 0, HALF_PI);
        arc(x+30, y+30, 10, 10, 0, HALF_PI);
      }else{
        println("error --- shape type does not exist");
      }
      colorMode(RGB, 255);
      fill(#41424C);
      rect(width-100,5,95,65,7);
      fill(5);
      textSize(30); 
      text("$"+round(money),width-90,30);
      text(updatedWeather,width-90,60);
    }
  }else if(gameStatus == INVENTORY){
    background(#373737);
    fill(color(255,255,255));
    textSize(30); 
    text("$"+money,width-85,30);
    textSize(50);
    text("Inventory",10,40);
    for(int j = 1;j<numberOfPlayerItems*11;j=j+11){
      yDistance = 80;
      if(j/11>7){yDistance=yDistance+50;}
      if(j/11>14){yDistance=yDistance+50;}
      if(j/11>21){yDistance=yDistance+50;}
      fill(#41424C);
      if((selectedItemInventory-1)*11 == j-1){stroke(color(255,0,0));}else{stroke(255,255,255);}
      rect(10*j, yDistance, 100, yDistance+20, 28);
    }
    fill(255);
    textSize(20);
    for(int d = 1;d<numberOfPlayerItems+1;d++){
      text(playerItems[d*2-1],spacingDistance*d-negativeDistance,yDistance+50);
      if(playerItems[d*2-2] == 1){
        text("Wheat",spacingDistance*d-negativeDistance,yDistance+30);
      }
      else if(playerItems[d*2-2] == 2){
        text("Grapes",spacingDistance*d-negativeDistance,yDistance+30);
      }
      else if(playerItems[d*2-2] == 3){
        text("Corn",spacingDistance*d-negativeDistance,yDistance+30);
      }
      else if(playerItems[d*2-2] == 4){
        text("Barley",spacingDistance*d-negativeDistance,yDistance+30);
      }else if(playerItems[d*2-2] == 5){
        
      }else{println("error --- crop type does not exist");}
    }
  }else{
    background(#373737);
    fill(color(255,255,255));
    textSize(30); 
    text("$"+money,width-85,30);
    textSize(50);
    text("Store",10,40);
    for(int f = 1;f<numberOfStoreObjects*11;f=f+11){
      fill(#41424C);
      if((selectedItem-1)*11 == f-1){stroke(color(255,0,0));}else{stroke(255,255,255);}
      rect(10*f, yDistance, 100, yDistance+20, 28);
    }
    fill(255);
    textSize(20);
    for(int k = 1;k<numberOfStoreObjects+1;k++){
      text("$"+storeProperties[k*2-1],spacingDistance*k-negativeDistance,yDistance+50);
      if(storeProperties[k*2-2] == 1){
        text("Wheat",spacingDistance*k-negativeDistance,yDistance+30);
      }
      else if(storeProperties[k*2-2] == 2){
        text("Grapes",spacingDistance*k-negativeDistance,yDistance+30);
      }
      else if(storeProperties[k*2-2] == 3){
        text("Corn",spacingDistance*k-negativeDistance,yDistance+30);
      }
      else if(storeProperties[k*2-2] == 4){
        text("Barley",spacingDistance*k-negativeDistance,yDistance+30);
      }
      else{println("error --- crop type does not exist");}
    }
  }
  if(placingItem == 1){
    drawSampleWheat(mouseX,mouseY);
  }
  if(!controlsDisplayed){
    fill(190);
    rect(5,height-28,120,20,5);
    fill(5);
    textSize(10);
    text("Press C to Open Controls",10,height-15);
  }else{
    fill(190);
    rect(5,660,300,135,5);
    fill(5);
    textSize(10);
    text("Press C to Close Controls",10,height-15);
    text("Press S to open shop and close.",10,height-30);
    text("Press I to open inventory and close.",10,height-45);
    text("Press enter to select item or start placing crops or close placing crops.",10,height-60);
    text("Press tab to place crop while enter is pressed.",10,height-75);
    text("Use arrow keys to move and in shop switch selected item.",10,height-90);
    text("In the game plant crops and improve your farm.",10,height-120);
  }
}

void keyPressed() {
  if (key == CODED && gameStatus == STORE) {
    if(keyCode == LEFT && selectedItem > 1){
      selectedItem = selectedItem - 1;
    }else if(keyCode == RIGHT && selectedItem < numberOfStoreObjects){
      selectedItem = selectedItem + 1;
    }
  }
  if (key == CODED && gameStatus == INVENTORY) {
    if(keyCode == LEFT && selectedItemInventory > 1){
      selectedItemInventory = selectedItemInventory - 1;
    }else if(keyCode == RIGHT && selectedItemInventory < numberOfPlayerItems){
      selectedItemInventory = selectedItemInventory + 1;
    }
  }
  if(key == 's'){
      if(gameStatus == GAME){
        gameStatus = STORE;
      }else{
        gameStatus = GAME;
      }
    }
    if(key == 'i'){
      if(gameStatus == GAME){
        gameStatus = INVENTORY;
      }else{
        gameStatus = GAME;
      }
    }
    if(key == 'c'){
      if(controlsDisplayed){
        controlsDisplayed = false;
      }else{
        controlsDisplayed = true;
      }
    }
    if(key == ENTER && gameStatus == STORE && money >= 5){
      numberOfPlayerItems = playerItems.length/2;
      int alreadyThere = 0;
      for(int k = 1;k<numberOfPlayerItems+1;k++){
        if(storeProperties[selectedItem*2-2] == playerItems[k*2-2] && numberOfPlayerItems > 0){
          alreadyThere = k;
          break;
        }
      }
      if(alreadyThere == 0){
        playerItems = append(playerItems,storeProperties[selectedItem*2-2]);
        playerItems = append(playerItems,1);
      }else{
        playerItems[alreadyThere*2-1] = playerItems[alreadyThere*2-1] + 1;
      }
      money = money - storeProperties[selectedItem*2-1];
      numberOfPlayerItems = playerItems.length/2;
    }
    if(key == ENTER && gameStatus == GAME && numberOfPlayerItems > 0){
      if(placingItem > 0){
        placingItem = 0;
      }else{
        if(playerItems[playerHandItem*2-2] == 1){ 
          placingItem = 1;
        }
        else if(playerItems[playerHandItem*2-2] == 2){
          placingItem = 2;
        }
        else if(playerItems[playerHandItem*2-2] == 3){
          placingItem = 3;
        }
        else if(playerItems[playerHandItem*2-2] == 4){
          placingItem = 4;
        }
        else{println("error --- crop type does not exist");}
      }
    }
    if(key == TAB && gameStatus == GAME && placingItem > 0){
      succesful = true;
      for(int k = 1;k<numberOfObjects+1;k++){
        double distance = Math.sqrt((mouseX-objectProperties[k*9-9])*(mouseX-objectProperties[k*9-9]) + (mouseY-objectProperties[k*9-8])*(mouseY-objectProperties[k*9-8]));
        if(distance < 40){
          fill(color(255,0,0));
          text("You Can't Place Here",10,20);
          succesful = false;
          break;
        }
      }
      if(succesful && playerItems[placingItem*2-1] > 0){
        placeItem(mouseX,mouseY);
        playerItems[placingItem*2-1] = playerItems[placingItem*2-1] - 1;
      }
      for(int k = 1;k<numberOfPlayerItems+1;k++){
        if(playerItems[k*2-1] == 0){
          explode(playerItems, k*2-1);
          explode(playerItems, k*2-2);
        }
      }
    }
   if (key == CODED && gameStatus == GAME) {
    if (keyCode == UP && objectProperties[1*9-8] > worldEdgeY) {
      caculateCharacterDistance();
      objectProperties[1*9-8] = objectProperties[1*9-8] - characterMovingValue;
      
      if(objectProperties[1*9-8]<CurrentScreenPosiotionY+amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionY=CurrentScreenPosiotionY-10;}
      
    }else if(keyCode == DOWN && objectProperties[1*9-8] < worldSizeY){
      caculateCharacterDistance();
      objectProperties[1*9-8] = objectProperties[1*9-8] + characterMovingValue;
      
      if(objectProperties[1*9-8]>CurrentScreenPosiotionYEnd-amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionY=CurrentScreenPosiotionY+10;}
      
    }else if(keyCode == LEFT && objectProperties[1*9-9] > worldEdgeX){
      caculateCharacterDistance();
      objectProperties[1*9-9] = objectProperties[1*9-9] - characterMovingValue;
      
      if(objectProperties[1*9-9]<CurrentScreenPosiotionX+amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionX=CurrentScreenPosiotionX-10;}
      
    }else if(keyCode == RIGHT && objectProperties[1*9-9] < worldSizeX){
      caculateCharacterDistance();
      objectProperties[1*9-9] = objectProperties[1*9-9] + characterMovingValue;
        
      if(objectProperties[1*9-9]>CurrentScreenPosiotionXEnd-amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionX=CurrentScreenPosiotionX+10;}
   
    }
  }
}

void drawSampleWheat(int x, int y){
  color(0,255,0);
  arc(x, y, 10, 10, 0, HALF_PI);
  arc(x+10, y, 10, 10, 0, HALF_PI);
  arc(x+20, y, 10, 10, 0, HALF_PI);
  arc(x+30, y, 10, 10, 0, HALF_PI);
  arc(x, y+15, 10, 10, 0, HALF_PI);
  arc(x+10, y+15, 10, 10, 0, HALF_PI);
  arc(x+20, y+15, 10, 10, 0, HALF_PI);
  arc(x+30, y+15, 10, 10, 0, HALF_PI);
  arc(x, y+30, 10, 10, 0, HALF_PI);
  arc(x+10, y+30, 10, 10, 0, HALF_PI);
  arc(x+20, y+30, 10, 10, 0, HALF_PI);
  arc(x+30, y+30, 10, 10, 0, HALF_PI);
}

void placeItem(int xd, int yd){
  objectProperties = append(objectProperties,xd+CurrentScreenPosiotionX);
  objectProperties = append(objectProperties,yd+CurrentScreenPosiotionY);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,3);
  objectProperties = append(objectProperties,255);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,255);
  objectProperties = append(objectProperties,0);
  changeCropStage();
}

void weatherChange(){
  if(weather == 1){
    updatedWeather = "Sunny";
    for(int k = 2;k<numberOfObjects+1;k++){
      if(objectProperties[k*9-5] == 3){
        money = money + 1;
      }
    }
  }else if(weather == 2){
    updatedWeather = "Cloudy";
  }else if(weather == 3){
    updatedWeather = "Rainy";
  }else{
    updatedWeather = "Stormy";
    for(int k = 2;k<numberOfObjects+1;k++){
      if(objectProperties[k*9-5] == 3){
        money = money - 0.5;
      }
    }
  }
}

void caculateCharacterDistance(){
  for(int k = 2;k<numberOfObjects+1;k++){
    double distance = Math.sqrt((objectProperties[1*9-9]-objectProperties[k*9-9])*(objectProperties[1*9-9]-objectProperties[k*9-9]) + (objectProperties[1*9-8]-objectProperties[k*9-8])*(objectProperties[1*9-8]-objectProperties[k*9-8]));
    if(distance < 35){
      objectProperties[k*9-4] = 100;
    }else{
      objectProperties[k*9-4] = 255;
    }
  }
}

void changeWeather(){
  if(weather == 1){
    weather = 2;
  }else if(weather == 2){
    weather = 3;
  }else if(weather == 3){
    weather = 4;
  }else{
    weather = 1;
  }
}

void changeCropStage(){
  for(int k = 2;k<numberOfObjects+1;k++){
    if(objectProperties[k*9-5] == 3){
      if(weather == 3){
        objectProperties[k*9-1] = 4;
        objectProperties[k*9-2] = 124;
        objectProperties[k*9-3] = 9;
      }else if(weather == 4){
        objectProperties[k*9-1] = 0;
        objectProperties[k*9-2] = 77;
        objectProperties[k*9-3] = 61;
      }else if(weather == 1){
        objectProperties[k*9-1] = 169;
        objectProperties[k*9-2] = 198;
        objectProperties[k*9-3] = 4;
      }else if(weather == 2){
        objectProperties[k*9-1] = 125;
        objectProperties[k*9-2] = 137;
        objectProperties[k*9-3] = 63;
      }
    }
  }
}

int[] explode(int[] array,int index){                     // create the function
    int[] frontSet = subset(array, 0, index);            // get the front
    int[] endSet = subset(array, index , array.length-1);  // get the end
    return concat(frontSet, endSet);                    // join them
};
