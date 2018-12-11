PImage im;

float delta=1.0; // speed fo rotation
float DEGREE_MAX=45;
float axis_x, axis_y;

int count=0;

int input_N = 30;
int neuron_N = 20;
int output_N = 2;
  
Gene gene;
Environment env;

void setup(){
  frameRate(60);
  size(800,450);
  // init image
  
  imageMode(CENTER); // centerize the location of image
  im = loadImage("face.png");
  im.resize(0,200); // image size
  
  gene = new Gene();
  env = new Environment(gene);
}

void draw(){
  background(255,255,255); // white backgroud
  pushMatrix();
  env.show();
  popMatrix();
  pushMatrix();
  rotation(env.getX());
  popMatrix();
}


//画像の回転
void rotation(float degree){
  translate(width/4, height/2);
  // 軸の位置
  axis_x = 0; 
  axis_y = im.height/2;
  translate(axis_x, axis_y);
  rotate(radians(degree));
  translate(-axis_x, -axis_y);
  image(im, 0, 0);
}

// Is argument(f) greater than zero ?
float signum(float f) {
  if (f >= 0) {
    return 1.0;
  } else {
    return -1.0;
  }
}
