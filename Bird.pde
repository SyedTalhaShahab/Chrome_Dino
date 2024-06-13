
PImage backgroundImage;  // Declare a variable for the background image
float bgX = 0;           // Initial X position of the background

void setup() {
  size(800, 600);  // Set the size of the sketch window
  // Load the background image
  backgroundImage = loadImage("background.jpg");
}

void draw() {
  background(255);  // Clear the screen with a white background
  
  // Draw the background image
  image(backgroundImage, bgX, 0);
  
  // Move the background to the left
  bgX -= 1;  // Adjust the speed of scrolling by changing this value
  
  // Check if the background has moved completely off-screen
  if (bgX <= -backgroundImage.width + width) {
    bgX = 0;  // Reset the background position to repeat the scrolling
  }
}
