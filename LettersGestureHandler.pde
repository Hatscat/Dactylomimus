class LettersGestureHandler {

  public boolean[] letters = new boolean[26]; // les lettres de l'alphabet, reconnues "true", ou pas "false"
  
  private float[] HAND_MIDDLE = new float[2], FINGER_THUMB = new float[2], FINGER_INDEX = new float[2],
    FINGER_MIDDLE = new float[2], FINGER_RING = new float[2], FINGER_PINKY = new float[2]; // les positions x et y des doigts et du milieu de la main
  
  public void OnGesture() {
    
    for (int i=0, c=letters.length; i<c; i++)
    {
      letters[i] = false; // appel de la fonction = on réinitialise tout
    }
    
    PXCMGesture.GeoNode ndata = new PXCMGesture.GeoNode();
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // première étape = trouver les positions des doigts et du centre de la main, si la camera les detectes
    
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_HAND_MIDDLE, ndata))
    {
      HAND_MIDDLE[0] = ndata.positionImage.x;
      HAND_MIDDLE[1] = ndata.positionImage.y;
      //print ("HAND\n");
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
    
    // puis deuxième étape : calculer les angles entre à partir des positions pour reconnaitre les signes
    
    // et mettre à "true les signes reconnus --> i.e. "letters[0] = true;" utiliser PVector
    
    PVector v_hand_middle, v_thumb, v_index, v_middle, v_ring, v_pinky;
    
    // position de v_hand_middle
    v_hand_middle = new PVector(HAND_MIDDLE[0], HAND_MIDDLE[1]);
    v_hand_middle.normalize();
    
    // direction de v_thumb par rapport à v_hand_middle
    v_thumb = new PVector(FINGER_THUMB[0]-HAND_MIDDLE[0], FINGER_THUMB[1]-HAND_MIDDLE[1]);
    v_thumb.normalize();
    
    // direction de v_index par rapport à v_hand_middle
    v_index = new PVector(FINGER_INDEX[0]-HAND_MIDDLE[0], FINGER_INDEX[1]-HAND_MIDDLE[1]);
    v_index.normalize();
    
    // direction de v_middle par rapport à v_hand_middle
    v_middle = new PVector(FINGER_MIDDLE[0]-HAND_MIDDLE[0], FINGER_MIDDLE[1]-HAND_MIDDLE[1]);
    v_middle.normalize();
    
    // direction de v_ring par rapport à v_hand_middle
    v_ring = new PVector(FINGER_RING[0]-HAND_MIDDLE[0], FINGER_RING[1]-HAND_MIDDLE[1]);
    v_ring.normalize();
    
    // direction de v_pinky par rapport à v_hand_middle
    v_pinky = new PVector(FINGER_PINKY[0]-HAND_MIDDLE[0], FINGER_PINKY[1]-HAND_MIDDLE[1]);
    v_pinky.normalize();
    
    // Angle entre le milieu de la main et le pouce
    float angle_thumb  = degrees(PVector.angleBetween(v_hand_middle, v_thumb));
    
    // Angle entre le milieu de la main et l'index
    float angle_index  = degrees(PVector.angleBetween(v_hand_middle, v_index));
    
    // Angle entre le milieu de la main et le majeur
    float angle_middle  = degrees(PVector.angleBetween(v_hand_middle, v_middle));
    
    // Angle entre le milieu de la main et l'annulaire
    float angle_ring  = degrees(PVector.angleBetween(v_hand_middle, v_ring));
    
    // Angle entre le milieu de la main et l'auriculaire
    float angle_pinky  = degrees(PVector.angleBetween(v_hand_middle, v_pinky));
    
    //println(v_angle);
    //println(" ");
    //println( "T : " + angle_thumb + ", I :" + angle_index + ", M : " + angle_middle + ", R : " + angle_ring + ", P : " + angle_pinky);
  
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // reconnaissance du A
    if (!pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata) &&
        !pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata) &&
        angle_thumb >= 0 && angle_thumb <= 45)
    {
      println("A");
      // println(v_angle);
    }
    
    // reconnaissance du B
    if ((angle_thumb >= 140 && angle_thumb <= 160) &&
        (angle_pinky >= 160 && angle_pinky <= 180))
    {
      println("B");
    }
    
  }

}
