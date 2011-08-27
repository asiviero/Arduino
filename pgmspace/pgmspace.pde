
#include <avr/pgmspace.h>

#include <MemoryFree.h>

const prog_char option1[] PROGMEM = "KGS MEDIUM           25m +5(30s)";
const prog_char option2[] PROGMEM = "KGS FAST             10m +5(20s)";

const prog_char *table[] PROGMEM = {
  option1,
  option2
};

const prog_char *getString(uint8_t option) {
  //Serial.println( "Option: " );
  //Serial.println( ( int )option );
  if( option == 0 ) {
    return table[ 0 ];
  } else {
    return table[ 1 ];
  }
  //return table[ option ];
}

void printOption(const prog_char *option) {
  uint8_t buffer[32];
  memcpy_P( buffer, option, 32 );
  
  for(int i = 0; i < 16; ++i) {
    Serial.print( ( char )buffer[i] );
  }
  Serial.println();
  for(int i = 0; i < 16; ++i) {
    Serial.print( buffer[i+16] );
  }
  Serial.println();
}

void setup() {
  Serial.begin( 9600 );
  
  printOption( getString( 0 ) );
  printOption( getString( 1 ) );
  Serial.print("freeMemory=");Serial.println(freeMemory());
}


void loop() { 
  int status = digitalRead( 7 );
  printOption( getString( status ) );
  delay( 500 );
}

