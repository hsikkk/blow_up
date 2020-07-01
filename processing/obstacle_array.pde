import java.util.ArrayList;
import java.util.Iterator;

class obstacles { // array of obstacle
  ArrayList<needle> array;
  Iterator<needle> iter;
  
  obstacles(){
    array = new ArrayList<needle>();
  }
  
  void add(needle obs) {
    array.add(obs);
  }
  
  void remove() {
    iter = array.iterator();
    while(iter.hasNext()) {
      needle obs = iter.next();
      if(obs.xpos < 0) {
        iter.remove();
      }
    }
  }
  
  void move() {
    iter = array.iterator();
    while(iter.hasNext()) {
      needle obs = iter.next();
      obs.xpos -= obs.xspeed;
    }
  }
  
  void detect(balloon ball) {
    iter = array.iterator();
    while(iter.hasNext()) {
      needle obs = iter.next();
      float xdiff = ball.xpos - obs.xpos;
      float ydiff = ball.ypos - obs.ypos;
      if((xdiff < obstacle_width) && (xdiff > (-1)*balloon_width)) {
        if((ydiff < obstacle_height) && (ydiff > (-1)*balloon_height)) {
          ball.alive = false;
        }
      }
    }
  }
  
  void display() {
    iter = array.iterator();
    while(iter.hasNext()) {
      needle obs = iter.next();
      obs.display();
    }
  }
}