/*
This software require :
- a "Creative Gesture Camera" to be use
- the PXCUPipeline library (from intel) to edit
- Processing 2.0 to edit
*/

import intel.pcsdk.*;

private PImage display; // le rendu de la capture vidéo gestuelle
private PImage alphabetPicture; // l'image de base, avec tout les signes de l'alphabet, à découper
private PImage[] letterSignPictures; // les images représentants les signes correspondants aux lettres de l'alphabet (de 0 à 25), en LSF
private PImage navigationSignPicture;
private PImage[] navSignPictures;
private ArrayList<LetterToSign> letters; // les lettres écrite à signer 
private PXCUPipeline pp; // la bibliothèque du SDK d'Intel
private LettersGestureHandler gest; // la classe servant à reconnaitre des lettres signées
private int letterToShow;
private boolean wait;
public int scene; // le numéro de la scène : '0' pour le menu, '1' pour l'apprentissage, '2' pour le jeu

  //////////////////////////////////////////////////////////////////

void setup() {
  
  frameRate(30);
  size(960, 600);
  background(255);
  /*
  if (frame != null) {
    frame.setResizable(true); // fenêtre redimensionnable
  }
  */
  pp = new PXCUPipeline(this); 
  pp.Init(PXCUPipeline.GESTURE);
  
  int[] size = new int[2];
  pp.QueryLabelMapSize(size);
  display = createImage(size[0], size[1], RGB);
  
  gest = new LettersGestureHandler();
  
  letters = new ArrayList<LetterToSign>();
  letters.add(new LetterToSign(0, 0));
  
  alphabetPicture = loadImage("alphabet_lsf.png");
  letterSignPictures = new PImage[26];
  
  alphabetPicture.loadPixels();
  
  for  (int i = 0, c = letterSignPictures.length; i < c; i++)
  {
    letterSignPictures[i] = createImage(280, 305, RGB);
    letterSignPictures[i].loadPixels();
    
    for (int i2 = 0, c2 = letterSignPictures[i].pixels.length; i2 < c2; i2++)
    {
      letterSignPictures[i].pixels[i2] = alphabetPicture.pixels[i2 + i * (280 * 305)];
    }
    letterSignPictures[i].updatePixels();
  }
  
  navigationSignPicture = loadImage("menu_navigation.png");
  navSignPictures = new PImage[3];
  
  navigationSignPicture.loadPixels();
  
  for  (int i = 0, c = navSignPictures.length; i < c; i++)
  {
    navSignPictures[i] = createImage(140, 153, RGB);
    navSignPictures[i].loadPixels();
    
    for (int i2 = 0, c2 = navSignPictures[i].pixels.length; i2 < c2; i2++)
    {
      navSignPictures[i].pixels[i2] = navigationSignPicture.pixels[i2 + i * (140 * 153)];
    }
    navSignPictures[i].updatePixels();
  }
  
  letterToShow = 0;
  scene = 0;
  wait = false;
  
}

  //////////////////////////////////////////////////////////////////

void draw() {
  
  PXCMGesture.GeoNode ndata = new PXCMGesture.GeoNode();
  PXCMGesture.Gesture gdata = new PXCMGesture.Gesture();
  
  // la camera
  if (!pp.AcquireFrame(false)) return; // si la camera ne capte rien le programme n'attend pas et la frame s'arrête. (à remplacer par pp.AcquireFrame(true); si l'on souhaite qu'il bloque la frame et attende de capter quelque chose)
  
  if (pp.QueryLabelMapAsImage(display))
  {
    image(display, width - display.width, height - display.height);
  }
  
  fill(0);
    
  textAlign(LEFT, TOP);
  
  
  ////////////////////////////////////////////////////////////////// LA SCENE DU MENU //////////////////////////////////////////////////////////////////
  
  if (scene == 0)
  {

    textSize(100);
    
    text("Dactylomimus", 120, 40);
    
    textSize(50);
    
    text("Apprentissage de l'alphabet", 180, 280);
    image(navSignPictures[0], 20, 230);
    text("Jeu", 180, 440);
    image(navSignPictures[2], 20, 380);
    
    if (pp.QueryGesture(PXCMGesture.GeoNode.LABEL_ANY, gdata))
    {
      if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_THUMB_UP)
      {
        background(255);
        letterToShow = 0;
        scene = 1;
      }
      else if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_PEACE)
      {
        background(255);
        scene = 2;
      }
    }
    
    ////////////////////////////////////////////////////////////////// LA SCENE D'APPRENTISSAGE DE L'ALPHABET //////////////////////////////////////////////////////////////////
    
  } else if (scene == 1)
  {
    // découpage de la page en 3 parties : à gauche la lettre / le mot / l'expression ; en haut à droite la représentation du signe à reproduire ; et en bas à droite la vidéo gesture
    
<<<<<<< HEAD
    // LetterToSign letter = letters.get(letterToShow);
    LetterToSign letter = letters.get(0);
    
=======
    LetterToSign letter = letters.get(0);
    letter.Awake();
>>>>>>> 871d2f82969bc09d953248122c800e14b6488ca8
    // 1 : le texte
    textSize(300);
    text(letter.letter, 200, 40); //letter.letter
    
    // 2 : le signe à reproduire
    image(letterSignPictures[letterToShow], width - (letterSignPictures[letterToShow].width * 1.1), 50);
    
    // 4 : la reconnaissance du signe
    gest.OnGesture(); // cf la classe
    
    if (gest.letters[letterToShow])
    {
      wait = true;
      
      fill (0, 200, 0);
      textSize(150);
      text("Bravo !", 100, 300);
    }
    
    if (wait && second()%2 == 0)
    {
      wait = false;
      gest.letters[letterToShow] = false;
      if (letterToShow < 25)
      {
        letterToShow++;
        letter.letterNb++;
        background(255);
      }
    }
    
    if (pp.QueryGesture(PXCMGesture.GeoNode.LABEL_ANY, gdata))
    {
      if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_THUMB_DOWN)
      {
        background(255);
        scene = 0;
      }
    }
      
    ////////////////////////////////////////////////////////////////// LA SCENE DE JEU //////////////////////////////////////////////////////////////////
    
  } else if (scene == 2)
  {
    
    
    if (pp.QueryGesture(PXCMGesture.GeoNode.LABEL_ANY, gdata))
    {
      if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_THUMB_DOWN)
      {
        background(255);
        scene = 0;
      }
    }
  }
  
  //////////////////////////////////////////////////////////////////
  
  pp.ReleaseFrame();

}
  
  //////////////////////////////////////////////////////////////////


