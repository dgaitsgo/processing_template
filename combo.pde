import peasy.*;
int n = 3000;
Thing[] things = new Thing[n];
PeasyCam camera;

void push() {
   pushMatrix();
   pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

void setup() {
    size(800, 800, P3D);
    camera = new PeasyCam(this, 500);
    

    camera.rotateX(radians(-95));
    
    for (int i = 0; i < n; i++) {
      things[i] = new Thing();
    }
    frames = new int[width * height][3];
    initShadowPass();
    initDefaultPass();
}

void recordScene(PGraphics canvas) {
   //print(canvas)
  for (int pixel = 0; pixel < width * height; pixel++) {
        for (int channel = 0; channel < 3; channel++) {
           frames[pixel][channel] = 0; 
        }
     }
     for (int sa = 0; sa < samplesPerFrame; sa++) {
	   t = map(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames, 0, 1);
	   drawScene(canvas);
	   canvas.loadPixels();
       for (int i = 0; i < canvas.pixels.length; i++) {
         frames[i][0] += canvas.pixels[i] >> 16 & 0xff;
         frames[i][1] += canvas.pixels[i] >> 8 & 0xff;
         frames[i][2] += canvas.pixels[i] & 0xff;
       }
     }

     canvas.loadPixels();
	 for (int i = 0; i < canvas.pixels.length; i++) {
		canvas.pixels[i] = 0xff << 24 |
			int(frames[i][0] * 1.0 / samplesPerFrame) << 16 |
			int(frames[i][1] * 1.0 / samplesPerFrame) << 8 |
			int(frames[i][2] * 1.0 / samplesPerFrame);
     }
   	 canvas.updatePixels();
	 println(frameCount, '/', numFrames);
     if (frameCount <= numFrames) {
       saveFrame("fr###.png");
     } else {
		exit();
	}
}

void drawShadowMap() {
  // Calculate the light direction (actually scaled by negative distance)
    //float lightAngle = frameCount * 0.002;
    float lightAngle = 0.002;
    lightDir.set(sin(lightAngle) * 160, 160, cos(lightAngle) * 160);
 
    // Render shadow pass
    shadowMap.beginDraw();
    shadowMap.camera(lightDir.x, lightDir.y, lightDir.z, 0, 0, 0, 0, 1, 0);
    shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
    drawScene(shadowMap);
    shadowMap.endDraw();
    shadowMap.updatePixels();
 
    // Update the shadow transformation matrix and send it, the light
    // direction normal and the shadow map to the default shader.
    updateDefaultShader();
}
 
void draw() {
   
    //Draw scene from light's perspective
    drawShadowMap();
   
    //Draw scene from camera's perspective
    background(0xff222222);
    drawScene(g);
 
    // Render light source
    pushMatrix();
    fill(0xffffffff);
    translate(lightDir.x, lightDir.y, lightDir.z);
    //box(5);
    popMatrix();
    
    if (keyPressed) {
      if (key == 'c' || key == 'C') {
         println(camera.getRotations());  
      }
      if (key == 'r' || key == 'R') {
         println("began recording");
         recording = true;
      }
    }
   
   //Record scene
   if (recording) {
     recordScene(g);
   }
}
 
public void drawScene(PGraphics canvas) {
   
    float offset = -frameCount * 0.01;
    canvas.fill(255);
    for (int sa = 0; sa < samplesPerFrame; sa++) {
      t = map(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames, 0, 1);
      for (int i = 0; i < n; i++) {
        things[i].show(canvas, t);
      }
    }
    canvas.fill(0xff222222);
    canvas.box(360, 5, 360);    
}
