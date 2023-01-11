int n = 100; // GRID SIZE
int growthFactor = 3; // IF YOU INCREASE THIS, GROWTH SPEED DECREASES
int w = 2; // WATER BIAS, 1 IS NO BIAS
int waterSpeed = 1; //IF YOU INCREASE THIS, WATER SPEED DECREASES

int[][] cellsNow = new int[n][n];
int[][] cellsNext = new int[n][n];
float pad = 0;
float cellSize;

int[][] xSpeeds = new int[n][n];
int[][] xSpeedsNext = new int[n][n];

int[][] genPassed = new int[n][n];
color[][] grass = new color[n][n];
color[][] water = new color[n][n];
color[][] waterNext = new color[n][n];

int W = 0; // WATER
int L = 1; // LAND
int H = 2; // TRAVELLING HUMAN
int S = 3; // SETTLED HUMAN
int B1 = 4; // BUILDING STAGE 1
int B2 = 5; // BUILDING STAGE 2
int B3 = 6; // BUILDING STAGE 3
int B4 = 7; // BUILDING STAGE 4
int B5 = 8; // BUILDING STAGE 5
int B6 = 9; // BUILDING STAGE 6
int B7 = 10; // BUILDING STAGE 7
int B8 = 11; // BUILDING STAGE 8

void setup(){
  size(700,700);
  cellSize = (width-2*pad)/n;
  frameRate( 60 );  
  backgroundcolour();
  noStroke();
  for(int i=0;i<n;i++) {
    for(int j=0;j<n;j++) {
      genPassed[i][j] = 0;
      grass[i][j] = color(
        random(120,160),
        random(220,260),
        random(120,160)
      );
      water[i][j] = color(
        random(30,80),
        random(30,80),
        random(235,255)
      );
      waterNext = water;
    }
  }
    
  
 
}

void draw() {
  background(0);
  
  float y = pad;
  
  for(int i=0; i < n; i++) {
    
    float x = pad;
    
    for(int j = 0; j < n; j++) {
      
        if (cellsNow[i][j] == W) {
            if (frameCount%waterSpeed == 0) {
              try {
                waterNext[i] = water[i+1];
              }
              catch(Exception e){
                waterNext[i] = water[0];
              }
            }
            
            
            water = waterNext;
            fill(water[i][j]);
            
        }

        else if (cellsNow[i][j] == L)
            fill(grass[i][j]);

        else if (cellsNow[i][j] == H)
            fill(255);
            
        else if (cellsNow[i][j] == S) {
            fill(255,0,0);
            genPassed[i][j] += 1;
        }

        else if (cellsNow[i][j] == B1) {
            fill(175);
            genPassed[i][j] += 1;
        }

        else if (cellsNow[i][j] == B2) {
            fill(150);
            genPassed[i][j] += 1;
        }
        
        else if (cellsNow[i][j] == B3) {
            fill(125);
            genPassed[i][j] += 1;
        }
            
        else if (cellsNow[i][j] == B4) {
            fill(100);
            genPassed[i][j] += 1;
        }

        else if (cellsNow[i][j] == B5) {
            fill(75);
            genPassed[i][j] += 1;
        }
        
        else if (cellsNow[i][j] == B6) {
            fill(50);
            genPassed[i][j] += 1;
        }
            
        else if (cellsNow[i][j] == B7) {
            fill(25);
            genPassed[i][j] += 1;
        }
            
        else if (cellsNow[i][j] == B8) {
            fill(0);
            genPassed[i][j] += 1;
        }
            
        square(x, y, cellSize); 
        
      
        x += cellSize;
    }
    
    y += cellSize;
  }
  setNextGen();
  copyNextGen();

  
}

void backgroundcolour() {
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < n; col++) {
        if (col < round(n*9/10)){
          cellsNow[row][col] = L;
          cellsNext[row][col] = L;
        }else{
          cellsNow[row][col] = W;
          cellsNext[row][col] = W;
        }
    }
  }
}


void setNextGen() {

    
    nextHuman();
    formBuilding();
    
    
}
 

void nextHuman() {
  try {
    for(int i=0; i<n; i++) {
        for(int j=0; j<n; j++) {   
          
          int b = round(random(1,6));
               if (b == 1)
                 xSpeeds[i][j] = 1;
               else if (b == 2)
                 xSpeeds[i][j] = 2;
               else if (b == 3)
                 xSpeeds[i][j] = 3;
               else if (b == 4)
                 xSpeeds[i][j] = 4;
               else if (b == 5)
                 xSpeeds[i][j] = 5;
               else if (b == 6)
                 xSpeeds[i][j] = 6;
                 
           
          int sx = xSpeeds[i][j];
          boolean isBlocked = false;
          
          if (cellsNow[i][j] == H){
            
            for(int m=1; m<8; m++) {
              if (cellsNow[i][j + m] == W || cellsNow[i][j + m] == S || cellsNow[i][j + m] == B1 || cellsNow[i][j + m] == B2 || cellsNow[i][j + m] == B3 || cellsNow[i][j + m] == B4 || cellsNow[i][j + m] == B5 || cellsNow[i][j + m] == B6 || cellsNow[i][j + m] == B7 || cellsNow[i][j + m] == B8) {
                cellsNext[i][j] = S; 
                isBlocked = true;
                break;
              }
            }
            if(!isBlocked){
              cellsNext[i][j] = L;
              cellsNext[i][j + sx] = H;
            }
  
            
          }
        
        }
      }
    }
    catch(Exception e) {}
  
}
 
 
void formBuilding() {
  
  for(int i=0; i<n; i++) {
     for(int j=0; j<n; j++) {
  
       if(cellsNow[i][j] == S){
         cellsNext[i][j] = B1;
       }
       if( cellsNow[i][j] >= 4 && cellsNow[i][j] < 11) {
           if (genPassed[i][j] == pow(cellsNow[i][j],growthFactor)){
             genPassed[i][j] = 0;
             cellsNext[i][j]++;
             for(int a = -1*w; a <= w; a++) {
               for(int b = -1; b <= 1; b++) {
                 try{
                   if ((cellsNext[i + a][j + b] == L) && (cellsNow[i + a][j + b] == L ) && (a != 0 || b !=0) && round(random(0,4)) == 0) {                    
                     cellsNext[i + a][j + b] += 3;
                   }
                 }
                 catch(Exception e){}
                  
               }
             }
           }
       }
     }
       
            
  }
}

  
 
 

void copyNextGen() {
  for(int i=0; i<n; i++) {
    for(int j=0; j<n; j++) {
      cellsNow[i][j] = cellsNext[i][j];
      xSpeeds[i][j] = xSpeedsNext[i][j];
    }
  }
}

  
void mouseClicked() {
  int clickedRow = int( (mouseY-pad)/cellSize );
    int clickedCol = int( (mouseX-pad)/cellSize );
    try {
      if (cellsNow[clickedRow][clickedCol] == L){
        try {  
          cellsNext[clickedRow][clickedCol] = H; 
          copyNextGen(); 
          redraw();       
        }
        catch(Exception e) {
        }
      }  
    }
    catch(Exception e) {
    }
}

void mouseDragged() {
    int clickedRow = int( (mouseY-pad)/cellSize );
    int clickedCol = int( (mouseX-pad)/cellSize );
    try {
      if (cellsNow[clickedRow][clickedCol] == L){  
          cellsNext[clickedRow][clickedCol] = H; 
          copyNextGen(); 
          redraw();     
      }  
    }
    catch(Exception e) {}
}
