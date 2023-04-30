// NOTIFICATION OBJECT ------------------------------------------------------------------------------------------------------------
class Notification {
  
  public PImage notification;
  private float xpos;
  private float ypos;
  private float wid;
  private float len;
  private SoundFile soundEffect;
  private int sensorValue; // this is the sensor index for Arduino!
 
// Constructor ----------------------------------------------------------------------------------- 

  Notification(float xp, float yp, float w, float l, PImage image, SoundFile effect, int sensor) { // Takes the same 4 arguments as an image would
    xpos = xp;                                                 // Sets arguments as class parameters
    ypos = yp;
    wid = w;
    len = l;
    notification = image;     // Load image
    soundEffect = effect; //load Sound Effect   
    sensorValue = sensor;
  }
  
// GETTERS ---------------------------------------------------------------------------------------  
  
  float getXPos() {
    return xpos;
  }
  
  float getYPos() {
    return ypos;
  }
  
  float getWidth() {
    return wid;
  }
  
  float getLength() {
    return len;
  }
  
  float getSensorValue() {
    return sensorValue;
  }
  
// SETTERS

  void setXPos(float xCoord) {
    xpos = xCoord;
  }
  
  void setYPos(float yCoord) {
    ypos = yCoord;
  }

// DRAW NOTIFICATION FUNCTION ----------------------------------------------------------------------
  void drawNotification() {                           
    image(notification, xpos, ypos, wid, len);    // Draw 'notification' at (xpos, ypos) with dimensions (wid/len)
  }
    
  boolean checkIfClicked() 
  {
    // check mouse is in range of the notification
    return (mouseX >= xpos) && (mouseX <= xpos + wid) && (mouseY >= ypos) && (mouseY <= ypos + len);
  }

  //play notification sound 
  void playNotification(int firstTime){
    if ((soundEffect.isPlaying() == false) && (firstTime == 1)){
      soundEffect.play();
    }
  }
}



  
  
