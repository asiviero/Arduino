
#include <Tone.h>

#include "MpcMusicPlayer.h"
#include "StringInputStream.h"

void debug(const char label[]) {
  Serial.println( label );
}
void debug( char label[], String& text) {
  Serial.print( label );
  Serial.print( ": " );
  Serial.println( text );
}
void debug( char label[], long integer) {
  Serial.print( label );
  Serial.print( ": " );
  Serial.println( integer );
}

int notesTables[][2] = {
  { NOTE_AS3, 0 },  // 0
  { NOTE_B3, 'p' }, // 1   p
  { NOTE_C4, 'o' }, // 2   o
  { NOTE_CS4, 0 },  // 3   
  { NOTE_D4, 'n' }, // 4   n
  { NOTE_DS4, 0 },  // 5   
  { NOTE_E4, 'm' }, // 6   m
  { NOTE_F4, 'l' }, // 7   l
  { NOTE_FS4, 0 },  // 8   
  { NOTE_G4, 'k' }, // 9   k
  { NOTE_GS4, 0 },  //10   
  { NOTE_A4, 'j' }, //11   j
  { NOTE_AS4, 0 },  //12   
  { NOTE_B4, 'i' }, //13   i
  { NOTE_C5, 'h' }, //14   h
  { NOTE_CS5, 0 },  //15   
  { NOTE_D5, 'g' }, //16   g
  { NOTE_DS5, 0 },  //17
  { NOTE_E5, 'f' }, //18   f
  { NOTE_F5, 'e' }, //19   e
  { NOTE_FS5, 0 },  //20   
  { NOTE_G5, 'd' }, //21   d
  { NOTE_GS5, 0 },  //22   
  { NOTE_A5, 'c' }, //23   c
  { NOTE_AS5, 0 },  //24   
  { NOTE_B5, 'b' }, //25   b
  { NOTE_C6, 'a' }, //26   a
  { NOTE_CS6, 0 },  //27   
};

#define REAL_TONES     3
#define MAX_TONES      6
#define MAX_BEATS     150

/*
struct MpcTone {
  //int instrument;
  int note;
  //String noteString;
};

struct MpcBeat {
  //int volume;
  MpcTone tones[REAL_TONES];
};

struct MpcMusic {
  int totalBeats;
  MpcBeat beats[MAX_BEATS];
};
*/

