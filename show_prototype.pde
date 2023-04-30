import processing.sound.*;
import processing.serial.*;
import java.util.Map;
import java.util.Arrays;

/*
* Main game code
*/

// Serial variables 
final int baudRate = 57600;
Serial inPort;  // the serial port
String inString; // input string from serial port
String[] splitString; // input string array after splitting
int[] status, lastStatus;
int device_number = 0;

// Game variables 
int firstTime = 1;
color backgroundColor = color(188, 220, 255);        // Background colour

int maxNotifications = 12; // max number on screen
int notificationCounter = 0;

float seconds = 0;
float startingRate = 70;
float minRate = 50.;
float maxRate = 100.;
float rateMultiplier = 5;
float rate;
float timer;
String timerText;
SoundFile startupSound;

NotificationFactory notificationFactory;

// Locations of buttons
HashMap<Integer, FloatList> allLocations; 
IntList availableLocations;
IntList clickedLocations;

// Map of active locations in game 
HashMap<Integer, Notification> notifications;

// Map of images to sounds
ArrayList<String> notifNames; 
   
// Only one image and SoundFile atm, needs to be updated    
PImage backgroundImage;

int drawn = 0;

void setup() {
  
  SoundFile startupSound = new SoundFile(this, "data/NotificationSounds/Windows95Startup.aiff");
  startupSound.play();
  
  size(1024, 768); // 4:3 configuration   
  backgroundImage = loadImage("data/Desktop Background-01.png");

  noStroke();

  allLocations = new HashMap<Integer, FloatList>();
  availableLocations = new IntList();
  clickedLocations = new IntList();
  notifications = new HashMap<Integer, Notification>();
  notifNames = new ArrayList<String>();
  notificationFactory = new NotificationFactory();

  // Serial
  status = new int[12];
  lastStatus = new int[12];

  println((Object[])Serial.list());
  
  inPort = new Serial(this, Serial.list()[device_number], baudRate); 
  inPort.bufferUntil('\n');

  // setup popupLocations -> coordinates are weights!
  // so location1 = (0.05 * width, 0.8 * height)
  // order in x-dimension
  allLocations.put(0, new FloatList(0.05, 0.8));
  allLocations.put(1, new FloatList(0.08, 0.15));
  allLocations.put(2, new FloatList(0.09, 0.5));
  allLocations.put(3, new FloatList(0.25, 0.66));
  allLocations.put(4, new FloatList(0.3, 0.1));
  allLocations.put(5, new FloatList(0.3, 0.35));
  allLocations.put(6, new FloatList(0.5, 0.44));
  allLocations.put(7, new FloatList(0.55, 0.05));
  allLocations.put(8, new FloatList(0.66, 0.28));
  allLocations.put(9, new FloatList(0.75, 0.5));
  allLocations.put(10, new FloatList(0.8, 0.70));
  allLocations.put(11, new FloatList(0.8, 0.1));
  
  notifNames = new ArrayList<String>(
     Arrays.asList("Recycle", "Unable", "DriveFull", "SetUp", "ShutDown", "Benches",
     "Pirate", "Congratulations", "LowBattery", "Warning", "Downloading", "Outlook", "Instagram",
     "VPN", "Steam", "Captcha", "AIMMessenger", "UnsecureWebsite", "Text3", "Text2", "Text3",
     "Text0", "Error", "Minesweeper", "Virus", "Webcam2", "Webcam1", "Webcam0", "Twitter",
     "Newsletter", "Slack", "Facebook"));

  // have to call once at start to say that all locations are available!
  updateAvailableLocations();  
}

