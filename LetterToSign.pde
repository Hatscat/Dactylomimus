class LetterToSign {
  
  public int letterNb;
  public String letter;
  public int x;
  public int y;
  public int speed;
  private int size;
  private boolean isAwake = false;
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  LetterToSign (int letterNb) {
    
    this.letterNb = letterNb;
    
  }
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public void Awake () {
    
    if (!this.isAwake)
    {
      this.isAwake = true;
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
      
      this.x = int(random(0, width*0.55));
      this.y = 0;
      this.speed = int(random(1, 4));
      
      this.size = int(random(30, 60));
    }
  }
  
  public void Move () {
    
    this.x += random(-1, 2);
    
    this.y += this.speed;

  }
  
  public void Display () {
    textSize(size);
    text(this.letter, this.x, this.y);
  }
  
  
  public boolean Finished () {
   
   if (gest.letters[this.letterNb])
   {
     return true;
   }
   return false;
  }
  
  
}
