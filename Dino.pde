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
