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
