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
    background(255, 204, 153);  // Clear the background to yellow tint
    //https://www.w3schools.com/colors/colors_picker.asp
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

class Ground {
    float posX;
    float posY;
    int w;
    
    Ground() {
        posX = width;
        posY = height - floor(random(groundHeight - 20, groundHeight + 30));
        w = floor(random(1, 10));
    }
    
    void show() {
        stroke(0);
        strokeWeight(3);
        line(posX, posY, posX + w, posY);
    }
    
    void move(float speed) {
        posX -= speed;
    }
}

class Cactus {
    float x, y;
    float speed;
    float w, h;
    PImage img;
    
    Cactus() {
        x = width;
        y = height - 60;
        w = 20;
        h = 40;
        speed = 6;
        
        int rand = int(random(3));
        if (rand == 0) {
            img = smallCactus;
            w = img.width;
            h = img.height;
        } else if (rand == 1) {
            img = manySmallCactus;
            w = img.width;
            h = img.height;
        } else {
            img = bigCactus;
            w = img.width;
            h = img.height;
        }
    }
    
    void update() {
        x -= speed;
    }
    
    void display() {
        image(img, x, y - img.height);
    }
    
    boolean isOffScreen() {
        return x < - w;
    }
}


class Dino {
    float x, y;
    float w, h;
    float gravity;
    float lift;
    float velocity;
    boolean ducking;
    int animationFrame;
    
    Dino() {
        
        w = 20f; // running dino not ducking dino
        h = 40f; // running dino not ducking dino
        gravity = 0.8; // decrease value for weaker gravity
        lift= -23; // Increased lift value for higher jump
        velocity = 0;
        
        ducking = false;
        animationFrame = 0;
    }
    
    void update() {
        velocity += gravity;
        y += velocity;
        
        if (y > height - h - 20) {
            y = height - h - 20;
            velocity = 0;
        }
    }
    
    void display() {
        if (y < height - h - 20) {
            image(dinoJump, x, y - dinoJump.height);
        } else if (ducking) {
            w = 40f; // ducking dino not running dino
            h = 20f; // ducking dino not running dino
            if (frameCount % 5 == 0) {
                image(dinoDuck, x, y - dinoDuck.height);
            } else {
                image(dinoDuck1, x, y - dinoDuck1.height);
            }
            
        } else {
            w = 20f; // running dino not ducking dino
            h = 40f; // running dino not ducking dino
            if (frameCount % 5 == 0) {
                image(dinoRun1, x, y - dinoRun1.height);
            } else {
                image(dinoRun2, x, y - dinoRun2.height);
            }
        }
    }
    
    void jump() {
        if (y == height - h - 20) {
            velocity = lift;
        }
    }
    
    void duck() {
        ducking = true;
    }
    
    void stopDuck() {
        ducking = false;
    }
    
    boolean hits(Cactus c) {
        return(x < c.x + c.w && x + w > c.x && y < c.y + c.h && y + h > c.y);
    }
    
    boolean hits(Bird b) {
        return(x < b.x + b.w && x + w > b.x && y < b.y + b.h && y + h > b.y);
    }
}


class Bird {
    float x, y;
    float speed;
    float w, h;
    int animationFrame;
    
    Bird() {
        x = 1200;
        y = height - 140;
        speed = 6;
        animationFrame = 0;
        w = birdImg.width;
        h = birdImg.height + 5;
    }
    
    void update() {
        x -= speed;
        if (frameCount % 10 == 0) {
            animationFrame = (animationFrame + 1) % 2;
        }
    }
    
    void display() {
        if (animationFrame == 0) {
            image(birdImg, x, y - birdImg.height);
        } else {
            image(birdImg1, x, y - birdImg1.height);
        }
    }
    
    boolean isOffScreen() {
        return x < - w;
    }
}

