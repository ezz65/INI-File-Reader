// example showing how to read text from file.txt

import java.io.*; // !!

public class main
{
public static int countWords(String input) {
    if (input == null || input.isEmpty()) {
      return 0;
    }

    String[] words = input.split("\\s+");
    return words.length;
  }

  
  
  
  public static void main(String[] args) {
    
    
    try { // !!
      BufferedReader f =  new BufferedReader(
        new FileReader(args[0]) );
      String s;
      int numberOfLines = 0;
      int numberOfWords = 0;
      int numberOfCharacters = 0;
      while( (s = f.readLine()) != null ) {

        for(int i = 0; i < s.length(); i++) {    
            if(s.charAt(i) != ' ')    
                numberOfCharacters++;    
        }    
        numberOfLines++;
        numberOfWords+= countWords(s);
        System.out.println(numberOfLines+":"+ s);
        
      }
      System.out.println("SUMMARY: "+numberOfLines+ " lines, "+numberOfWords+" words, "+ numberOfCharacters+" characters");
    }
    catch( Throwable e ) { // !!
      System.out.println( "Read error." );
    }
  }
}


