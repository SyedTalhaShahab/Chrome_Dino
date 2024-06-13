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