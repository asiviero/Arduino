
#ifndef __MpcMusicPlayer_h__
#define __MpcMusicPlayer_h__

#include "MpcBase.h"
#include "Buzzer.h"

class MpcMusicPlayer {
  
  Buzzer *buzzer;
  MpcMusic *music;
  uint8_t currentBeat;
  bool isPlaying;
 
  uint32_t beatBeginTime;
  
public:

  MpcMusicPlayer(Buzzer *buzzer) {
    this->buzzer = buzzer;
    isPlaying = false;
  }
  
  virtual ~MpcMusicPlayer() {
  }
  
  void play(MpcMusic *music, uint32_t currentTime) {
    this->music = music;
    currentBeat = 0;
    if( music->numberOfBeats > 0 ) {
      isPlaying = true;
      playCurrentBeat( currentTime );
    }
  }

  void tick(uint32_t currentTime) {
    buzzer->tick();
    if( !isPlaying ) {
      return;
    }
    if( !shouldPlayBeat( currentTime ) ) {
      return;
    }
    playCurrentBeat( currentTime );
  }
  
private:
  
  void playCurrentBeat(uint32_t currentTime) {
    //TODO: verify available buzzers and alocate a tone to each until necessary
    beatBeginTime = currentTime;
    uint16_t frequency = music->getBeatAt( currentBeat )->tones[0].note;
    
    Serial.print( "Playing beat number: " );Serial.print( (int)currentBeat );Serial.print( " Total: " );Serial.print( (int)music->numberOfBeats );Serial.print( " Freq: " );Serial.println( frequency );
    
    if( frequency != 0 ) {
      buzzer->playTone( frequency, music->delay - ( music->delay * 0.1 ) );
    }
    currentBeat++;
    if( currentBeat == 255 || currentBeat == music->numberOfBeats ) {
      currentBeat = 0;
      isPlaying =  false;
    }
  }
  
  bool shouldPlayBeat(uint32_t currentTime) {
    return currentTime - beatBeginTime > music->delay;
  }

};

#endif __MpcMusicPlayer_h__

