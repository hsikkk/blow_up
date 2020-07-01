import fisica.*;
import processing.serial.*;
import java.util.Random;

PImage Start_1, Start_2, Play, balloon, balloon2, obstacle, 
  Start_select, Arrow, Record, Menu, End_1p, p1_win, p2_win;

enum GameMode {
  Main, Main_select, Play_1p, Play_2p, Record, 
    End_1p, End_2p, Menu;
}

String myString = null;
Serial myPort;
int lf = 10; // Linefeed in ASCII
int[] data = {0, 0, 0}; 
int [] values = new int[2];
int start_state =0; // for blinking display
int start_option = 1; // 1: 1p, 2: 2p, 3: record
int menu_option = 1; // 1: resume, 2: restart, 3: main
int end_option = 1; // 1: restart, 2: main

int winner = 0; // 1 for 1p, 2 for 2p


balloon p1_b;
balloon p2_b;
GameMode mode, prev_mode;
obstacles obs_list;
PFont font;

int score1, score2;
int balloon_width;
int balloon_height;
int obstacle_width;
int obstacle_height;

Random random;


void setup() {
  size(600, 400);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();

  mode = GameMode.Main;
  p1_b = new balloon(1);
  p2_b = new balloon(2);
  obs_list = new obstacles();
  Start_1 = loadImage("start.png");
  Start_2 = loadImage("start2.png");
  Start_select = loadImage("start_select.png");
  Play = loadImage("play.png");
  Arrow = loadImage("arrow.png");
  Record = loadImage("record.png");
  Menu = loadImage("menu.png");
  End_1p = loadImage("1p_game_over.png");
  p1_win = loadImage("p1_win.png");
  p2_win = loadImage("p2_win.png");
  balloon = loadImage("balloon.png");
  balloon2 = loadImage("balloon2.png");
  obstacle = loadImage("dart.png");
  balloon_width = 30;
  balloon_height = 30;
  obstacle_width = 30;
  obstacle_height = 15;
  random = new Random();
  font = createFont("Bradley Hand ITC", 12, true);
}

void draw() {

  if (mode == GameMode.Main) {
    if (start_state == 0) {

      image(Start_1, 0, 0, width, height);
      delay(1200);
      start_state =1;
    } else {
      image(Start_2, 0, 0, width, height);
      delay(300);
      start_state =0;
    }
  } else if (mode == GameMode.Main_select) {
    image(Start_select, 0, 0, width, height);
    image(Arrow, 230, 155+ 42*start_option);
  } else if (mode == GameMode.Play_1p) {
    image(Play, 0, 0, width, height);
    score1++;
    textFont(font, 30);
    textAlign(LEFT);
    fill(255, 255, 255);
    text("P1 score : "+ score1/10, 20, 30);

    obs_list.remove();
    if ((random.nextInt(100))%50 == 0) {
      obs_list.add(new needle(600, random.nextInt(379)+11, 
        (random.nextInt(3)+5.0)/5));
    }
    obs_list.move();

    //check for end
    obs_list.detect(p1_b);
    if (p1_b.alive == false) {
      p1_b = new balloon(1);
      obs_list = new obstacles();
      mode = GameMode.End_1p;
      if (score1 > data[0]) {
        data[2] = data[1];
        data[1] = data[0];
        data[0] = score1;
      } else if (score1 > data[1]) {
        data[2] = data[1];
        data[1] = score1;
      } else if (score1 > data[2]) {
        data[2] = score1;
      }
    }

    obs_list.display();

    p1_b.display();

    delay(20);
  } else if (mode == GameMode.Play_2p) {
    image(Play, 0, 0, width, height);
    textFont(font, 30);
    textAlign(LEFT);
    fill(255, 255, 255);
    if (p1_b.alive) score1++;
    if (p2_b.alive) score2++;

    text("P1 score : "+ score1/10, 20, 30);
    text("P2 score : "+ score2/10, 420, 30);

    obs_list.remove();
    if ((random.nextInt(100))%50 == 0) {
      obs_list.add(new needle(600, random.nextInt(379)+11, 
        (random.nextInt(3)+5.0)/5));
    }
    obs_list.move();

    //check for end
    obs_list.detect(p1_b);
    if (p1_b.alive == false) {
      if (p2_b.alive == false) {
        p1_b = new balloon(1);
        p2_b = new balloon(2);
        obs_list = new obstacles();
        mode = GameMode.End_2p;
        if (score2 > data[0]) {
          data[2] = data[1];
          data[1] = data[0];
          data[0] = score2;
        } else if (score2 > data[1]) {
          data[2] = data[1];
          data[1] = score2;
        } else if (score2 > data[2]) {
          data[2] = score2;
        }
      } else winner = 2;
    }
    obs_list.detect(p2_b);
    if (p2_b.alive == false) {
      if (p1_b.alive == false) {
        p1_b = new balloon(1);
        p2_b = new balloon(2);
        obs_list = new obstacles();
        mode = GameMode.End_2p;
        if (score1 > data[0]) {
          data[2] = data[1];
          data[1] = data[0];
          data[0] = score1;
        } else if (score1 > data[1]) {
          data[2] = data[1];
          data[1] = score1;
        } else if (score1 > data[2]) {
          data[2] = score1;
        }
      } else winner = 1;
    }

    obs_list.display();

    if (p1_b.alive) p1_b.display();
    if (p2_b.alive) p2_b.display();

    delay(20);
  } else if (mode == GameMode.Record) {
    image(Record, 0, 0, width, height);
    textFont(font, 45);
    textAlign(LEFT);
    fill(255, 255, 255);
    for (int i =0; i<3; i++)
      text(data[i], 210, 180+45*i);
  } else if (mode == GameMode.End_1p) {

    image(End_1p, 0, 0, width, height);
    image(Arrow, 195, 160+42*end_option);
    textFont(font, 30);
    textAlign(LEFT);
    fill(255, 255, 255);
    text("P1 score : "+ score1/10, 20, 30);
  } else if (mode == GameMode.End_2p) {
    if (winner == 1) {
      image(p1_win, 0, 0, width, height);
    } else if (winner ==2) {
      image(p2_win, 0, 0, width, height);
    }
    textFont(font, 30);
    textAlign(LEFT);
    fill(255, 255, 255);
    text("P1 score : "+ score1/10, 20, 30);
    text("P2 score : "+ score2/10, 420, 30);
    image(Arrow, 195, 160+42*end_option);
  } else if (mode == GameMode.Menu) {
    image(Menu, 0, 0, width, height);
    image(Arrow, 190, 120+ 45*menu_option);
  }
}

