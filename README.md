# Pop Up Smash Pro

### Description   
Pop Up Smash Pro was a game made and exhibited at the Portals of Perception Showcase at The Hub, Eagle Wharf, London SE. The game contains a Windows-95 themed computer screen on a projected surface containg various popups ranging from the annoying to the absurd that appear incessantly as the player is tasked with closing each one of them before the screen fills up. The interaction is achieved through conductive tape connected to the electrodes of a Bare Conductive Touch Board relaying the touch to a Processing sketch.

### Team
This project was done by a team consisting of Advait Ukidve, Avika Pulges, Eva Hayek, Ileana Park, Kiri Rodenburg, and Mae Horak (pictured below). 

### Components and Working

- [DataStream.ino](./DataStream.ino) contains the Arduino C code uploaded to the Touch Board. The code will have to be uploaded, run, tested with the serial monitor, and the serial monitor closed in order for it to be communicated with the Processing sketch (main programme). The Touch Board outputs an array of 12 booleans with True representing the electrode number touched.
- [Show_prototype.pde](show_prototype.pde) is the main Processing sketch that is run headlessly. It sets up the background screen, imports all the required image and sound files, and triggers the notification and the associated sound at a spot currently not held by an existing notification on the screen at random using the [NotificationFactory Class](NotificationFactory.pde).
- [data](./data) contains all the images used in the game and [Gallery](./Gallery) contains images from the exhibition where it was presented.   

## Gallery

![Caption](./Gallery/image.jpg)
<sub> Subtitle to go with image.
