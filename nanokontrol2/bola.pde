
class Bola {

  PVector pos;
  PVector vel;
  PVector col;
  int r = 10;
  
  Bola(){
    col = new PVector(125,125,125);
      reiniciar();
  }
  
  void reiniciar(){
    
    pos = new PVector(width/2,height/2);
    vel = new PVector( random(-2,2),random(-1,1)) ;
    vel.setMag(2);
  }
  
  void update() {
    pos.add(vel);
    if( pos.y-r  <= 0) vel.y *= -1;
    if( pos.y+r  >= height) vel.y *= -1;
    

    if((pos.y > player1.posicion.y) && (pos.y < player1.posicion.y + player1.alto)){
      if(pos.x-r < player1.posicion.x + player1.ancho  ){
        vel.x *=-1;
        vel.add(new PVector(random(-1,1),random(-1,1) ));
        vel.mult(1.4);
        return;
      }
    }
   
    if((pos.y > player2.posicion.y) && (pos.y < player2.posicion.y + player2.alto)){
      if(pos.x+r > player2.posicion.x ){
        //float ang = ((player2.posicion.y - pos.y)/ player2.alto)-0.5;
      //  PVector a = PVector.fromAngle(ang);
        
        vel.x *=-1;
        vel.add(new PVector(random(-1,1),random(-1,1) ));
        vel.mult(1.4);
        return;
    //    float mag = vel.mag(); 
  //      vel =  a;
//        vel.setMag(mag);
      }
    }
    
        
    if(pos.x < 0) {
      score2 ++;
      reiniciar();
    }
    
    if(pos.x > width) {
      score1 ++;
      reiniciar();      
    }
    
    

  }
  
  void draw(){
    fill(col.x*2,col.y*2,col.z*2);
    ellipse(pos.x, pos.y, r, r);
  }
}
