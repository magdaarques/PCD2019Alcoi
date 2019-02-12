class Player{
  
  PVector posicion;
  PVector velocidad;
  int id;
  
  float ancho = 5, alto=75;
  
  Player (int _id)
  {
    id = _id;
    if(id == 1){
      posicion = new PVector(10, height/2);
    }else{
      posicion = new PVector(width-10-ancho, height/2);
    }
    
  }
  
  void mover(float y){
    posicion.y = map(y, 0, 127,0,height-alto );
  }  
  
  void draw(){
    rect(posicion.x,posicion.y,ancho,alto  );
  }
}
