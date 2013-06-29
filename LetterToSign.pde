class LetterToSign {
  
  public int letterNb;
  public String letter;
  public int x;
  public int y;
  public int speed;
  public boolean isAlive = true;
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  LetterToSign (int letterNb, int speed) {
    
    this.letterNb = letterNb;
    this.speed = speed;
    
  }
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public void Awake () {
    
    switch (this.letterNb) {
      case 0:
        this.letter = "A";
        break;
      case 1:
        this.letter = "B";
        break;
      case 2:
        this.letter = "C";
        break;
      case 3:
        this.letter = "D";
        break;
      case 4:
        this.letter = "E";
        break;
      case 5:
        this.letter = "F";
        break;
      case 6:
        this.letter = "G";
        break;
      case 7:
        this.letter = "H";
        break;
      case 8:
        this.letter = "I";
        break;
      case 9:
        this.letter = "J";
        break;
      case 10:
        this.letter = "K";
        break;
      case 11:
        this.letter = "L";
        break;
      case 12:
        this.letter = "M";
        break;
      case 13:
        this.letter = "N";
        break;
      case 14:
        this.letter = "O";
        break;
      case 15:
        this.letter = "P";
        break;
      case 16:
        this.letter = "Q";
        break;
      case 17:
        this.letter = "R";
        break;
      case 18:
        this.letter = "S";
        break;
      case 19:
        this.letter = "T";
        break;
      case 20:
        this.letter = "U";
        break;
      case 21:
        this.letter = "V";
        break;
      case 22:
        this.letter = "W";
        break;
      case 23:
        this.letter = "X";
        break;
      case 24:
        this.letter = "Y";
        break;
      case 25:
        this.letter = "Z";
        break;
    }
    
  }
  
  public void Move () {
    
  }
  
}
