import java.util.Random;
import java.security.SecureRandom;

class Gene{
  
  Neuron[] neurons; // ニューロンモデル
  
  
  // 初期化
  Gene() {
    
    neurons = new Neuron[neuron_N];
    for(int i=0;i<neuron_N;i++){
      neurons[i] = new Neuron(input_N,output_N);
      neurons[i].test_init(i);
    }
    
  }
  
  // 入力を受け取ったら個々のニューロンに渡す
  // 2つの出力の差分を結果として返す
  int cal(int[] inputs){
    int output=0;
    for(int i=0;i<neuron_N;i++){
      int[] temp_outputs = neurons[i].cal(inputs);
      output +=  temp_outputs[1] - temp_outputs[0]; // 時計回り(右向き)がプラス
    }
    return output;
  }
  
  boolean[] getActiveNode(){
    boolean[] activeNode = new boolean[neuron_N];
    for(int i=0;i<neuron_N;i++){
      activeNode[i] = neurons[i].active;
    }
    return activeNode;
  }
  
  //boolean[][] getActiveInputEdge(){
  //  boolean[][] activeEdge = new boolean[input_N][neuron_N];
  //  for(int i=0;i<input_N;i++){
  //    for(int j=0;j<neuron_N;j++){
  //      if(neurons[j].active){
  //        activeEdge[i][j] = neurons[j].LINK_FROM.contains(j);
  //      } else {
  //        activeEdge[i][j] = false;
  //      }
  //    }
  //  }
  //  return activeEdge;
  //}
  boolean[][] getActiveOutputEdge(){
    boolean[][] activeEdge = new boolean[neuron_N][output_N];
    for(int i=0;i<neuron_N;i++){
      for(int j=0;j<output_N;j++){
        if(neurons[i].active){
          activeEdge[i][j] = neurons[i].LINK_TO.contains(j);
        } else {
          activeEdge[i][j] = false;
        }
      }
    }
    return activeEdge;
  }
  
}

// Geneクラスの中の個々のニューロンモデル
class Neuron{
  
  float THRESHOLD_VALUE; // ニューロンが発火する閾値
  ArrayList<Integer> LINK_FROM; // 入力元のインデックス
  ArrayList<Integer> LINK_TO; // 出力先のインデックス
  
  float INIT_FROM_RATE = 0.5; // 初期化時に入力元に接続する確率
  float INIT_TO_RATE = 0.5; // 初期化時に出力先に接続する確率
  
  boolean active;
  
  Neuron(int input_N,int output_N){
    
    Random r = new SecureRandom(); // 乱数用
    
    THRESHOLD_VALUE = r.nextFloat(); // 閾値の初期化
    
    // 入力元の決定
    LINK_FROM = new ArrayList<Integer>();
    for(int i=0;i<input_N;i++){
      if(r.nextDouble()<INIT_FROM_RATE){
        LINK_FROM.add(i);
      }
    }
    // 出力先の決定
    LINK_TO = new ArrayList<Integer>();
    for(int i=0;i<output_N;i++){
      if(r.nextDouble()<INIT_TO_RATE){
        LINK_TO.add(i);
      }
    }
    
  }
  
  // テスト用に初期化を調整
  void test_init(int neuron_index){
    
    int input_N = 30;
    int output_N = 2;
    
    // 前半分の番号なら、前半の入力を受け後半の出力に渡す。逆も然り。
    
    LINK_FROM = new ArrayList<Integer>();
    for(int i=0;i<input_N;i++){
      if(neuron_index<20/2 && i<input_N/2){
        LINK_FROM.add(i);
      }
      if(neuron_index>=20/2 && i>=input_N/2){
        LINK_FROM.add(i);
      }
    }
    LINK_TO = new ArrayList<Integer>();
    for(int i=0;i<output_N;i++){
      if(neuron_index<20/2 && i==1){
        LINK_TO.add(i);
      }
      if(neuron_index>=20/2 && i==0){
        LINK_TO.add(i);
      }
    }
    //System.out.println(LINK_FROM);
    //System.out.println(LINK_TO);
  }
  
  // 入力に対する出力の計算
  int[] cal(int[] inputs){
    active = false;
    // 入力元のみから刺激を受け取る
    int potential = 0;
    for(int i=0;i<LINK_FROM.size();i++){
      int index = LINK_FROM.get(i);
      potential += inputs[index];
    }
    // 刺激が閾値を超えれば、出力先のみに刺激を送る
    int[] outputs = {0,0};
    if(potential>THRESHOLD_VALUE){
      active = true;
      for(int i=0;i<LINK_TO.size();i++){
        int index = LINK_TO.get(i);
        outputs[index] += 1;
      }
    }
    
    return outputs;
  }
  
}
