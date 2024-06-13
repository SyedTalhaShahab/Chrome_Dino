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
