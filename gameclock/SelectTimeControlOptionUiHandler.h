
#ifndef __SelectTimeControlOptionUiHandler_h__
#define __SelectTimeControlOptionUiHandler_h__

#include <avr/pgmspace.h>

#include "UiHandler.h"
#include "GameClock.h"
#include "GameClockLcd.h"
#include "GameUiHandler.h"
#include "GameButtonGestures.h"

extern GameButtonGestures buttonGestures;
extern GameClockLcd lcd2;

extern GameClock gameClock;

extern GameUiHandler gameUiHandler;
extern UiHandler *currentUiHandler;

const prog_char selectTimeControlOptionUiHandlerBack[] PROGMEM = "^ back ^";

class SelectTimeControlOptionUiHandler : public UiHandler {
  
  UiHandler *previusHandler;
  TimeControlUi *timeControlUi;
  int16_t currentOption;
  
public:

  SelectTimeControlOptionUiHandler() {
    timeControlUi = NULL;
    currentOption = 0;
  }
  
  virtual ~SelectTimeControlOptionUiHandler() {
  }

  virtual void tick(Clock *clock) {
    buttonGestures.tick( clock );
    
    if( buttonGestures.wasButtonTwoPressed() ) {
      if( isBackOption() ) {
        currentUiHandler = previusHandler;
      } else {
        gameClock.setup( clock, timeControlUi->create( currentOption ) );
        gameUiHandler.setTimeControlUi( timeControlUi );
        currentUiHandler = &gameUiHandler;
      }
      beep();
      
      return;
    }

    if( buttonGestures.wasButtonOnePressed() ) {
      if( isBackOption() ) {
        currentOption = 0;
      } else {
        currentOption++;
      }
      beep();
    }
  }
  
  virtual void render(Clock *clock){
    lcd2.beginRender( clock );
    
    if( isBackOption() ) {
      lcd2.printBottomCenter( selectTimeControlOptionUiHandlerBack );
    } else {
      lcd2.printWholeScreen( timeControlUi->getOption( currentOption ) );
    }
    
    lcd2.endRender();
  }
  
  void setTimeControlUi(TimeControlUi *timeControlUi) {
    if( this->timeControlUi != timeControlUi ) {
      currentOption = 0;
    }
    this->timeControlUi = timeControlUi;
  }

  void wire(UiHandler *previusHandler) {
    this->previusHandler = previusHandler;
  }
  
private:

  bool isBackOption() {
    return currentOption == timeControlUi->getNumberOfOptions();
  }

};

#endif
