//Ctrl + Shift + B to run code

Dino dino;
ArrayList<Cactus> cacti;
ArrayList<Bird> birds;
int score = 0;
boolean gameOver = false;

PImage dinoRun1;
PImage dinoRun2;
PImage dinoJump;
PImage dinoDuck;
PImage dinoDuck1;
PImage smallCactus;
PImage manySmallCactus;
PImage bigCactus;
PImage birdImg;
PImage birdImg1;

int numGroundPieces = 100; // this is the Number of ground pieces
Ground[] grounds = new Ground[numGroundPieces]; // Array to hold ground pieces
float speed = 6; // Speed at which ground pieces move
float groundHeight = 50; // Average height of the ground pieces

// acts like public static void main(String[] args)

void setup() {
    size(1200 , 800);
    dinoRun1 = loadImage("img/dinoRun1.png");
    dinoRun2 = loadImage("img/dinoRun2.png");
    dinoJump = loadImage("img/dinoJump.png");
    dinoDuck = loadImage("img/dinoDuck.png");
    dinoDuck1 = loadImage("img/dinoDuck1.png");
    smallCactus = loadImage("img/smallCactus.png");
    manySmallCactus = loadImage("img/manySmallCactus.png");
    bigCactus = loadImage("img/bigCactus.png");
    birdImg = loadImage("img/bird.png");
    birdImg1 = loadImage("img/bird1.png");
    
    dino = new Dino();
    cacti = new ArrayList<Cactus>();
    birds = new ArrayList<Bird>();
    frameRate(60);
    
    
    for (int i = 0; i < numGroundPieces; i++) {
        grounds[i] = new Ground();
        grounds[i].posX = random(0, width); // Randomize initial x position
    }
}

void keyPressed() {
    if ((key == ' ' && !gameOver) || (keyCode == UP && !gameOver)) {
        dino.jump();
    } else if (key == 'r' && gameOver) {
        resetGame();
    } else if (keyCode == DOWN) {
        dino.duck();
    }
}


void keyReleased() {
    if (keyCode == DOWN) {
        dino.stopDuck();
    }
}


void resetGame() {
    score = 0;
    gameOver = false;
    dino = new Dino();
    cacti.clear();
    birds.clear();
    
    for (int i = 0; i < grounds.length; i++) {
        grounds[i].posX = random(0, width); // Randomize initial x position
    }
    
}

void spawnBird() {
    birds.add(new Bird());
}

void draw() {
    background(255);  // Clear the background to white
    fill(0);  // Set fill color to black
    rect(0, 780, 1200, 20);  // Draw a black rectangle
    for (int i = 0; i < numGroundPieces; i++) {
        grounds[i].show();
        grounds[i].move(speed);
        
        // If a ground piece moves off the screen, reset its position
        if (grounds[i].posX + grounds[i].w < 0) {
            grounds[i].posX = width;
            grounds[i].posY = height - floor(random(groundHeight - 20, groundHeight + 30));
            grounds[i].w = floor(random(1, 10));
        }
    }
    
    
    if (!gameOver) {
        
        dino.update();
        dino.display();
        
        if (random(1) < 0.9 && (frameCount % 200 == 0)) {
            
            // optional below Spawn cactus with 23 % probability and only after 900 pixels
            // && cacti.size() == 0 || (cacti.size() > 0 && cacti.get(cacti.size() - 1).x< width - 900) && 
            cacti.add(new Cactus());
        }
        
        if (random(1) < 0.99 && frameCount % 300 == 0) {
            birds.add(new Bird());
        }
        
        
        for (int i = cacti.size() - 1; i >= 0; i--) {
            Cactus c = cacti.get(i);
            c.update();
            c.display();
            
            if (dino.hits(c)) {
                gameOver = true;
            }
            
            if (c.isOffScreen()) {
                cacti.remove(i);
                score++;
            }
        }
        
        for (int i = birds.size() - 1; i >= 0; i--) {
            Bird b = birds.get(i);
            b.update();
            b.display();
            
            if (dino.hits(b)) {
                gameOver = true;
            }
            
            if (b.isOffScreen()) {
                birds.remove(i);
                score++;
            }
        }
        
        fill(0);
        textSize(20);
        text("Score: " + score, width - 150, 50);
    } else {
        
        for (int i = grounds.length - 1; i >= 0; i--) {
            grounds[i].posX = -100; // Randomize initial x position
        }
        
        textSize(50);
        textAlign(CENTER);
        fill(0);
        text("Game Over", width / 2, height / 2);
        textSize(40);
        text("Press [r]", width / 2,(height) * 0.6);
        textSize(40);
        text("to Reset",width / 2,(height) * 0.65);
        size(1200 , 800);
        gameOver = true;
    }
    
}