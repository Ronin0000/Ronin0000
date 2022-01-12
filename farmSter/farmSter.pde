import java.util.*;
import controlP5.*;

ControlP5 cp5;

int money = 1000;

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
int yDistance = 100;

int CurrentScreenPosiotionX = 0;
int CurrentScreenPosiotionY = 0;

int CurrentScreenPosiotionXEnd = width;
int CurrentScreenPosiotionYEnd = height;

int numberOfTrees = 3000;

int placingItem = 0;

String updatedWeather;

int playerHandItem;

int[] objectProperties = {10,10,20,20,1,0,255,255,255};
int numberOfObjects = objectProperties.length/9;

//1= THING, 2 = Quantity;
int[] playerItems = {};
int numberOfPlayerItems = playerItems.length/2;


//1 = Wheat, 2 = Grapes, 3 = Corn, 4 = Barely
//Thing, Price , Location, Quantinty
int[] storeProperties = {1, 5, 1, 20,2, 5, 1, 20,3, 5, 1, 20,4, 5, 1, 20};
int numberOfStoreObjects = storeProperties.length/4;

int amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls = 50;//The space at the edge of the screen where the character moves

void setup() {
  
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
  
  //X,Y,Xend,Yend,Shape,Size, red green, blue
  //1 == Square; 2 == Circle
   
  for(int i = 0;i<=numberOfTrees;i++){
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
    objectProperties = append(objectProperties,0);
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
  playerHandItem = selectedItemInventory;
  ellipseMode(RADIUS);
  numberOfObjects = objectProperties.length/9;
  CurrentScreenPosiotionXEnd = CurrentScreenPosiotionX+400;
  CurrentScreenPosiotionYEnd = CurrentScreenPosiotionY+400;
  background(color(0,255,0));
  if(gameStatus == GAME){
    stroke(0);
    for(int i = 1;i < numberOfObjects+1;i++){
      fill(color(objectProperties[i*9-1],objectProperties[i*9-2],objectProperties[i*9-3]));
      if(objectProperties[i*9-5] == 1){
        rect(objectProperties[i*9-9]-CurrentScreenPosiotionX,objectProperties[i*9-8]-CurrentScreenPosiotionY,objectProperties[i*9-7],objectProperties[i*9-6]);
      }else if(objectProperties[i*9-5] == 2){
        ellipse(objectProperties[i*9-9]-CurrentScreenPosiotionX,objectProperties[i*9-8]-CurrentScreenPosiotionY,objectProperties[i*9-7],objectProperties[i*9-6]);
      }else if(objectProperties[i*9-5] == 3){
        drawSampleWheat(objectProperties[i*9-9]-CurrentScreenPosiotionX, objectProperties[i*9-8]-CurrentScreenPosiotionY);
      }else{
        println("error --- shape type does not exist");
      }
      fill(#41424C);
      rect(width-100,5,95,65,7);
      fill(color(0,0,0));
      textSize(30); 
      text("$"+money,width-90,30);
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
      fill(#41424C);
      if((selectedItemInventory-1)*11 == j-1){stroke(color(255,0,0));}else{stroke(255,255,255);}
      rect(10*j, 80, 100, 100, 28);
    }
    fill(255);
    textSize(20);
    for(int d = 1;d<numberOfPlayerItems+1;d++){
      text(storeProperties[d*2-1],spacingDistance*d-negativeDistance,yDistance+30);
      if(playerItems[d*2-2] == 1){
        text("Wheat",spacingDistance*d-negativeDistance,yDistance);
      }
      else if(playerItems[d*2-2] == 2){
        text("Grapes",spacingDistance*d-negativeDistance,yDistance);
      }
      else if(playerItems[d*2-2] == 3){
        text("Corn",spacingDistance*d-negativeDistance,yDistance);
      }
      else if(playerItems[d*2-2] == 4){
        text("Barley",spacingDistance*d-negativeDistance,yDistance);
      }
      else{println("error --- crop type does not exist");}
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
      rect(10*f, 80, 100, 100, 28);
    }
    fill(255);
    textSize(20);
    for(int k = 1;k<numberOfStoreObjects+1;k++){
      text(storeProperties[k*4-1],spacingDistance*k-negativeDistance,yDistance+30);
      text("$"+storeProperties[k*4-3],spacingDistance*k-negativeDistance,yDistance+60);
      if(storeProperties[k*4-4] == 1){
        text("Wheat",spacingDistance*k-negativeDistance,yDistance);
      }
      else if(storeProperties[k*4-4] == 2){
        text("Grapes",spacingDistance*k-negativeDistance,yDistance);
      }
      else if(storeProperties[k*4-4] == 3){
        text("Corn",spacingDistance*k-negativeDistance,yDistance);
      }
      else if(storeProperties[k*4-4] == 4){
        text("Barley",spacingDistance*k-negativeDistance,yDistance);
      }
      else{println("error --- crop type does not exist");}
    }
  }
  if(placingItem == 1){
    drawSampleWheat(mouseX,mouseY);
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
    if(key == ENTER && gameStatus == STORE && money >= 5){
      numberOfPlayerItems = playerItems.length/2;
      playerItems = append(playerItems,storeProperties[selectedItem*4-4]);
      playerItems = append(playerItems,1);
      money = money - storeProperties[selectedItem*4-3];
      numberOfPlayerItems = playerItems.length/2;
    }
    if(key == ENTER && gameStatus == GAME && numberOfPlayerItems > 0){
      if(placingItem >= 1){placingItem = 0;}
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
    if(key == TAB && gameStatus == GAME){
      placeItem(mouseX,mouseY);
    }
   if (key == CODED && gameStatus == GAME) {
    if (keyCode == UP && objectProperties[1*9-8] > worldEdgeY) {
      objectProperties[1*9-8] = objectProperties[1*9-8] - characterMovingValue;
      
      if(objectProperties[1*9-8]<CurrentScreenPosiotionY+amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionY=CurrentScreenPosiotionY-10;}
      
    }else if(keyCode == DOWN && objectProperties[1*9-8] < worldSizeY){
      objectProperties[1*9-8] = objectProperties[1*9-8] + characterMovingValue;
      
      if(objectProperties[1*9-8]>CurrentScreenPosiotionYEnd-amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionY=CurrentScreenPosiotionY+10;}
      
    }else if(keyCode == LEFT && objectProperties[1*9-9] > worldEdgeX){
      objectProperties[1*9-9] = objectProperties[1*9-9] - characterMovingValue;
      
      if(objectProperties[1*9-9]<CurrentScreenPosiotionX+amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionX=CurrentScreenPosiotionX-10;}
      
    }else if(keyCode == RIGHT && objectProperties[1*9-9] < worldSizeX){
      objectProperties[1*9-9] = objectProperties[1*9-9] + characterMovingValue;
        
      if(objectProperties[1*9-9]>CurrentScreenPosiotionXEnd-amountOfSpaceFromTheEdgeOfTheScreenTillTheScreenScrolls){CurrentScreenPosiotionX=CurrentScreenPosiotionX+10;}
   
    }
  }
}

void drawSampleWheat(int x, int y){
  fill(color(0,200,0));
  stroke(0);
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

void placeItem(int x, int y){
  objectProperties = append(objectProperties,x);
  objectProperties = append(objectProperties,y);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,3);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,0);
  objectProperties = append(objectProperties,200);
  objectProperties = append(objectProperties,0);
}

void weatherChange(){
  if(weather == 1){
    updatedWeather = "Sunny";
  }else if(weather == 2){
    updatedWeather = "Cloudy";
  }else if(weather == 3){
    updatedWeather = "Rainy";
  }else{
    updatedWeather = "Stormy";
  }
}
