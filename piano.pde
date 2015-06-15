import ddf.minim.*;

Pusher[] pushers;
int bgColor;
Minim minim;
Drawer drawer;


void setup() { 
  JSONObject json = loadJSONObject("settings.json");

  int psize = json.getInt("pushers_size");
  int msize = json.getInt("pushers_maxsize");
  int bsize = json.getInt("pushers_bordersize");

  JSONArray _size = json.getJSONArray("size");
  size(_size.getInt(0), _size.getInt(1));
  
  JSONArray _bgcolor = json.getJSONArray("background");
  bgColor = color(_bgcolor.getInt(0), _bgcolor.getInt(1), _bgcolor.getInt(2));
  
  minim = new Minim(this);
  drawer = new Drawer(bgColor);
  frameRate(25);
  
  JSONArray _pushers = json.getJSONArray("pushers");
  pushers = new Pusher[_pushers.size()];
  for (int i=0; i<pushers.length; i++) {
    JSONObject _pusher = _pushers.getJSONObject(i);
    JSONArray _color = _pusher.getJSONArray("color");
    JSONArray _position = _pusher.getJSONArray("position");
    char activator = _pusher.getString("activator").charAt(0);
    String sound = _pusher.getString("sound");
    
    Pusher pusher = new Pusher(color(_color.getInt(0), _color.getInt(1), _color.getInt(2)), sound);
    pusher.positionX = _position.getInt(0);
    pusher.positionY = _position.getInt(1);
    pusher.setSize(psize);
    pusher.maxExternSize = msize;
    pusher.strokeWidth = bsize;
    pusher.activator = activator;  
    pushers[i] = pusher;
  }
  //rectMode(CENTER);
}

void draw() {
  background(bgColor);
  
  drawer.draw();
  for (int i=0; i<pushers.length; i++) {
    pushers[i].increase();
    pushers[i].draw();
  }
}

void keyPressed() {
  for (int i=0; i<pushers.length; i++) {
    if (pushers[i].activator == key) {
      pushers[i].activate();
      drawer.new_dest(pushers[i].positionX, pushers[i].positionY);
      break;
    }
  }
}

void stop() {
  minim.stop();
  super.stop();
}