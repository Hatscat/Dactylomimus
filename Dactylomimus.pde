/*
This software require :
- a "Creative Gesture Camera" to be use
- the PXCUPipeline library (from intel) to edit
- Processing 2.0 to edit
*/

import intel.pcsdk.*;

private PImage display; // le rendu de la capture vidéo "gestuelle"
private PImage AlphabetPicture; // l'image de base, avec tout les signes de l'alphabet, à découper
private PImage[] letterSignPictures; // les images représentants les signes correspondants aux lettres de l'alphabet (de 0 à 25), en LSF
private PXCUPipeline pp; // la bibliothèque du SDK d'Intel
private LettersGestureHandler gest; // la classe servant à reconnaitre des lettres signées
public int scene; // le numéro de la scène : '0' pour le menu, '1' pour l'apprentissage, '2' pour le jeu

void setup() {
  
  size(1024, 768);
  background(255);
  
  if (frame != null) {
    frame.setResizable(true); // fenêtre redimensionnable
  }
  
  pp = new PXCUPipeline(this); 
  pp.Init(PXCUPipeline.GESTURE);
  
  int[] size = new int[2];
  pp.QueryLabelMapSize(size);
  display = createImage(size[0], size[1], RGB);
  
  gest = new LettersGestureHandler(); // 
  
  AlphabetPicture = loadImage("alphabet_lsf.png");
  letterSignPictures = new PImage[26];
  
  AlphabetPicture.loadPixels();
  
  for  (int i = 0, c = letterSignPictures.length; i < c; i++)
  {
    letterSignPictures[i] = createImage(320, 320, RGB);
    letterSignPictures[i].loadPixels();
    
    for (int i2 = 0, c2 = letterSignPictures[i].pixels.length; i2 < c2; i2++)
    {
      letterSignPictures[i].pixels[i2] = AlphabetPicture.pixels[i2 + i * (320 * 320)];
    }
    letterSignPictures[i].updatePixels();
  }
  
  scene = 0;
}

void draw() {
  
  // découpage de la page en 3 parties : à gauche la lettre / le mot / l'expression ; en haut à droite la représentation du signe à reproduire ; et en bas à droite la vidéo "gesture"

  // 1 : le texte
  textSize(320);
  fill(0);
  text("A", 32, 320);
  
  // 2 : le signe à reproduire
  image(letterSignPictures[0], width - letterSignPictures[0].width, 0);

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
 

