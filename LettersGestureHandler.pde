class LettersGestureHandler {

  public boolean[] letters = new boolean[26]; // les lettres de l'alphabet
  
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
      print ("HAND\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_FINGER_THUMB, ndata))
    {
      FINGER_THUMB[0] = ndata.positionImage.x;
      FINGER_THUMB[1] = ndata.positionImage.y;
      print ("FINGER_THUMB\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_FINGER_INDEX, ndata))
    {
      FINGER_INDEX[0] = ndata.positionImage.x;
      FINGER_INDEX[1] = ndata.positionImage.y;
      print ("FINGER_INDEX\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE, ndata))
    {
      FINGER_MIDDLE[0] = ndata.positionImage.x;
      FINGER_MIDDLE[1] = ndata.positionImage.y;
      print ("FINGER_MIDDLE\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_FINGER_RING, ndata))
    {
      FINGER_RING[0] = ndata.positionImage.x;
      FINGER_RING[1] = ndata.positionImage.y;
      print ("FINGER_RING\n");
    }
    if (pp.QueryGeoNode(PXCMGesture.GeoNode.LABEL_FINGER_PINKY, ndata))
    {
      FINGER_PINKY[0] = ndata.positionImage.x;
      FINGER_PINKY[1] = ndata.positionImage.y;
      print ("FINGER_PINKY\n");
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // puis deuxième étape : calculer les angles entre à partir des positions pour reconnaitre les signes
    
    // et mettre à "true les signes reconnus --> i.e. "letters[0] = true;"
  
  }

}