void keyPressed() {
  if (mode == GameMode.Main) {
    mode = GameMode.Main_select;
  } else if (mode == GameMode.Main_select) {
    if (keyCode == UP) {
      if (start_option == 1) 
        start_option = 3;
      else
        start_option --;
    } else if (keyCode == DOWN) {
      if (start_option == 3) 
        start_option = 1;
      else
        start_option ++;
    } else if (keyCode == ENTER) {

      switch(start_option) {
      case 1:
        mode = GameMode.Play_1p;
        break;
      case 2: 
        mode = GameMode.Play_2p;
        break;
      case 3:
        mode = GameMode.Record;
        break;
      }
    }
  } else if (mode == GameMode.Record) {
    if (keyCode == LEFT || keyCode == BACKSPACE) {
      mode = GameMode.Main_select;
    }
  } else if (mode == GameMode.Play_1p || mode == GameMode.Play_2p) {
    if (key == 'p') {
      prev_mode = mode;
      mode = GameMode.Menu;
    }
  } else if (mode == GameMode.Menu) {
    if (keyCode == LEFT || keyCode == BACKSPACE)
      mode = prev_mode;
    else if (keyCode == UP) {
      if (menu_option == 1) 
        menu_option = 3;
      else
        menu_option --;
    } else if (keyCode == DOWN) {
      if (menu_option == 3) 
        menu_option = 1;
      else
        menu_option ++;
    } else if (keyCode == ENTER) {

      switch(menu_option) {
      case 1:
        mode = prev_mode;
        break;
      case 2: 
        mode = prev_mode;
        p1_b = new balloon(1);
        obs_list = new obstacles();
        score1 =0;
        score2=0;
        break;
      case 3:
        mode = GameMode.Main_select;
        break;
      }
    }
  } else if (mode == GameMode.End_2p || mode == GameMode.End_1p) {
    if (keyCode == UP) {
      if (end_option == 1) 
        end_option = 2;
      else
        end_option --;
    } else if (keyCode == DOWN) {
      if (end_option == 2) 
        end_option = 1;
      else
        end_option ++;
    } else if (keyCode == ENTER) {

      switch(end_option) {
      case 1:
        score1 =0;
        score2 =0;
        if (mode == GameMode.End_1p)
          mode = GameMode.Play_1p;
        else
          mode = GameMode.Play_2p;
        break;
      case 2: 
        mode = GameMode.Main;
        break;
      }
    }
  }
}

void serialEvent(Serial p) {
  while (myPort.available()>0) {
    myString = p.readStringUntil(lf);
    if (myString != null) {
      int _values[] = int(split(myString, '\t'));
      values[1] = _values[1];
      values[2] = _values[2];
      p1_b.move(values[1]);
      p2_b.move(values[2]);
      println((values[1]/100 -5)/100.0);
      println((values[2]/100 -5)/100.0);
      // maping accel value
    }
  }
}