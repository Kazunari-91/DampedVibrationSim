import controlP5.*;
ControlP5 cp5;
Slider sliderOmega;
Slider sliderGanma;
Slider sliderStep;
Range range;
/*
************************************************
 */
float x0 = 0;
float v0 = 0;
float ganma = 0.5;
float omega = 1.0;

float func(float t) {

  float f = exp(-ganma * t) * (x0 * cos(omega * t) + (v0 - x0*ganma)*sin(omega*t));

  return f;
}
/*
************************************************
 */
boolean block = false;
float count = 0;
float step = 0.05;
float add = 0;
float Len = 200;

float limRx = -Len;
float limLx = Len;

float orbRx = limRx;
float orbLx = limLx;

float calcx= 0;

float preBoll = x0;

float center = 0;

float calcxPre = 0;
float vel = 0;
float velPre = 0;

void setup() {
  size(1000, 600);

  cp5 = new ControlP5(this);

  sliderOmega = cp5.addSlider("O M E G A")
    .setPosition(30, 30)
    .setSize(200, 20)
    .setRange(0.1, 1.5)
    .setValue(1.0)
    ;
  sliderGanma = cp5.addSlider("G A N M A")
    .setPosition(30, 70)
    .setSize(200, 20)
    .setRange(0.1, 1.5)
    .setValue(0.5)
    ;

  sliderStep = cp5.addSlider("S T E P")
    .setPosition(30, 110)
    .setSize(200, 20)
    .setRange(0.001, 0.2)
    .setValue(0.05)
    ;
    
  range = cp5.addRange("MOVE")
             // disable broadcasting since setRange and setRangeValues will trigger an event
             .setBroadcast(false) 
             .setPosition(300,50)
             .setSize(400,40)
             .setHandleSize(0)
             .setRange(-220,220)
             .setRangeValues(-20,20)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(150,40))  
             ;
}

void draw() {
  
  omega = sliderOmega.getValue();
  ganma = sliderGanma.getValue();
  step = sliderStep.getValue();
  
  pushMatrix();
  translate(500, 300);
  background(0);
  //範囲の描画
  fill(50, 50, 50);
  rect(-200, -300, 400, 600);
  strokeWeight(50);
  strokeCap(SQUARE);
  stroke(255);
  strokeWeight(1);

  //移動
  orbRx = limRx + add;
  orbLx = limLx + add;
  
  //移動の制限
  if (orbRx > 0) {
    orbRx= 0;
    orbLx =  orbRx + 400;
  }
  if (orbLx < 0) {
    orbLx = 0;
    orbRx =  orbLx - 400;
  }
  center = (orbRx + orbLx)/2;

  strokeWeight(3);
  stroke(255, 0, 0);
  line(orbRx, 0, orbLx, 0);

  //移動した範囲での振幅範囲
  stroke(0, 0, 255);

  vel = (calcx - calcxPre)/step;
  calcxPre = calcx;

  calcx = func(count);

   //端での挙動
  if (calcx < orbRx) {
    if (orbRx == 0) {
     // calcx = -calcx;
     x0 =  -x0*0.5;
     v0  = -v0*0.1;
    } else {
      v0 = -vel;
      x0 = orbRx;
      count = 0;
    }
  } else if (calcx > orbLx) {
    if (orbLx == 0) {
     // calcx = -calcx;
      x0 = -x0*0.5;
     v0  = -v0*0.1;
    } else {
      v0 = -vel;
      x0 = orbLx;
      count = 0;
    }
  }
  

  count+=step;

  //println(orbRx + " , "+ orbLx + " , "+ (orbRx+orbLx)/2 + " , "+ calcx + " , " + add + " , "+ x0 + " , "+ preBoll);
  //stroke(0, 255, 0);
  //line(preBoll, -60, preBoll, 60);
  
  //描画
  stroke(100, 100, 100);
  fill(50, 50, 50);
  ellipse(preBoll, 0, 20, 20);
  stroke(0, 255, 0);
  fill(0, 255, 255);
  ellipse(calcx, 0, 20, 20);

  stroke(150, 150, 150);
  strokeWeight(10);
  line(-200, 200, 200, 200);
  float transX = map(calcx, orbRx, orbLx, -200, 200);
  fill(200, 255, 0);
  ellipse(transX, 200, 20, 20);
  noStroke();
  delay(10);
  strokeWeight(3);
  stroke(200, 200, 0);
  line(0, -30, 0, -10);
  line(0, 30, 0, 10);
  noStroke();
  //println(add);
  
  //目隠し
  if(block){
    fill(0);
    rect(-500, -50, 1000, 100);
  }
  popMatrix();
  
  //delay(10);
}

void mouseReleased(){
  float rangeHigh = range.getHighValue();
  float rangeLow  = range.getLowValue();
  add = (rangeHigh + rangeLow)/2;
  float diff = center - calcx;
 x0 = calcx;
 v0 = vel;
 count = 0;
 preBoll = calcx + add - diff;
 x0 = preBoll;
 
 println(add +" , "+ calcx +" , "+ center +" , "+ diff +" , "+ vel +" , "+ preBoll);
}

void keyPressed(){
  block = !block;
}
