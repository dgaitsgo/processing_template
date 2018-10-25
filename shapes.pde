class Thing {
   float x = random(-180, 180);
   float z = random(-180, 180);
   float radius = random(2, 40);
   float y = random(radius + 20, 50);
   float size = 1;
   float offset = 9 * noise(0.04*x, 0.04*y);;
   
   public void show(PGraphics canvas, float t) {
     canvas.noStroke();
     canvas.pushMatrix();
     canvas.translate(
        x + radius * cos(TWO_PI * t + offset),
        y + radius * sin(TWO_PI * t + offset),
      z);
     canvas.sphere(size);
     canvas.popMatrix();
   }
}
//float y = random(, 20);
