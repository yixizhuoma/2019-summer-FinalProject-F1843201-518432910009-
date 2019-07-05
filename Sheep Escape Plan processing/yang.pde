import processing.serial.*;          
Serial myPort;                        
Littleman pan;                        
Blob blob;                            
Back background;                      
boolean heightflag = false;
String over;
boolean serialFlag;

void setup()
{
  size(900, 600);
  smooth();
  pan = new Littleman(160, 410);
  blob = new Blob(50, 410);
  background=new Back(0, 0);
  over = new String("game is over");
    try {
      myPort = new Serial(this, "COM5", 115200);
  serialFlag = true;                      
    } 
    catch (Exception e) {
      println("open failed");
    }
}


void draw() {

  background(255);
  blob.change();                    
  background.display();             
  pan.display();                    

  blob.display();                   
  distance();                       
  pan.run();                        
  blob.run();                       
  background.run();                 
  serialDisplay();
}

/*
void keyPressed()
{
  if (keyCode == UP && !serialFlag) {

    if (!pan.lock) {
      pan.setjump(220);
      pan.lock=true;
    }
  }
  //if (key == 'o') {
    try {
      openSerial();                        
    } 
    catch (Exception e) {
      println("open failed");
    }
  //}
}*/


void openSerial()
{
  myPort = new Serial(this, "COM5", 115200);
  serialFlag = true;
}
void serialDisplay()
{
  if (serialFlag) {
    if (myPort.available() > 0) {
      String buff = myPort.readString();
      print(buff);
      if (pan.lock != true)
      {pan.setjump(220);
      pan.lock=true;
      }  
  }
  }
  if (serialFlag) {
    textSize(20);                        
    fill(255, 102, 153); 
    text("serial: open", 200, 50);       
                   
  } else {
    textSize(20);
    fill(255, 102, 153);
    text("serial: off", 200, 50);
    
  }
}
void keyReleased()
{
  pan.state = 0;
}

void distance()
{/*
  for (int i = 0; i < 20; i++) {
    print((sqrt(pow(230-blob.obstacle[i], 2))+sqrt(pow(pan.y-40+160-460, 2))));
    print("\n");
    if ((sqrt(pow(230-blob.obstacle[i], 2))+sqrt(pow(pan.y-40+160-460, 2))) < 1000) {
      
      
      textSize(60);
      fill(255, 102, 153);
      text("game is over      T_T", 200, 300);
      
      noLoop();
    }*/
    
    
        for (int i = 0; i < 20; i++) {
    //print(sqrt(pow(pan.y-40+120-460, 2)));
    //print("\n");
    if (sqrt(pow(230-blob.obstacle[i], 2))+sqrt(pow(pan.y-40+120-460, 2)) < 50) {
      
      
      textSize(60);
      fill(255, 102, 153);
      text("game is over      T_T", 200, 300);
      
      noLoop();
      
    }
  }
    
  
}

class Littleman
{
  int state;                
  final int x;              
  int y;                    
  int goalheight;           
  int speed;                

  int a;                    
  boolean lock;             
  PImage[] photo;
  Littleman(int x, int y) {
    photo = new PImage[21];
    /*for (int i = 4; i< 21; i++) {
      String a = "IMG000"+i+".png";
      println(a);
      photo[i-4] = loadImage(a);
    }*/
    
    
    for (int i = 4; i< 21; i++) {
      String a = "IMG0001"+".png";
      println(a);
      photo[i-4] = loadImage(a);}
    
    
    
    state=0;
    this.x = x;
    this.y = y;
    goalheight = 410;
    speed = 12;
    a = 1;
  }
  void run() {
    //state =++state%16+1;
  }
  void stop() {
    state = 0;
  }
  void setjump(int x) {
    goalheight=x;
  }
  void display() {
    if (y != goalheight) {
      if (y < goalheight) {

        y+=speed;               
        speed-=a;
      } else if (y > goalheight) {
        y-=speed;           
        speed-=a;
      }
    } else {
      goalheight = 410;
      speed =24;
      if (y ==410) lock = false;
    }
    image(photo[state], x, y);
  }
}
class Back
{
  PImage[] background;
  int x;                
  int y;                
  int count;
  int x1;               
  int x2;              
  Back(int x, int y) {
    background = new PImage[2];
    this.x1=x;
    this.x2=x+900;
    this.y=y;
    for (int i = 0; i< 2; i++) {
      String a = "background"+".png";
      background[i] = loadImage(a);
    }
  }

  void run() {
    x1--;
    x2--;
  }
  void display() {
    if (x1 == -900) {
      x1 =900;
    }
    if (x2 == -900) {
      x2=900;
    }

    image(background[0], x1, y);
    image(background[1], x2, y);
  }
}

class Blob
{
  int time;
  int[] obstacle;
  int y;
  int now;
  boolean[] mark;                       
  int r;                               
  PImage disorder;                      
  Blob(int r, int y) {
    this.y = y;
    this.r = r;
    obstacle = new int[20];
    mark = new boolean[20];
    now = 0;
    mark[now]=true;
    for (int i = 0; i < 20; i++) {
      obstacle[i] = 1300;
    }
    disorder=loadImage("obstacle.png");
    stroke(0);

    strokeWeight(5);
    line(0, y, 900, y);
    fill(0);
    obstacle[now]=1000;
  }
  void change() {
    if (millis()%128 == 0) {
      if (abs(obstacle[now]-obstacle[(now+19)%20])>=350) {

        mark[now]=true;
        now=++now%20;
      }
    }
  }

  void run() {
    for (int i = 0; i < 20; i++) {
      if (mark[i]) {
        obstacle[i] = obstacle[i]-4;
      }
    }
  }

  void display() {
    stroke(0);
    strokeWeight(5);
    fill(0);

    for (int i = 0; i < 20; i++) {
      if (obstacle[i]<-r) {
        mark[i]=false;
      }
    }
    for (int i = 0; i < 20; i++) {

      if (mark[i]) {
        fill(0);
        // arc(obstacle[i],y,r,r,PI,2*PI);
        image(disorder, obstacle[i], y-46+40);
      }
    }
  }
}
