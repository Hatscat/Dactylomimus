/*
This software require a "Creative Gesture Camera" to works. 
*/

import intel.pcsdk.*;

private PImage display, signPict;
private PXCUPipeline pp;
private MyGestureHandler gest;

void setup() {
  
  size(1024, 768);
  background(255);
  if (frame != null) {
    frame.setResizable(true); // fenêtre redimensionnable
  }
  
  pp = new PXCUPipeline(this); // la bibliothèque du SDK d'Intel
  pp.Init(PXCUPipeline.GESTURE);
  
  int[] size = new int[2];
  pp.QueryLabelMapSize(size);
  display = createImage(size[0], size[1], RGB);
  
  gest = new LettersGestureHandler(); // classe de reconnaissance des signes, à part pour plus de clareté
  
  signPict = loadImage("a.png"); // l'image test, représentant le signe pour la lettre "A", en LSF

}

void draw() {
  
  // découpage de la page en 3 parties : à gauche la lettre / le mot / l'expression ; en haut à droite la représentation du signe à reproduire ; et en bas à droite la vidéo "gesture"

  // 1 : le texte
  textSize(320);
  fill(0);
  text("A", 32, 320);
  
  // 2 : le signe à reproduire
  image(signPict, width - display.width, 0);

  // 3 : la camera
  if (!pp.AcquireFrame(false)) return; // si la camera ne capte rien le programme n'attend pas et la frame s'arrête. (à remplacer par pp.AcquireFrame(true); si l'on souhaite qu'il bloque la frame et attende de capter quelque chose)
  
  if (pp.QueryLabelMapAsImage(display))
  {
    image(display, width - display.width, height - display.height);
  }
  
  // 4 : la reconnaissance du signe
  gest.OnGesture(); // cf la classe
  
  if (gest.letters[0]) print("yep\n");
  
  pp.ReleaseFrame();

}
 

