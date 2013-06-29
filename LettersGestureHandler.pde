class LettersGestureHandler {

  public boolean[] letters = new boolean[26]; // les lettres de l'alphabet, reconnues "true", ou pas "false"
  
  // les positions x et y des doigts, du milieu de la main, du haut de la main, du bas de la main
  private float[] HAND_MIDDLE = new float[2], HAND_UPPER = new float[2], HAND_LOWER = new float[2],
                  FINGER_THUMB = new float[2], FINGER_INDEX = new float[2],
                  FINGER_MIDDLE = new float[2], FINGER_RING = new float[2], FINGER_PINKY = new float[2];
                  
  public boolean is_hand_middle, is_hand_upper, is_hand_lower, is_thumb, is_index, is_middle, is_ring, is_pinky;
  public float angle_thumb, angle_index, angle_middle, angle_ring, angle_pinky, angle_hand_upper, angle_hand_lower;
  public PVector v_hand_middle, v_hand_upper, v_hand_lower, v_thumb, v_index, v_middle, v_ring, v_pinky;
  public String test = "";
  public float distance;
  
  public void OnGesture() {
    
    for (int i=0, c=letters.length; i<c; i++)
    {
      letters[i] = false; // appel de la fonction = on réinitialise tout
    }
    
    is_hand_middle = false;
    is_hand_upper = false;
    is_hand_lower = false;
    is_thumb = false;
    is_index = false;
    is_middle = false;
    is_ring = false;
    is_pinky = false;
    
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
      is_hand_middle = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_UPPER, ndata))
    {
      HAND_UPPER[0] = ndata.positionImage.x;
      HAND_UPPER[1] = ndata.positionImage.y;
      is_hand_upper = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_LOWER, ndata))
    {
      HAND_LOWER[0] = ndata.positionImage.x;
      HAND_LOWER[1] = ndata.positionImage.y;
      is_hand_lower = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
    {
      FINGER_THUMB[0] = ndata.positionImage.x;
      FINGER_THUMB[1] = ndata.positionImage.y;
      is_thumb = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata))
    {
      FINGER_INDEX[0] = ndata.positionImage.x;
      FINGER_INDEX[1] = ndata.positionImage.y;
      is_index = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata))
    {
      FINGER_MIDDLE[0] = ndata.positionImage.x;
      FINGER_MIDDLE[1] = ndata.positionImage.y;
      is_middle = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata))
    {
      FINGER_RING[0] = ndata.positionImage.x;
      FINGER_RING[1] = ndata.positionImage.y;
      is_ring = true;
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
    {
      FINGER_PINKY[0] = ndata.positionImage.x;
      FINGER_PINKY[1] = ndata.positionImage.y;
      is_pinky = true;
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // puis deuxième étape : calculer les angles entre à partir des positions pour reconnaitre les signes
    //
    // et mettre à "true les signes reconnus --> i.e. "letters[0] = true;" utiliser PVector
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // position de v_hand_middle
    if (is_hand_middle) { v_hand_middle = new PVector(HAND_MIDDLE[0], HAND_MIDDLE[1]); }
    
    // position de v_hand_upper
    if (is_hand_upper) { v_hand_upper = new PVector(HAND_UPPER[0]-HAND_MIDDLE[0], HAND_UPPER[1]-HAND_MIDDLE[1]); }
    
    // position de v_hand_lower
    if (is_hand_lower) { v_hand_lower = new PVector(HAND_LOWER[0]-HAND_MIDDLE[0], HAND_LOWER[1]-HAND_MIDDLE[1]); }
    
    // direction de v_thumb par rapport à v_hand_middle
    if (is_thumb) { v_thumb = new PVector(FINGER_THUMB[0]-HAND_MIDDLE[0], FINGER_THUMB[1]-HAND_MIDDLE[1]); }
    
    // direction de v_index par rapport à v_hand_middle
    if (is_index) { v_index = new PVector(FINGER_INDEX[0]-HAND_MIDDLE[0], FINGER_INDEX[1]-HAND_MIDDLE[1]); }
    
    // direction de v_middle par rapport à v_hand_middle
    if (is_middle) { v_middle = new PVector(FINGER_MIDDLE[0]-HAND_MIDDLE[0], FINGER_MIDDLE[1]-HAND_MIDDLE[1]); }
    
    // direction de v_ring par rapport à v_hand_middle
    if (is_ring) { v_ring = new PVector(FINGER_RING[0]-HAND_MIDDLE[0], FINGER_RING[1]-HAND_MIDDLE[1]); }
    
    // direction de v_pinky par rapport à v_hand_middle
    if (is_pinky) { v_pinky = new PVector(FINGER_PINKY[0]-HAND_MIDDLE[0], FINGER_PINKY[1]-HAND_MIDDLE[1]); }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Calcul des angles
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Angle entre le milieu de la main et le haut de la main
    if (is_hand_upper) { angle_hand_upper  = degrees(PVector.angleBetween(v_hand_middle, v_hand_upper)); }
    
    // Angle entre le milieu de la main et le bas de la main
    if (is_hand_lower) { angle_hand_lower  = degrees(PVector.angleBetween(v_hand_middle, v_hand_lower)); }
    
    // Angle entre le milieu de la main et le pouce
    if (is_thumb) { angle_thumb  = degrees(PVector.angleBetween(v_hand_middle, v_thumb)); }
    
    // Angle entre le milieu de la main et l'index
    if (is_index) { angle_index  = degrees(PVector.angleBetween(v_hand_middle, v_index)); }
    
    // Angle entre le milieu de la main et le majeur
    if (is_middle) { angle_middle  = degrees(PVector.angleBetween(v_hand_middle, v_middle)); }
    
    // Angle entre le milieu de la main et l'annulaire
    if (is_ring) { angle_ring  = degrees(PVector.angleBetween(v_hand_middle, v_ring)); }
    
    // Angle entre le milieu de la main et l'auriculaire
    if (is_pinky) { angle_pinky  = degrees(PVector.angleBetween(v_hand_middle, v_pinky)); }
    
    //println(v_angle);
    //println(" ");
    //println( "T : " + angle_thumb + ", I :" + angle_index + ", M : " + angle_middle + ", R : " + angle_ring + ", P : " + angle_pinky);
    
    
    // Séquence de tests
    test = "";
    if (is_thumb) { test += "Thumb : " + int(angle_thumb); }
    if (is_index) { test += ", Index : " + int(angle_index); }
    if (is_middle) { test += ", F-Middle : " + int(angle_middle); }
    if (is_ring) { test += ", Ring : " + int(angle_ring); }
    if (is_pinky) { test += ", Pinky : " + int(angle_pinky); }
    if (is_hand_middle) { test += ", H-Middle"; }
    if (is_hand_upper) { test += ", H-Upper : " + int(angle_hand_upper); }
    if (is_hand_lower) { test += ", H-Lower : " + int(angle_hand_lower); }
    
    distance = sqrt(sq(HAND_UPPER[0] - HAND_MIDDLE[0]) + sq(HAND_UPPER[1] - HAND_MIDDLE[1]));
    test += ", Dist : " + distance;
    
    println(test);
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du H
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if (is_thumb && is_index && is_middle)
    {
      if (angle_thumb >= 85 && angle_thumb >= 95 && angle_index >= 100 && angle_index <=110 &&
          angle_middle >= 100 && angle_middle >= 110)
          {
            println("H");
            letters[7] = true;
          }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du A
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // reconnaissance du A (avec le pouce)
    if (is_thumb)
    {
      if (!is_index && !is_middle && !is_ring && !is_pinky) {
            if (angle_thumb >= 0 && angle_thumb <= 40 && distance < 10) {
              println("A");
              letters[0] = true;
            }
            //Reconnaissance du B
            else if (angle_thumb >= 70 && angle_thumb <= 100 &&
                     distance < 10) {
              println("B");
              letters[1] = true;
            }
            // Reconnaissance du B
            /*else if (angle_thumb >= 115 && angle_thumb <= 145 &&
                     distance > 20) {
              println("B");
              letters[1] = true;
            }*/
            // Reconnaissance du G
            else if (angle_thumb >= 120 && angle_thumb <= 150 &&
                     distance < 5) {
              println("G");
              letters[6] = true;
            }
            // Reconnaissance du D
            else if (angle_thumb >= 145 && angle_thumb <= 175 &&
                     distance > 15) {
              println("D");
              letters[3] = true;
            }
            // Reconnaissance du I
            else if (angle_thumb >= 145 && angle_thumb <= 175 &&
                     distance <= 15) {
              println("I");
              letters[8] = true;
            }
          }
    }
    
    // reconnaissance du A (avec Index)
    else if (is_index)
    {
      if (!is_pinky &&
          !is_middle &&
          !is_ring &&
          !is_thumb)
          {
            if (angle_index >= 0 && angle_index <= 45)
            {
              println("A");
              letters[0] = true;
            }
            // Reconnaissance du B
            else if (angle_index >= 115 && angle_index <= 145 &&
                     distance > 15)
            {
              println("B");
              letters[1] = true;
            }
            // Reconnaissance du G
            else if (angle_index >= 110 && angle_index <= 140 &&
                     distance < 5)
            {
              println("G");
              letters[6] = true;
            }
            // Reconnaissance du D
            else if (angle_index >= 145 && angle_index <= 175 &&
                     distance > 20)
            {
              println("D");
              letters[3] = true;
            }
          }
    }
    
    // reconnaissance du A (avec le Pinky)
    else if (is_pinky)
    {
      if (!is_index &&
          !is_middle &&
          !is_ring &&
          !is_thumb)
          {
            if (angle_pinky >= 0 && angle_pinky <= 20)
            {
              println("A");
              letters[0] = true;
            }
            // Reconnaissance du D
            /*else if (angle_pinky >= 155 && angle_pinky <= 175 &&
                     distance > 15)
            {
              println("D");
              letters[3] = true;
            }*/
          }
    }
  else if (is_ring)
      {
        if (!is_index &&
            !is_middle &&
            !is_pinky &&
            !is_thumb)
            {
              // Reconnaissance du A
              if (angle_ring >= 20 && angle_ring <= 40)
              {
                println("A");
                letters[0] = true;
              }
              
              // Reconnaissance du B
              else if (angle_ring >= 105 && angle_ring <= 135 && distance > 20)
              {
                println("B");
                letters[1] = true;
              }
              // Reconnaissance du D
              else if (angle_ring >= 135 && angle_ring <= 165)
              {
                println("D");
                letters[3] = true;
              }
              // Reconnaissance du G
              else if (angle_ring >= 110 && angle_ring <= 135 && distance <= 20)
              {
                println("G");
                letters[6] = true;
              }
            }
      }
      // reconnaissance du F (avec le MIDDLE)
      else if (is_middle)
      {
        if (!is_index &&
            !is_ring &&
            !is_pinky &&
            !is_thumb)
            {
              // Reconnaissance du A
              if (angle_middle >= 0 && angle_middle <= 20)
              {
                println("A");
                letters[0] = true;
              }
              // Reconnaissance du F / G
              else if (angle_middle >= 90 && angle_middle <= 130)
              {
                println("F G ");
                letters[5] = true;
                letters[6] = true;
              }
              // Reconnaissance du D
              else if (angle_middle >= 130 && angle_middle <= 150)
              {
                println("D");
                letters[3] = true;
              }
            }
      }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du E
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // On vérifie que tous les doigts sont bien "fermés"
    if (!is_thumb &&
        !is_index &&
        !is_middle &&
        !is_ring &&
        !is_pinky)
    {
      if ((angle_hand_upper >= 70 && angle_hand_upper <= 110) &&
          (angle_hand_lower >= 130 && angle_hand_lower <= 160) &&
           distance < 10)
          {
            println("E");
            letters[4] = true;
          }
      // Reconnaissance du F
      else if (((angle_hand_upper >= 150 && angle_hand_upper <= 180) &&
                (angle_hand_lower >= 130 && angle_hand_lower <= 160)&&
                 distance < 20) ||
               ((angle_hand_upper >= 30 && angle_hand_upper <= 50) &&
                (angle_hand_lower >= 120 && angle_hand_lower <= 150)&&
                 distance < 20)
                )
          {
            println("F");
            letters[5] = true;
          }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // pouce et l'Index
    else if (is_thumb && is_index)
    {
      if (!is_pinky &&
          !is_middle &&
          !is_ring)
          {
            if ((angle_thumb >= 35 && angle_thumb <= 65) &&
                (angle_index >= 90 && angle_index <= 125))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_thumb >= 120 && angle_thumb <= 135) &&
                (angle_index >= 10 && angle_index <= 48))
                {
                  println("C");
                  letters[2] = true;
                }
            // Reconnaissance H
            else if ((angle_thumb >= 55 && angle_thumb <= 65) &&
                     (angle_index >= 130 && angle_index <= 150))
                {
                  println("H");
                  letters[7] = true;
                }
            // Reconnaissance H
            /*else if ((angle_thumb >= 140 && angle_thumb <= 170) &&
                     (angle_index >= 40 && angle_index <= 70) &&
                      distance > 15)
                {
                  println("H");
                  letters[7] = true;
                }*/
          }
    }
    //  pouce et Finger Middle
    else if (is_thumb && is_middle)
    {
      if (!is_pinky &&
          !is_index &&
          !is_ring)
          {
            if ((angle_thumb >= 115 && angle_thumb <= 145) &&
                (angle_middle >= 25 && angle_middle <= 55))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_thumb >= 30 && angle_thumb <= 60) &&
                (angle_middle >= 130 && angle_middle <= 160))
                {
                  println("H");
                  letters[7] = true;
                }
          }
    }
    // INDEX et Finger Middle
    else if (is_index && is_middle)
    {
      if (!is_pinky &&
          !is_ring &&
          !is_thumb)
          {
            if ((angle_index >= 115 && angle_index <= 145) &&
                (angle_middle >= 25 && angle_middle <= 55))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_index >= 145 && angle_index <= 155) &&
                (angle_middle >= 30 && angle_middle <= 50))
                {
                  println("F");
                  letters[5] = true;
                }
            // Reconnaissance du H
            else if ((angle_index >= 115 && angle_index <= 130) &&
                (angle_middle >= 70 && angle_middle <= 95))
                {
                  println("H");
                  letters[7] = true;
                }
          }
    }
    // pouce et PINKY
    else if (is_thumb && is_pinky)
    {
      if (!is_middle &&
          !is_index &&
          !is_ring)
          {
            if ((angle_thumb >= 115 && angle_thumb <= 145) &&
                (angle_pinky >= 25 && angle_pinky <= 55))
                {
                  println("C");
                  letters[2] = true;
                }
          }
    }
    
    // reconnaissance du C (avec INDEX et PINKY)
    /*else if (is_index && is_pinky)
    {
      if (!is_middle &&
          !is_thumb &&
          !is_ring)
          {
            if ((angle_index >= 20 && angle_index <= 50) &&
                (angle_pinky >= 125 && angle_pinky <= 160))
                {
                  println("C");
                  letters[2] = true;
                }
          }
    }*/
    
    // INDEX et PINKY
    else if (is_index && is_pinky)
    {
      if (!is_middle &&
          !is_ring &&
          !is_thumb)
          {
            if ((angle_index >= 145 && angle_index <= 180) &&
                (angle_pinky >= 30 && angle_pinky <= 60))
                {
                  println("H");
                  letters[7] = true;
                }
          }
    }
    
    // INDEX et RING
    else if (is_index && is_ring)
    {
      if (!is_middle &&
          !is_pinky &&
          !is_thumb)
          {
            if ((angle_index >= 50 && angle_index <= 65) &&
                (angle_ring >= 110 && angle_ring <= 130))
                {
                  println("C");
                  letters[2] = true;
                }
            else if ((angle_index >= 55 && angle_index <= 70) &&
                (angle_ring >= 125 && angle_ring <= 140))
                {
                  println("H");
                  letters[7] = true;
                }
            else if ((angle_index >= 135 && angle_index <= 145) &&
                (angle_ring >= 55 && angle_ring <= 65))
                {
                  println("H");
                  letters[7] = true;
                }
          }
    }
    
    // MIDDLE & PINKY
    else if (is_middle && is_pinky)
    {
      if (!is_index &&
          !is_ring &&
          !is_thumb)
          {
            if ((angle_middle >= 115 && angle_index <= 145) &&
                (angle_pinky >= 35 && angle_pinky <= 65))
                {
                  println("C");
                  letters[2] = true;
                }
          }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Reconnaissance du I
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
