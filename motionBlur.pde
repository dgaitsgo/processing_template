/********************************************************************/
/* Motion Blur Setup */
/********************************************************************/
int [][] frames;
//t is the time variable and goes from 0 to 1
//_drawing are based on t
float t, c;

//Number of drawings per final frame, averaged for motion blur effect
int samplesPerFrame = 5,
    //frame length of gif
    numFrames = 10;

//"How spaced in time the samples of each frames are"
float shutterAngle = 1.5;

//Record gif frames with motion blur. 
boolean recording = false;
