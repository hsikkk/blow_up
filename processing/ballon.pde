class balloon {

  float xpos = 20;
  float ypos;
  float yspeed;
  boolean alive;
  int index;

  balloon (int num) {
    index = num;
    yspeed =0;
    if (num == 1) {
      ypos = 100;
    } else {
      ypos = 130;
    }
    alive = true;
  }

  void move(float value) {
    yspeed = yspeed+value;
  }

  void display() {
    yspeed = yspeed+0.05; // for gravity
    ypos = ypos + yspeed;
    if(ypos <0) {ypos = 0; yspeed = 0;}
    if(ypos >400) alive = false;
    if(index ==1)
    image(balloon, xpos, ypos, balloon_width, balloon_height);
    else
    image(balloon2, xpos, ypos, balloon_width, balloon_height);
  }
}