/*
class MpcMusicParser{
    
  String *musicData;
  int pos;
  
  int currentBeat;
  int currentTone;
 
  MpcMusic *mpcMusic;
  
public:

  MpcMusicParser(String *pMusicData, MpcMusic *pMpcMusic) {
    musicData = pMusicData;
    mpcMusic = pMpcMusic;
    pos = 0;
    currentBeat = 0;
  }
  
  void parse() {
    String timeSignature = parseTimeSignature();
    debug( "timeSignature", timeSignature );

    for(int i = 0; i < MAX_BEATS; ++i) {
      parseBeat();
      if( pos >= musicData->length() ) {
        debug( "Quit Loop", i );
        break;
      } 
    }
  }
  
private:

  String parseTimeSignature() {
    int from = pos;
    pos += 3;
    int to = pos;
    pos++; //skip '*' charcater
    return musicData->substring( from, to );
  }
  
  void parseBeat() {
    //debug( "Begin beat Position", pos );
    debug( "Begin beat ", currentBeat );
    if( musicData->charAt( pos ) != ':' ) {
      currentTone = 0;
      for(int i = 0; i < 6; ++i) {
        parseTone();
        currentTone++;
      }
      parseVolume();
    }else {
      debug( "Empty Beat..." );
      pos++;
    }
    debug( "End beat Position", pos );
    currentBeat++;
    mpcMusic->totalBeats++;
  }
  
  void parseTone() {
    int to = musicData->indexOf( '+', pos );
    String toneStr = musicData->substring( pos, to );
    
    //debug( "Tone", toneStr );
    pos = to + 1;
    int instrument = toneStr.charAt(0);
    //mpcMusic->beats[ currentBeat ].tones[ currentTone ].instrument = instrument;
    //debug( "Instrument", mpcMusic->beats[ currentBeat ].tones[ currentTone ].instrument );
    
    String noteString = toneStr.substring( 1 );
    //mpcMusic->beats[ currentBeat ].tones[ currentTone ].noteString = noteString;
    if( currentTone < REAL_TONES ) {
      mpcMusic->beats[ currentBeat ].tones[ currentTone ].note = convertMpcNoteToNoteFrequency( noteString );
    }
    //debug( "NoteString", mpcMusic->beats[ currentBeat ].tones[ currentTone ].noteString );
    //debug( "Note", mpcMusic->beats[ currentBeat ].tones[ currentTone ].noteString );
    Serial.print( "beat: " ); Serial.print( currentBeat );Serial.print( " tone: " ); Serial.print( currentTone );
    Serial.print( "> ToneStr: " ); Serial.print( toneStr ); Serial.print( " NoteString: " ); Serial.print( noteString );
    Serial.print( " Note: " ); Serial.println( mpcMusic->beats[ currentBeat ].tones[ currentTone ].note );

  }
  
  void parseVolume() {
    //debug( "Position", pos );
    int volume = musicData->charAt( pos );
    //mpcMusic->beats[ currentBeat ].volume = volume;
    //debug( "Volume", mpcMusic->beats[ currentBeat ].volume );
    pos += 2;
    //debug( "Pos", pos );
  }
  
  int convertMpcNoteToNoteFrequency(String &mpcNote) {
    int length = mpcNote.length();
    if( length == 0 ) {
      return 0;
    }
    int index = lookUpIndex( mpcNote.charAt( 0 ) );
    if( length == 2 ) {
      index += mpcNote.charAt( 1 ) == '#' ? 1 : -1;
    }
    //return index;
    return notesTables[ index ][ 0 ];
  }
  
  int lookUpIndex(int mpcNote) {
    for(int i = 0; i < 28; ++i) {
      if( notesTables[ i ][1] == mpcNote ) {
        return i;
      }
    }
    return 1;//ERROR
  }

};

*/

