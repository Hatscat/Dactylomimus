class LettersGestureHandler {

  public boolean[] letters = new boolean[26]; // les lettres de l'alphabet, reconnues "true", ou pas "false"
  
  // les positions x et y des doigts, du milieu de la main, du haut de la main, du bas de la main
  private float[] HAND_MIDDLE = new float[2], HAND_UPPER = new float[2], HAND_LOWER = new float[2],
                  FINGER_THUMB = new float[2], FINGER_INDEX = new float[2],
                  FINGER_MIDDLE = new float[2], FINGER_RING = new float[2], FINGER_PINKY = new float[2];
  
  public float angle_thumb, angle_index, angle_middle, angle_ring, angle_pinky, angle_hand_upper, angle_hand_lower;
  
  public PVector v_hand_middle, v_hand_upper, v_hand_lower, v_thumb, v_index, v_middle, v_ring, v_pinky;
  
  public String test = "";
  
  public float distance;
  
  public void OnGesture() {
    
    for (int i=0, c=letters.length; i<c; i++)
    {
      letters[i] = false; // appel de la fonction = on réinitialise tout
    }
    
    PXCMGesture.GeoNode ndata = new PXCMGesture.GeoNode();
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // première étape = trouver les positions des doigts et du centre de la main, si la camera les detectes
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_MIDDLE, ndata))
    {
      HAND_MIDDLE[0] = ndata.positionImage.x;
      HAND_MIDDLE[1] = ndata.positionImage.y;
      //print ("HAND\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_UPPER, ndata))
    {
      HAND_UPPER[0] = ndata.positionImage.x;
      HAND_UPPER[1] = ndata.positionImage.y;
      //print ("HAND_UPPER\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_LOWER, ndata))
    {
      HAND_LOWER[0] = ndata.positionImage.x;
      HAND_LOWER[1] = ndata.positionImage.y;
      //print ("HAND_LOWER\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
    {
      FINGER_THUMB[0] = ndata.positionImage.x;
      FINGER_THUMB[1] = ndata.positionImage.y;
      //print ("FINGER_THUMB\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata))
    {
      FINGER_INDEX[0] = ndata.positionImage.x;
      FINGER_INDEX[1] = ndata.positionImage.y;
      //print ("FINGER_INDEX\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata))
    {
      FINGER_MIDDLE[0] = ndata.positionImage.x;
      FINGER_MIDDLE[1] = ndata.positionImage.y;
      //print ("FINGER_MIDDLE\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata))
    {
      FINGER_RING[0] = ndata.positionImage.x;
      FINGER_RING[1] = ndata.positionImage.y;
      //print ("FINGER_RING\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
    {
      FINGER_PINKY[0] = ndata.positionImage.x;
      FINGER_PINKY[1] = ndata.positionImage.y;
      //print ("FINGER_PINKY\n");
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // puis deuxième étape : calculer les angles entre à partir des positions pour reconnaitre les signes
    //
    // et mettre à "true les signes reconnus --> i.e. "letters[0] = true;" utiliser PVector
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // position de v_hand_middle
    v_hand_middle = new PVector(HAND_MIDDLE[0], HAND_MIDDLE[1]);
    //v_hand_middle.normalize();
    
    // position de v_hand_upper
    v_hand_upper = new PVector(HAND_UPPER[0]-HAND_MIDDLE[0], HAND_UPPER[1]-HAND_MIDDLE[1]);
    //v_hand_upper.normalize();
    
    // position de v_hand_lower
    v_hand_lower = new PVector(HAND_LOWER[0]-HAND_MIDDLE[0], HAND_LOWER[1]-HAND_MIDDLE[1]);
    //v_hand_lower.normalize();
    
    // direction de v_thumb par rapport à v_hand_middle
    v_thumb = new PVector(FINGER_THUMB[0]-HAND_MIDDLE[0], FINGER_THUMB[1]-HAND_MIDDLE[1]);
    //v_thumb.normalize();
    
    // direction de v_index par rapport à v_hand_middle
    v_index = new PVector(FINGER_INDEX[0]-HAND_MIDDLE[0], FINGER_INDEX[1]-HAND_MIDDLE[1]);
    //v_index.normalize();
    
    // direction de v_middle par rapport à v_hand_middle
    v_middle = new PVector(FINGER_MIDDLE[0]-HAND_MIDDLE[0], FINGER_MIDDLE[1]-HAND_MIDDLE[1]);
    //v_middle.normalize();
    
    // direction de v_ring par rapport à v_hand_middle
    v_ring = new PVector(FINGER_RING[0]-HAND_MIDDLE[0], FINGER_RING[1]-HAND_MIDDLE[1]);
    //v_ring.normalize();
    
    // direction de v_pinky par rapport à v_hand_middle
    v_pinky = new PVector(FINGER_PINKY[0]-HAND_MIDDLE[0], FINGER_PINKY[1]-HAND_MIDDLE[1]);
    //v_pinky.normalize();
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Calcul des angles
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Angle entre le milieu de la main et le haut de la main
    angle_hand_upper  = degrees(PVector.angleBetween(v_hand_middle, v_hand_upper));
    
    // Angle entre le milieu de la main et le bas de la main
    angle_hand_lower  = degrees(PVector.angleBetween(v_hand_middle, v_hand_lower));
    
    // Angle entre le milieu de la main et le pouce
    angle_thumb  = degrees(PVector.angleBetween(v_hand_middle, v_thumb));
    
    // Angle entre le milieu de la main et l'index
    angle_index  = degrees(PVector.angleBetween(v_hand_middle, v_index));
    
    // Angle entre le milieu de la main et le majeur
    angle_middle  = degrees(PVector.angleBetween(v_hand_middle, v_middle));
    
    // Angle entre le milieu de la main et l'annulaire
    angle_ring  = degrees(PVector.angleBetween(v_hand_middle, v_ring));
    
    // Angle entre le milieu de la main et l'auriculaire
    angle_pinky  = degrees(PVector.angleBetween(v_hand_middle, v_pinky));
    
    //println(v_angle);
    //println(" ");
    //println( "T : " + angle_thumb + ", I :" + angle_index + ", M : " + angle_middle + ", R : " + angle_ring + ", P : " + angle_pinky);
    
    
    // Séquence de tests
    test = "";
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata)) { test += "Thumb : " + int(angle_thumb); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata)) { test += ", Index : " + int(angle_index); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata)) { test += ", F-Middle : " + int(angle_middle); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata)) { test += ", Ring : " + int(angle_ring); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata)) { test += ", Pinky : " + int(angle_pinky); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_MIDDLE, ndata)) { test += ", H-Middle"; }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_UPPER, ndata)) { test += ", H-Upper : " + int(angle_hand_upper); }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_UPPER, ndata)) { test += ", H-Lower : " + int(angle_hand_lower); }
    
    distance = sqrt(sq(HAND_UPPER[0] - HAND_MIDDLE[0]) + sq(HAND_UPPER[1] - HAND_MIDDLE[1]));
    test += ", Dist : " + distance;
    
    println(test);
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du A
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // reconnaissance du A (avec le pouce)
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
    {
      if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
          {
            if (angle_thumb >= 0 && angle_thumb <= 20)
            {
              println("A");
              letters[0] = true;
            }
            // Reconnaissance du D
            else if (angle_thumb >= 160 && angle_thumb <= 175 &&
                     distance > 15)
            {
              println("D");
              letters[3] = true;
            }
          }
    }
    
    // reconnaissance du A (avec Index)
    else if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata))
    {
      if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
          {
            if (angle_index >= 0 && angle_index <= 20)
            {
              println("A");
              letters[0] = true;
            }
            // Reconnaissance du D
            else if (angle_index >= 160 && angle_index <= 175 &&
                     distance > 15)
            {
              println("D");
              letters[3] = true;
            }
          }
    }
    
    // reconnaissance du A (avec le Pinky)
    else if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
    {
      if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
          {
            if (angle_pinky >= 0 && angle_pinky <= 20)
            {
              println("A");
              letters[0] = true;
            }
            // Reconnaissance du D
            else if (angle_pinky >= 160 && angle_pinky <= 175 &&
                     distance > 15)
            {
              println("D");
              letters[3] = true;
            }
          }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du B
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // On vérifie que tous les doigts sont bien "fermés"
    /*if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))*/
    if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
    {
      if ((angle_hand_upper >= 100 && angle_hand_upper <= 130) &&
          (angle_hand_lower >= 40 && angle_hand_lower <= 80) &&
           distance > 25)
          {
            println("B");
            letters[1] = true;
          }
      // Reconnaissance du E
      else if ((angle_hand_upper >= 50 && angle_hand_upper <= 110) &&
          (angle_hand_lower >= 125 && angle_hand_lower <= 175)&&
           distance < 15)
          {
            println("E");
            letters[4] = true;
          }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du C
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // reconnaissance du C (avec le pouce et l'Index)
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata) &&
        pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata))
    {
      if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata))
          {
            if ((angle_thumb >= 115 && angle_thumb <= 145) &&
                (angle_index >= 25 && angle_index <= 55))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_thumb >= 25 && angle_thumb <= 55) &&
                (angle_index >= 105 && angle_index <= 135))
                {
                  println("C");
                  letters[2] = true;
                }
          }
    }
    // reconnaissance du C (avec le pouce et Finger Middle)
    else if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata) &&
             pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata))
    {
      if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata) &&
          !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata))
          {
            if ((angle_thumb >= 115 && angle_thumb <= 145) &&
                (angle_middle >= 25 && angle_middle <= 55))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_thumb >= 25 && angle_thumb <= 55) &&
                (angle_middle >= 105 && angle_middle <= 135))
                {
                  println("C");
                  letters[2] = true;
                }
          }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du D / voir la partie réservée à la lettre A
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du E / voir la lettre B
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // reconnaissance du F
    // reconnaissance du G
    // reconnaissance du H
    // reconnaissance du I
    // reconnaissance du J
    // reconnaissance du K
    // reconnaissance du L
    // reconnaissance du M
    // reconnaissance du N
    // reconnaissance du O
    // reconnaissance du P
    // reconnaissance du Q
    // reconnaissance du R
    // reconnaissance du S
    // reconnaissance du T
    // reconnaissance du U
    // reconnaissance du V
    // reconnaissance du W
    // reconnaissance du X
    // reconnaissance du Y
    // reconnaissance du Z
    
  }

}
