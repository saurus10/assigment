import ddf.minim.*;
import ddf.minim.analysis.*;

///create minim object. used to control the library
Minim minim;
//create audio in object for audio input
AudioPlayer song;
/*Create FFT(Fast Fourier transform) object. Splits a soundwave into a selection of bands for telling what the volume 
of different frequenceys in the sound signal are*/
FFT fft;//Varibale for dividing the width of the sketch by the amount of bands in the spectrum.
//For getting an even spacing between each of the line across the width of sketch
int w;
//create PImage for holding the data of the frame before
PImage fade;

float rWidth, rHeight;
//hue value for colours
int hVal;
 
void setup()
{
   size(640, 480,P3D);
   //stroke(255, 0, 0, 128);
   background(0);
 
   //intialize mimim object
  minim = new Minim(this);
 
   //intializa FFT object
  // specify 512 for the length of the sample buffers
  song = minim.loadFile("Dusky - Skin Deep (Original Mix).mp3", 512);
  
  song.play();
  
  //intializa FFT object
  // get length of audio buffers
  // get the sample rate of audio
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
 // println(fft);
  
  //Use log averags to space the frequencys 
  fft.logAverages(60, 7);
  
  w = width/fft.avgSize();
  
  /*set stroke width to same size so the 
  width of each line will equal the spacing*/
  strokeWeight(w);
  //make the stroke caps sqaure
  strokeCap(SQUARE);
  
  //Set fade to the contents of the sketch
  fade=get(0, 0, width, height);
  
  rWidth= width *0.99;
  rHeight= height * 0.99;
  hVal = 0;
  
  
  
  
}
 
void draw()
{
  background(0);
  
  //tint image
  tint(255, 255, 255, 254);
  //draw fade image to top left hand corner
  image(fade, (width-rWidth)/2, (height-rHeight)/2, rWidth, rHeight);
  //turn of tint 
  noTint();
  
  
   /*Call fft object and run forward function, 
  passing in the mix channel from audio IN. This
  mixes the left and right channels of the audio input
  and performs the fft*/
  fft.forward(song.mix);
 
  //Hue/Saturation/Brightness
  colorMode(HSB);
  //Run through hue, full saturation and full brightness
  stroke(hVal,255,255);
  colorMode(RGB);
  
  //iterate through the entire array of bands
  for(int i = 0; i<fft.avgSize(); i++)
  { 
    //   x1   y1    x2   y2--->height-a bandwidth *4 to make it visible
    line((i*w)+(w/2), height, (i*w)+(w/2), height-fft.getAvg(i)*4);
  }
  
  //Load fade with contents of the sketch the lines are drawn
  fade=get(0, 0, width, height);
  
  
  
  hVal+=2;
  if(hVal>255)
  {
    hVal=0;
  }
  
  
  if ( song.isPlaying() )
  {
   fill(7, 247, 65);
   textAlign(CENTER);
   text("Press any key to pause playback.", width-120, 20 );
  }
  else
  {
    text("Press any key to start playback.", width-120, 20 );
  }
 
   /*stroke(255);
  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
  }*/
  
}

void keyPressed()
{
  if ( song.isPlaying() )
  {
    song.pause();
  }
  else
  {
    // simply call loop again to resume playing from where it was paused
    song.loop();
  }
}