/*
MpcMusic music;

//#define BUZZER_COUNT 1
//Buzzer buzzers[BUZZER_COUNT]={Buzzer(3)};
#define BUZZER_COUNT 3
Buzzer buzzers[BUZZER_COUNT]={Buzzer(3),Buzzer(4),Buzzer(5)};
long startTime;
int beat;


void setup() {
  // Open serial communications:
  Serial.begin(9600);
  Serial.println( "-= Sumersoft presents... =-" );
  Serial.println( "-= Mariuino Paint =-" );  

  //String musicData=   "4/4*ef+jm+++++q:ef+jm+++++q::ef+jm+++++q::eh+jo+++++q:ef+jm+++++q::ed+jk+++++q::::ci+ok+bm++++q::::lf+lh+bo++++q::oo+md+++++q:lf+oo+md++++q:le+lh+bo++++q::md+ol+++++q:md+ok+le++++q:ld+lg+++++q::md+ok+++++q:oo+ld+fk++++q:fj+fl+le++++q:fl+fn+bj++++q:fj+fl+bn++++q:fi+fk+++++q:af+oo+mp++++q::bd++++++q:be+oo+++++q:om+ah+mp++++q::bd++++++q:be+ak+om++++q:aj+ol+mp++++q:ah++++++q:ol+bd+++++q:be+oj+ah++++q:mp++++++q:bd++++++q::be+ok+aj++++q:mp+ak+++++q:ok++++++q:ah+bd+ol++++q:be++++++q:ah+mp+om++++q::ad+on+++++q:++++++q:af+ok+++++q:ek++++++q:ej++++++q:ei+ol+ag++++q:+eh+++++q:eg+bj+++++q:ef++++++q:ee+bk+++++q:ef+bn+oo++++q:ak++++++q:ah+if+++++q:ak+bn+oo++++q:eh+bn+om++++q:ak+if+++++q:ah++++++q:ai+ek+om++++q:ol+ej+bn++++q:aj+eh+kl++++q:ah++++++q:eh+ae+oj++++q:bl++++++q:bh+ie+af++++q:bh+ag+++++q:bi+ej+++++q:bn+ek+++++q:od+af+ak++++q:eh++++++q:ae++ak+ai+++q:ee+ok+++++q:ef++++++q:eg++++++q::eh++++++q:oh+bf+++++q::oo++bh++++q:oo++bi++++q::bo+bi+++++q::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%358%358";
  //String mpcMusicData=   "4/4*ef+jm+++++q:ef+jm+++++q::ef+jm+++++q::eh+jo+++++q:ef+jm+++++q::ed+jk+++++q::::ci+ok+bm++++q::::lf+lh+bo++++q::oo+md+++++q:lf+oo+md++++q:le+lh+bo++++q::md+ol+++++q:md+ok+le++++q:ld+lg+++++q::md+ok+++++q:oo+ld+fk++++q:fj+fl+le++++q:fl+fn+bj++++q:fj+fl+bn++++q:fi+fk+++++q:af+oo+mp++++q::bd++++++q:be+oo+++++q:om+ah+mp++++q::bd++++++q:be+ak+om++++q:aj+ol+mp++++q:ah++++++q:ol+bd+++++q:be+oj+ah++++q:mp++++++q:bd++++++q::be+ok+aj++++q:mp+ak+++++q:ok++++++q:ah+bd+ol++++q:be++++++q:ah+mp+om++++q::ad+on+++++q:++++++q:af+ok+++++q:ek++++++q:ej++++++q:ei+ol+ag++++q:+eh+++++q:eg+bj+++++q:ef++++++q:ee+bk+++++q:ef+bn+oo++++q:ak++++++q:ah+if+++++q:ak+bn+oo++++q:eh+bn+om++++q:ak+if+++++q:ah++++++q:ai+ek+om++++q:ol+ej+bn++++q:aj+eh+kl++++q:ah++++++q:eh+ae+oj++++q:bl++++++q:bh+ie+af++++q:bh+ag+++++q:bi+ej+++++q:bn+ek+++++q:od+af+ak++++q:eh++++++q:ae++ak+ai+++q:ee+ok+++++q:ef++++++q:eg++++++q::eh++++++q:oh+bf+++++q::oo++bh++++q:oo++bi++++q::bo+bi+++++q:::::";
  //String mpcMusicData = "4/4*ef+jm+++++q:ef+jm+++++q::ef+jm+++++q::eh+jo+++++q:ef+jm+++++q::ed+jk+++++q::::ci+ok+bm++++q::::lf+lh+bo++++q::oo+md+++++q:lf+oo+md++++q:le+lh+bo++++q::md+ol+++++q:md+ok+le++++q:ld+lg+++++q::md+ok+++++q:oo+ld+fk++++q:fj+fl+le++++q:fl+fn+bj++++q:fj+fl+bn++++q:fi+fk+++++q:af+oo+mp++++q::bd++++++q:be+oo+++++q:om+ah+mp++++q::bd++++++q:be+ak+om++++q:aj+ol+mp++++q:ah++++++q:ol+bd+++++q:be+oj+ah++++q:mp++++++q:bd++++++q::be+ok+aj++++q:mp+ak+++++q:ok++++++q:ah+bd+ol++++q:";
  //mario
  //String mpcMusicData = "4/4*ef+jm+++++q:ef+jm+++++q::ef+jm+++++q::eh+jo+++++q:ef+jm+++++q::ed+jk+++++q::::ci+ok+bm++++q::::lf+lh+bo++++q::oo+md+++++q:lf+oo+md++++q:le+lh+bo++++q::md+ol+++++q:md+ok+le++++q:ld+lg+++++q::md+ok+++++q:oo+ld+fk++++q:fj+fl+le++++q:fl+fn+bj++++q:fj+fl+bn++++q:fi+fk+++++q:af+oo+mp++++q::bd++++++q:be+oo+++++q:om+ah+mp++++q::bd++++++q:be+ak+om++++q:aj+ol+mp++++q:ah++++++q:ol+bd+++++q:be+oj+ah++++q:mp++++++q:bd++++++q::be+ok+aj++++q:";
  //String mpcMusicData = "4/4*ff+om+++++q::gm+mj+++++q::om+fi+++++q::mj++fh++++q::fg+om+++++q::ff+mj+++++q:fg++++++q:fh+om+++++q::fi+mj+++++q::fj+bp+++++q::gj+lf+++++q::fj+bp+++++q::fh+mj+++++q::ff+oj+++++q::lf+mj+++++q::fg+oj+++++q::fh+mj+++++q::fi+om+++++q:++++++q:gm+mj+++++q::om+bp+++++q::fh+gm+++++q::fg+om+++++q:++++++q:mk+gn+++++q::ff+om+++++q::gm+mj+++++q::fh+oj+++++q::lf+mj+++++q:++++++q:fj+om+++++q::mk+li+++++q::fj++bp++++q:";
  //ring mpcMusicData =   "4/4*pj+ph+pf+sj+++o::++++++q::pj+ph+pf++++o::sj++++++m::sl#++++++k::++++++q::pj+pl#+pg++++n::sl#++++++m:++++++q:pm+pk+pi+sm+++o::++++++q:++++++d:pk+pi+pm++++o:++++++q:sl#++++++q:pj++++++n:pk+pi+pg+sk+++p::::pj++++++m::pi+sk+++++n::pj+ph+pf+sj+++o::::pf+pi+ph++++o::pj+sj+++++l::ph+pj+pk+sl+++n::::ph+pj+pl++++m::sl++++++q::pf+pi+pk+sm+++o::::pf+pi+pk+sm+++n::sl#++++++q::pd+pg+pi+sk+++n::::pj++++++o::pi+sk+++++m::pj+ph+pf+pc+sj++o:++++++q:::pi+pf+pc+ph+++o::pj+sj+++++m::pj+pg+pe#+sg+++o::::pj+pg+pe#++++o::sg++++++q::pi+pg+pd+pb+sk++o::::";
  //String mpcMusicData = "4/4*fh++++++q::ff++++++q::fd++++++q::ff++++++q::fh++++++q:++++++q:+ff+++++q:fe++++++q:::ff++++++q::fj++++++q::fh++++++q::ff++++++q::";

  //tetris
  //String mpcMusicData = "4/4*ff+om+++++q::gm+mj+++++q::om+fi+++++q::mj++fh++++q::fg+om+++++q::ff+mj+++++q:fg++++++q:fh+om+++++q::fi+mj+++++q::fj+bp+++++q::gj+lf+++++q::fj+bp+++++q::fh+mj+++++q::ff+oj+++++q::lf+mj+++++q::fg+oj+++++q::fh+mj+++++q::fi+om+++++q:++++++q:gm+mj+++++q::om+bp+++++q::fh+gm+++++q::fg+om+++++q:++++++q:mk+gn+++++q::ff+om+++++q::gm+mj+++++q::fh+oj+++++q::lf+mj+++++q:++++++q:fj+om+++++q::mk+li+++++q::fj++bp++++q:";

  //keyboard cat
  //String mpcMusicData =     "4/4*fh++++++q::ff++++++q::fd++++++q::ff++++++q::fh++++++q::ff++++++q:fd++++++q:::ff++++++q::fj++++++q::fh++++++q::ff++++++q::fh++++++q::fj++++++q:++++++q:fh++++++q:ff++++++q::++++++q:fh++++++q:++++++q:fk++++++q::fi++++++q:fg++++++q:::fi++++++q:fk++++++q:::fi++++++q:fg++++++q:++++++q::fi++++++q::fk++++++q:::fk++++++q:::fk++++++q:fk++++++q::fk++++++q::fk++++++q::fk++++++q::fk++++++q:fh++++++q::ff++++++q::fd++++++q::ff++++++q::fh++++++q::ff++++++q:fd++++++q:::ff++++++q:";
  //String mpcMusicData =   "4/4*fh++++++q::ff++++++q::fd++++++q::ff++++++q::fh++++++q::ff++++++q:fd++++++q:::ff++++++q::fj++++++q::fh++++++q::ff++++++q::fh++++++q::fj++++++q:++++++q:fh++++++q:ff++++++q::++++++q:fh++++++q:++++++q:fk++++++q::fi++++++q:fg++++++q:::fi++++++q:fk++++++q:::fi++++++q:fg++++++q:++++++q::fi++++++q::fk++++++q:::fk++++++q:::fk++++++q:fk++++++q::fk++++++q::fk++++++q::fk++++++q::fk++++++q:fh++++++q::ff++++++q::fd++++++q::ff++++++q::fh++++++q::ff++++++q:fd++++++q:::ff++++++q::fi++++++q::fg++++++q::fe++++++q::fg++++++q:fi++++++q:::fg++++++q:fe++++++q:::fg++++++q::fj++++++q::fh++++++q:ff++++++q:::fh++++++q::fj++++++q::fh++++++q:ff++++++q:::fh++++++q::fk++++++q:fk++++++q:fk++++++q:fk++++++q:fk++++++q:fk++++++q:fk++++++q:fk++++++q:fk++++++q:";
  //mk
  //String mpcMusicData = "4/4*lj++++++q::lj++++++q:++++++q:lh++++++q::+lj+++++q::lg++++++q::lj++++++q::lf++++++q::lg++++++q::lh++++++q::lh++++++q::lf++++++q::lh++++++q::ld++++++q::lh++++++q::lf++++++q::lh++++++q::lk++++++q::lk++++++q::li++++++q::lk++++++q::lh++++++q::lk++++++q::lg++++++q::lh++++++q::ll++++++q::ll++++++q::lj++++++q::ll++++++q::lh++++++q::ll++++++q::lh++++++q::li++++++q::lj++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lj+ok+++++q:ok++++++q:lg++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lg+ok+++++q:ok++++++q:lh++++++q:oj++++++q:lh+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lh+oj+++++q:+oj+++++q:ld+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lk+oj+++++q:oj++++++q:lg+oj+++++q:oj++++++q:lh+oj+++++q:+oj+++++q:ll+oj+++++q:oj++++++q:ll+oj+++++q:oj++++++q:ll+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:ll+oj+++++q:+oj+++++q:lh+oj+++++q:oj++++++q:li+oj+++++q::jj+bp+++++q:++++++q::jj+bp+++++q:::jj+bp+++++q:++++++q:oj++++++q:jj+oj+bp++++q:oj++++++q::jk+oj+bp++++q::jh+ok+bp++++q::jj+oj+bp++++q:::jj+bp+++++q:::jj+bp+++++q::oj++++++q:jj+oj+bp++++q:oj++++++q:++++++q:jk+oj+bp++++q:++++++q:jm+oj+bp++++q:++++++q:jj+oj+bp++++q:::jj+bp+++++q:::jj+bp+++++q::oj++++++q:jj+oj+bp++++q:oj++++++q::jk+oj+bp++++q::jh+ok+bp++++q::jj+oj+bp++++q:::jj+bp+++++q:::jj+bp+++++q::jj+oh+bp++++q:jj+oh+bp++++q:oh++++++q:jj+bp+++++q:jj+og+bp++++q::og++++++q:++++++q:jj+oj+bp++++q:ma++++++q:ma+gh+++++q:jj+ma+++++q:bp+mf+gh++++q:ma++++++q:jj+ma+++++q:ma++++++q:oj+bp+gh++++q:jj+oj+ma++++q:oj+ma+++++q:ma+gh+++++q:jk+oj+bp+mf+++q:ma++++++q:jh+ok+ma+gh+++q:ma+gh+++++q:jj+oj+bp++++q:ma++++++q:ma+gh+++++q:jj+ma+++++q:bp+mf+gh++++q:ma++++++q:jj+ma+++++q:ma++++++q:oj+bp+gh++++q:jj+oj+ma++++q:oj+ma+++++q:ma+gh+++++q:jk+oj+bp+mf+++q:ma++++++q:jm+oj+ma+gh+++q:ma+gh+++++q:jj+oj+bp++++q:ma++++++q:ma+gh+++++q:jj+ma+++++q:bp+mf+gh++++q:ma++++++q:jj+ma+++++q:ma++++++q:oj+bp+gh++++q:jj+oj+ma++++q:oj+ma+++++q:ma+gh+++++q:jk+oj+bp+mf+++q:ma++++++q:jh+ok+ma+gh+++q:ma+gh+++++q:jj+oj+hh++++q:++++++q:++++++q:jj+hh+++++q:++++++q:++++++q:jj+hh+++++q:++++++q:jj+oh+++++q:jj+oh+hi++++q:oh++++++q:jj++++++q:jj+og+++++q:++++++q:og++++++q:++++++q:jj+bp+oj++++q:jf+ma+++++q:ma++++++q:jj+ma+++++q:jh+bp+mf++++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma++++++q:jj+bp+mf+oj+++q:ji;+ma+++++q:jk+ma+ok++++q:ma++++++q:jj+bp+oj++++q:jf+ma+++++q:ma++++++q:jj+ma+++++q:jh+bp+mf++++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma++++++q:jj+bp+mf+oj+++q:ji;+ma+++++q:jk+ma+ok++++q:ma++++++q:jj+bp+oj++++q:jf+ma+++++q:ma++++++q:jj+ma+++++q:jh+bp+mf++++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma++++++q:jj+bp+mf+oj+++q:ji;+ma+++++q:jk+ma+ok++++q:ma++++++q:jj+bp+oj++++q:jf+ma+++++q:ma++++++q:jj+ma+++++q:jh+bp+mf++++q:ma++++++q:jk+ma+++++q:jk+ma+++++q:bp+oh+++++q:jk+ma+oh++++q:jj+ma+oh++++q:ma++++++q:jj+bp+mf+og+hd++q:ma++++++q:og+ma+++++q:ma++++++q:oj+jj+bp++++q:jf+ma+++++q:ma+gh+++++q:jj+ma+++++q:jh+mf+bp+gh+++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+gh++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma+gh+++++q:jj+mf+bp+oj+++q:ji;+ma+++++q:jk+ma+ok+gh+++q:ma+gh+++++q:jj+bp+oj++++q:jf+ma+++++q:ma+gh+++++q:jj+ma+++++q:jh+bp+mf+gh+++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+gh++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma+gh+++++q:jj+bp+mf+oj+++q:ji;+ma+++++q:jk+ma+ok+gh+++q:ma+gh+++++q:jj+bp+oj++++q:jf+ma+++++q:ma+gh+++++q:jj+ma+++++q:jh+mf+bp+gh+++q:ma++++++q:jj+ma+++++q:ji;+ma+++++q:bp+oj+gh++++q:jj+ma+oj++++q:jh+ma+oj++++q:ma+gh+++++q:jj+bp+mf+oj+++q:ji;+ma+++++q:jk+ma+ok+gh+++q:ma+gh+++++q:jj+bp+oj++++q:++++++q:++++++q:++++++q:jj+bp+oj++++q:++++++q:++++++q:++++++q:bp+oj+jj++++q:++++++q:++++++q:++++++q:jj+oj+bp++++q::++++++q::"%550";
  //String mpcMusicData =   "4/4*lj++++++q::lj++++++q:++++++q:lh++++++q::+lj+++++q::lg++++++q::lj++++++q::lf++++++q::lg++++++q::lh++++++q::lh++++++q::lf++++++q::lh++++++q::ld++++++q::lh++++++q::lf++++++q::lh++++++q::lk++++++q::lk++++++q::li++++++q::lk++++++q::lh++++++q::lk++++++q::lg++++++q::lh++++++q::ll++++++q::ll++++++q::lj++++++q::ll++++++q::lh++++++q::ll++++++q::lh++++++q::li++++++q::lj++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lj+ok+++++q:ok++++++q:lg++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lg+ok+++++q:ok++++++q:lh++++++q:oj++++++q:lh+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lh+oj+++++q:+oj+++++q:ld+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lh+oj+++++q:+oj+++++q:lk+oj+++++q:oj++++++q:lk+oj+++++q:oj++++++q:li+oj+++++q:oj++++++q:lk+oj+++++q:+oj+++++q:lh+oj+++++q:oj++++++q:lj+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:ll+oj+++++q:+oj+++++q:lh+oj+++++q:oj++++++q:li+oj+++++q::jj+bp+++++q:++++++q::jj+bp+++++q:::jj+bp+++++q:++++++q:oj++++++q:jj+oj+bp++++q:oj++++++q::jk+oj+bp++++q::jh+ok+bp++++q:";
  String mpcMusicData =   "4/4*lj++++++q::lj++++++q:++++++q:lh++++++q::lj++++++q::lg++++++q::lj++++++q::lf++++++q::lg++++++q::lh++++++q::lh++++++q::lf++++++q::lh++++++q::ld++++++q::lh++++++q::lf++++++q::lh++++++q::lk++++++q::lk++++++q::li++++++q::lk++++++q::lh++++++q::lk++++++q::lg++++++q::lh++++++q::ll++++++q::ll++++++q::lj++++++q::ll++++++q::lh++++++q::ll++++++q::lh++++++q::li++++++q::lj++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lh+oj+++++q:oj++++++q:lj+ok+++++q:ok++++++q:lg++++++q:oj++++++q:lj+oj+++++q:oj++++++q:lf+oj+++++q:oj++++++q:lg+ok+++++q:ok++++++q:lh++++++q:oj++++++q:lh+oj+++++q:";
  
  debug( "Table sizeof: ", sizeof(notesTables) );  
  debug( "MpcMusic sizeof: ", sizeof(MpcMusic) );  
  debug( "Music length: ", mpcMusicData.length() ); 

  //memset(&music,0,sizeof(MpcMusic));

  MpcMusicParser parser( &mpcMusicData, &music );
  parser.parse();
  
  debug( "Beats read", music.totalBeats );  
  
  startTime = millis();
  beat = 0;
  
  //buzzers[ 0 ].playTone( NOTE_A4, 10000 );
}


void loop() {

  for(int i = 0; i < BUZZER_COUNT; ++i) {
    buzzers[ i ].tick();
  }
  //return;
  long currentTime = millis();
  long time = 100;
  
  if( currentTime - startTime < time ) {
    return;
  }
  startTime = currentTime;
  
  if( beat == music.totalBeats ) {
    beat = 0;
    for(int i = 0; i < BUZZER_COUNT; ++i) {
      buzzers[ i ].stopBuzzing();
    }
    delay( 1000 );
  }
  int used = 0;
  for(int t = 0; t < REAL_TONES; ++t) {
    int note = music.beats[ beat ].tones[ t ].note;
    if( note != 0 && used < BUZZER_COUNT ) {
        //buzzers[ used ].stopBuzzing();
        buzzers[ used ].playTone( note, time );
        //Serial.print( " Beat: " );Serial.print( beat );Serial.print( " Tone: " );Serial.print( t );Serial.print( " Note: " );Serial.print( note );Serial.print( " Used: " );Serial.println( used );
        used++;
    }
  }
  beat++;
}

*/

