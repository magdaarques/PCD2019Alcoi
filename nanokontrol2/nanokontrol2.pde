import themidibus.*;

MidiBus myBus;
Bola bola;
Player player1, player2;
 int score1,score2;
 
void setup() {
  MidiBus.list();
  myBus = new MidiBus(this, 0, 1);
  size(800,400);
  
  score1 = 0;
  score2 = 0;
  bola = new Bola();
  player1 = new Player(1);
  player2 = new Player(2);
  

}



void draw() {
  background(0);
  fill(255);
  player1.draw();
  player2.draw();
  bola.update();
  bola.draw();
  
  fill(200);
text( score1 , 50, 50); 

//fill(0, 102, 153, 51);
text( score2, width-50, 50); 
}
 
void controllerChange(int channel, int number, int value) {
  println(channel);
  println(number);
  println(value);
  println("-----");
  switch(number){
    case 23:
//      player2.mover(value);
        bola.r = value;
      break;
     case 7:
       player2.mover(127-value);
       break;
    case 16:
      bola.col.x = value;
      break;
    case 17:
      bola.col.y = value;
      break;
    case 18:
      bola.col.z = value;
      break;      
     case 0:
       player1.mover(127-value);
       break;     
  }

 
}
