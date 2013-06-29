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
private PImage shapesPicture;
private PImage[] shapePictures;
private PImage noiseShapesPict;
private PImage[] noiseShapePicts;
private ArrayList<LetterToSign> letters; // les lettres écrite à signer 
private PXCUPipeline pp; // la bibliothèque du SDK d'Intel
private LettersGestureHandler gest; // la classe servant à reconnaitre des lettres signées
private ShapeRecognition shape;
private int letterToShow;
private int frame;
private float difficulty;
private boolean wait;
public int scene; // le numéro de la scène : '0' pour le menu, '1' pour l'apprentissage, '2' pour le jeu
public int score;
public int highscore;
private int correspondenceScore;

  //////////////////////////////////////////////////////////////////

void setup() {
  
  frameRate(15);
  size(960, 600);

  pp = new PXCUPipeline(this); 
  pp.Init(PXCUPipeline.GESTURE);
  
  int[] size = new int[2];
  pp.QueryLabelMapSize(size);
  display = createImage(size[0], size[1], RGB);
  
  gest = new LettersGestureHandler();
  shape = new ShapeRecognition();
  
  letters = new ArrayList<LetterToSign>();
  letters.add(new LetterToSign(0));
  
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
  
  shapesPicture = loadImage("alphabet_lsf_min.png");
  shapePictures = new PImage[26];
  
  shapesPicture.loadPixels();
  
  for  (int i = 0, c = shapePictures.length; i < c; i++)
  {
    shapePictures[i] = createImage(200, 220, ARGB);
    shapePictures[i].loadPixels();
    
    for (int i2 = 0, c2 = shapePictures[i].pixels.length; i2 < c2; i2++)
    {
      shapePictures[i].pixels[i2] = shapesPicture.pixels[i2 + i * (200 * 220)];
    }
    shapePictures[i].updatePixels();
  }
  
  noiseShapesPict = loadImage("alphabet_lsf_shape.png");
  noiseShapePicts = new PImage[26];
  
  noiseShapesPict.loadPixels();
  
  for  (int i = 0, c = noiseShapePicts.length; i < c; i++)
  {
    noiseShapePicts[i] = createImage(200, 220, ARGB);
    noiseShapePicts[i].loadPixels();
    
    for (int i2 = 0, c2 = noiseShapePicts[i].pixels.length; i2 < c2; i2++)
    {
      noiseShapePicts[i].pixels[i2] = noiseShapesPict.pixels[i2 + i * (200 * 220)];
    }
    noiseShapePicts[i].updatePixels();
  }
  
  letterToShow = 0;
  scene = 0;
  wait = false;
  difficulty = 20;
  frame = 0;
  score = 0;
  highscore = 0;
  correspondenceScore = 0;
  
}

  //////////////////////////////////////////////////////////////////