//NOTE_G4

MpcTone tone1, tone2, tone3, tone4, tone5, tone6, tone7, tone8;
MpcBeat beats[8];
MpcMusic music;

Buzzer buzzer(2);
MpcMusicPlayer *musicPlayer;

InputStream *is;

void setup() {
  Serial.begin(9600);
  
  const char *string = "This is a test";
  is = new StringInputStream( string );
  int16_t val;
  do {
    val = is->read();
    Serial.println( (char)val );
    
  }while( val != -1 );
  
  tone1.note=NOTE_C4;
  beats[0].numberOfTones=1;
  beats[0].tones=&tone1;

  tone2.note=NOTE_D4;
  beats[1].numberOfTones=1;
  beats[1].tones=&tone2;
  
  tone3.note=NOTE_E4;
  beats[2].numberOfTones=1;
  beats[2].tones=&tone3;
  
  tone4.note=NOTE_F4;
  beats[3].numberOfTones=1;
  beats[3].tones=&tone4;
  
  tone5.note=NOTE_G4;
  beats[4].numberOfTones=1;
  beats[4].tones=&tone5;
  
  tone6.note=NOTE_A4;
  beats[5].numberOfTones=1;
  beats[5].tones=&tone6;
  
  tone7.note=NOTE_B4;
  beats[6].numberOfTones=1;
  beats[6].tones=&tone7;
  
  tone8.note=NOTE_C5;
  beats[7].numberOfTones=1;
  beats[7].tones=&tone8;
  
  music.delay = 1000;
  music.numberOfBeats=8;
  music.beats = ( MpcBeat* )&beats;
  
  musicPlayer = new MpcMusicPlayer(&buzzer);
  musicPlayer->play( &music, millis() );
}

void loop() {
  musicPlayer->tick( millis() );
}


