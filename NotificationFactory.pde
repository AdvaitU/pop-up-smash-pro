class NotificationFactory {
  
  NotificationFactory() {}    // Empty Constructor
  
  //needs to be changed to take in string with name of image and soundfile 
  Notification createNotification(PImage image, SoundFile soundEffect, float xpos, float ypos, int sensorValue) { 
    
    //float rand1 = random(1);              // Randomise (x,y) to create notification at
    //float rand2 = random(1); 
    //float wid = constrain(rand1 * 80., 90., 100.);
    //float len = constrain(rand2 * 70., 60., 70.);
    float wid = image.width * 0.5;
    float len = image.height * 0.5;
    Notification notification = new Notification(xpos, ypos, wid, len, image, soundEffect, sensorValue);
    
    return notification;
  }
  
}
