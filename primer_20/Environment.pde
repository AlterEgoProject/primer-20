class Environment{
  
  Gene gene;
  Physical model;
  int[] inputs;
  
  float[] input_position;
  float[] neuron_position;
  float[] output_position;
  
  
  Environment(Gene gene){
    
    this.gene = gene;
    model = new Physical();
    
    getPosition();
  }
  
  void getPosition(){
  input_position = new float[input_N];
  for(int i=0;i<input_N;i++){ input_position[i] = map(i,-1,input_N,-100,100);}
  neuron_position = new float[neuron_N];
  for(int i=0;i<neuron_N;i++){ neuron_position[i] = map(i,-1, neuron_N,-100,100);}
  output_position = new float[output_N];
  for(int i=0;i<output_N;i++){ output_position[i] = map(i,-1,output_N,-100,100);}
  }
  
  void show(){
    // 物理モデルがある相対位置を 1 で与える
    inputs = new int[input_N];
    //System.out.println(getX());
    inputs[(int)(( (getX()+45)/90) * (input_N-1) )] = 1;
    
    float output = gene.cal(inputs);
    
    model.move(output);
    
    drawResult(output);
    drawNeuronModel();
  }
  
  float getResult(){
    System.out.println(model.point+" "+model.damage);
    return 0;
  }
  
  
  // 出力を表示
  void drawResult(float output){
    fill(0);
    text("ちーたんの角度："+(int)model.x+" 度",width*3./4-80,40);
    text("壁に交互に当たった回数："+model.point+" 回",width*3./4-80,60);

    stroke(#DDF7CC);
    fill(#DDF7CC);
    int[] gage_base = {40,80};
    int gage_w = 20;
    line(width/4, gage_base[0], width/4, gage_base[1]);
    rect(width/4,(gage_base[0]+gage_base[1])/2-gage_w/2,output*10,gage_w);
  }
  
  void drawNeuronModel(){
    translate(width*3./4,0);
    drawInput();
    drawNeuron();
    drawOutput();
  }
  void drawInput(){
    boolean[] activeInput = new boolean[input_N];
    for(int i=0;i<input_N;i++){
      activeInput[i] = (inputs[i]>0);
    }
    drawEllipse(activeInput,input_position,height-100);
    boolean[][] activeInputEdge = new boolean[input_N][neuron_N];
    for(int i=0;i<input_N;i++){
      for(int j=0;j<neuron_N;j++){
        if(activeInput[i]){
          activeInputEdge[i][j] = gene.neurons[j].LINK_FROM.contains(i);
        }
      }
    }
    drawEdge(activeInputEdge,input_position,neuron_position,height-100,height-200);

  }
  void drawNeuron(){
    boolean[] activeNode = gene.getActiveNode();
    drawEllipse(activeNode,neuron_position,height-200);
    drawEdge(gene.getActiveOutputEdge(),neuron_position,output_position,height-200,height-300);
  }
  void drawOutput(){
    boolean[] activeOutput = new boolean[output_N];
    drawEllipse(activeOutput,output_position,height-300);
  }
  void drawEllipse(boolean[] isActive,float[] position,float h){
    
    stroke(0);
    for(int i=0;i<position.length;i++){ 
      if(isActive[i]){
        fill(#FF0000);
      } else {
        fill(255);
      }
      ellipse(position[i],h,10,10); 
    }
  }
  void drawEdge(boolean[][] activeEdge,float[] position1,float[] position2,float h1,float h2){
    for(int i=0;i<position1.length;i++)for(int j=0;j<position2.length;j++){
      if(activeEdge[i][j]){
        stroke(#FF0000,100);
      } else {
        stroke(0,10);
      }
      line(position1[i],h1,position2[j],h2);
    }
  }
  float getX() { return model.x;}
}

// 物理モデル
class Physical{
  float m = 0.1; // 質量
  float x; // 位置
  float v; // 速度
  float DELTA; // moveが呼ばれる時間間隔
  float MAX_X = 45; // xの上限値
  
  boolean flag_right=true;
  float point=0; // 壁に接した回数
  float damage=0; // 衝突ダメージ;
  
  Physical(float frame_rate, float x_init, float v_init){
    DELTA = 1./frame_rate;
    x = x_init;
    v = v_init;
  }
  Physical() {
    this(60,45,0);
  }
  
  void move(float external){
    v += external/m * DELTA;
    x += v * DELTA;
    // 接触があったか
    if(abs(x)>=MAX_X){
      if( (x<0) == flag_right ) { point++; } // 交互に壁に接触した場合のみ得点
      flag_right = (x>0);
      damage += energy(); // 衝突ダメージを加算
      x = MAX_X * x/abs(x); // xの上限に戻す
      v = 0;
    }
  }
  // 力学的エネルギー
  float energy(){
    return m * pow(v,2) / 2;// 1/2*mv^2
  }
}
