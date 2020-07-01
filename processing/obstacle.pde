class needle {

  float xpos;
  float ypos;
  float xspeed;

  needle(float tempXpos, float tempYpos, float tempXspeed) { // The Constructor is defined with arguments.
    xpos = tempXpos;
    ypos = tempYpos;
    xspeed = tempXspeed;
  }

  void display() {
    //rect(xpos, ypos, 40, 20);
    image(obstacle, xpos, ypos, obstacle_width, obstacle_height);
  }
}