void draw() {
  
  background(255);
  
  PXCMGesture.GeoNode ndata = new PXCMGesture.GeoNode();
  PXCMGesture.Gesture gdata = new PXCMGesture.Gesture();
  
  // la camera
  if (!pp.AcquireFrame(false)) return;
  
  if (pp.QueryLabelMapAsImage(display))
  {
    image(display, width - display.width, height - display.height);
  }
  
  fill(0);
    
  textAlign(LEFT, TOP);
  
  //gest.OnGesture(); //la reconnaissance du signe
  
  ////////////////////////////////////////////////////////////////// LA SCENE DU MENU //////////////////////////////////////////////////////////////////
  
  if (scene == 0)
  {
    
    LetterToSign letter = letters.get(0);
    
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
        letterToShow = 0;
        letter.letterNb = 0;
        frame = 0;
        scene = 1;
      }
      else if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_PEACE)
      {
        frame = 0;
        for (int i = letters.size()-1; i >= 0; i--) {
          letters.remove(i);
        }
        score = 0;
        scene = 2;
      }
    }
    
    ////////////////////////////////////////////////////////////////// LA SCENE D'APPRENTISSAGE DE L'ALPHABET //////////////////////////////////////////////////////////////////
    
  } else if (scene == 1)
  {
    LetterToSign letter = letters.get(0);
    letter.isAwake = false;
    letter.Awake();
    
    // 1 : le texte
    textSize(300);
    text(letter.letter, 200, 30);

    // 2 : le signe à reproduire
    image(letterSignPictures[letterToShow], width - (letterSignPictures[letterToShow].width * 1.1), 50);
    
    tint(255, 80);
    image(shapePictures[letterToShow], width - display.width , height - display.height);
    tint(255, 0);
    image(noiseShapePicts[letterToShow], width - display.width , height - display.height);
    tint(255);
    
  ////////////////////////////////////////////////////////////////// shapePictures
  
    for (int y = 0; y < noiseShapePicts[letterToShow].height; y++) {
      for (int x = 0; x < noiseShapePicts[letterToShow].width; x++) {
        int loc = x + y*noiseShapePicts[letterToShow].width;
        if (display.get(x, y) == noiseShapePicts[letterToShow].pixels[loc])
        {
          correspondenceScore += 160;
          
        } else if (display.get(x, y) < noiseShapePicts[letterToShow].pixels[loc])
        {
          correspondenceScore -= 10;
        } else {
          correspondenceScore -= 1;
        }
      }
    }
    
    if (correspondenceScore > 1)
    {
      wait = true;
    }
    
    if (gest.letters[letterToShow])
    {
      wait = true;
    }
    
    correspondenceScore = 0;
    
    if (wait)
    {    
      fill (0, 200, 0);
      textSize(150);
      text("Bravo !", 100, 320);
      if (frame%60 == 0)
      {
        wait = false;
        if (letterToShow < 25)
        {
          letter.letterNb++;
          letterToShow++;
        } else {
          scene = 0;
        }
      }
    }
    
    if (pp.QueryGesture(PXCMGesture.GeoNode.LABEL_ANY, gdata))
    {
      if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_THUMB_DOWN)
      {
        scene = 0;
      } else if (gdata.label == PXCMGesture.Gesture.LABEL_NAV_SWIPE_RIGHT || gdata.label == PXCMGesture.Gesture.LABEL_NAV_SWIPE_LEFT)
      {
        if (letterToShow < 25)
        {
          letter.letterNb++;
          letterToShow++;
        } else {
          scene = 0;
        }
      }
    }
      
    ////////////////////////////////////////////////////////////////// LA SCENE DE JEU //////////////////////////////////////////////////////////////////
    
  } else if (scene == 2)
  {
    if (frame%difficulty == 0)
    {
      InstantiateGameLetter();
    }
    
    for (int i = letters.size()-1; i >= 0; i--) {
      LetterToSign letterClone = letters.get(i);
      
      letterClone.Awake();
      letterClone.Move();
      letterClone.Display();
      
      if (letterClone.Finished()) {
        letters.remove(i);
        score++;
        if (score > highscore)
        {
          highscore = score;
        }
      }
      
      if (letterClone.Lose()) {
        letters.remove(i);
        if (score > 0)
        {
          score--;
        }
      }
    }
    
    textAlign(CENTER, TOP);
    textSize(110);
    text(score, width*0.81, height*0.1);
    
    fill(200, 0, 0);
    textSize(75);
    text(highscore, width*0.81, height*0.4);
    
    if (pp.QueryGesture(PXCMGesture.GeoNode.LABEL_ANY, gdata))
    {
      if (gdata.label == PXCMGesture.Gesture.LABEL_POSE_THUMB_DOWN)
      {
        frame = 0;
        scene = 0;
      }
    }
  }
  
  //////////////////////////////////////////////////////////////////
  
  pp.ReleaseFrame();
  frame++;
}
  
  //////////////////////////////////////////////////////////////////

void InstantiateGameLetter() {
  difficulty = int(random(88, 90));
  letters.add(new LetterToSign(int(random(8))));
}

