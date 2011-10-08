import processing.serial.*;
import cc.arduino.*;

import eeml.*;

Arduino arduino;
float lastUpdate;

DataOut dOut;

void setup()
{
size(500, 500);
  
  
  println(Arduino.list());
arduino = new Arduino(this, Arduino.list()[0], 57600);

dOut = new DataOut(this, "http://www.pachube.com/api/35136.xml", "OfWHirEnR3GNFpiATo0O9TDuv5pLcSLBDHO3Y5fOlaE");

dOut.addData(0,"Light Sensor, Photoresistor, Light Level");
dOut.addData(1, "Timer");

}

void draw()
{
    float myValue = arduino.analogRead(0); 
    println("reference: " + myValue);
    float value = arduino.analogRead(1); 
    println("value: " + value);
    float openState = arduino.analogRead(2); 
    println("open: " + openState);
  if ((millis() - lastUpdate) > 15000){
    myValue = arduino.analogRead(0);
    println(myValue);
        println("ready to PUT: ");
        dOut.update(0, myValue); 
        dOut.update(1, millis()); 
        int response = dOut.updatePachube(); 
        println(response); 
        lastUpdate = millis();
  }  
  background(255, 255, 255);
  float relativeValue = value - myValue;
  relativeValue = map(relativeValue, -100, 100, 50, 150);
  relativeValue = constrain(relativeValue, 50, 150); 
 
  color c1 = color(255, 248, 58); 
  color c2 = color(0, 44, 255);
  color c3 = color(0, 167, 255);
  noStroke();
  fill(c1);
  ellipse(250,250, relativeValue, relativeValue);
  fill(c2);
  ellipse(250, 250 + (relativeValue *= 0.5) - 10, 20, 20);
  
}