void draw() {

  background(backgroundImage);

  displayTimer();

  // draw active notifications
  for(Notification notification : notifications.values()) 
  {
    notification.drawNotification();
    notification.playNotification(firstTime);
    firstTime++;
  }
  
  // check if there's a serial event?
  checkIfClickedSerial();

  // this needs work lol
  seconds = int((millis() * frameRate) / 1000);
  
  int denominator = notifications.size() + 1;
  
  rate = constrain(int((startingRate / denominator) * rateMultiplier), minRate, maxRate);  
  
   if(seconds % rate == 0) 
   {
     try {
     
      // get random available location 
      int sensorIndex = getAvailableLocation();
      FloatList coordinates = getCoordinates(sensorIndex); //(x, y) coordinate associated to location index 

      String name = getRandomNotifName();
      PImage image = loadImage("data/NotificationImages/" + name + ".png"); // name + ending
      SoundFile file = new SoundFile(this, "data/NotificationSounds/" + name + ".aiff"); // name + ending
       
      Notification newNotification = notificationFactory.createNotification(image, file, coordinates.get(0), coordinates.get(1), sensorIndex);
      notifications.put(sensorIndex, newNotification);
      
      updateAvailableLocations();  

    } catch(ArrayIndexOutOfBoundsException e) // no locations left to draw to, game is over
    {
      // THIS IS GAME OVER 
        System.out.println("All notifications drawn! Quitting game!");
        SoundFile gameOverSound = new SoundFile(this, "data/YouLoose.aiff");
        PImage gameOverImage = loadImage("data/YouLoose.png");
        image(gameOverImage, width * 0.25, height * 0.4, gameOverImage.width * 0.5, gameOverImage.height * 0.5);
        gameOverSound.play();
        noLoop();
    }
  }
}

// FOR COMPUTER TESTING 
void mousePressed() {
  IntList toRemove = new IntList();
  for(int notificationIndex : notifications.keySet())
  {
    Notification notification = notifications.get(notificationIndex);
    if(notification.checkIfClicked())
    {
      toRemove.append(notificationIndex);
    }
  }
  
  // to avoid ConcurrentModificationException
  for(int remove : toRemove )
  {
    notifications.remove(remove);
  }
  
  updateAvailableLocations();  
}

// FOR THE ACTUAL GAME WITH ARDUINO
// remove the entry in notifications associated with sensorIndex if one exists 
void checkIfClickedSerial()
{
  for(int i=0; i < clickedLocations.size(); i++) 
  {
    int location = clickedLocations.get(i); // get value at index i in clickedLocations
    notifications.remove(location);
  };
  
  updateAvailableLocations();
  clickedLocations.clear();
}

FloatList getCoordinates(int index)
{
  FloatList coordinates = allLocations.get(index);
  return new FloatList(coordinates.get(0) * width, coordinates.get(1) * height); // convert into x,y coordinates 
}

int getAvailableLocation()
{
  int index = int(random(availableLocations.size()));
  return availableLocations.get(index);

}

String getRandomNotifName()
{
  int index = int(random(notifNames.size()));
  return notifNames.get(index);
}

void updateAvailableLocations()
{
  availableLocations = new IntList();
  for(int locationKey : allLocations.keySet())
  {
    if(!notifications.containsKey(locationKey)) // if location isn't currently being used 
    {
      availableLocations.append(locationKey);
    }
  }
}

void displayTimer()
{
  // timer 
  int seconds = (millis() / 1000) % 60;
  int minutes = (millis() / 1000) / 60;
  String secondsFormat = (seconds < 10) ? "0" + seconds : str(seconds);
  timerText = "Timer: " + minutes + ":" + secondsFormat;
  
  textSize(20);
  textAlign(CENTER, BOTTOM);
  text(timerText, width * 0.9, height * 0.05);
} 

/**
  SERIAL FUNCTIONS 
**/
void updateArraySerial(int[] array) {
  if (array == null) {
    return;
  }

  for(int i = 0; i < min(array.length, splitString.length - 1); i++){
    try {
      array[i] = Integer.parseInt(trim(splitString[i + 1]));
    } catch (NumberFormatException e) {
      array[i] = 0;
    }
  }
}

void serialEvent(Serial p) {
 // System.out.println("serialEvent");
  inString = p.readString();
  splitString = splitTokens(inString, ": ");
  
  if (splitString[0].equals("TOUCH")) {
    updateArraySerial(status);
  }
    
  for (int i = 0; i < 12; i++) {
    if (lastStatus[i] == 0 && status[i] == 1) { // contact!
      System.out.println("clicked: " + i);
      println(i);     // Replace this line with where you want to push the data into
      clickedLocations.append(i); // append to a list of sensors that have been 'clicked'
      lastStatus[i] = 0;
    }
  }
}
