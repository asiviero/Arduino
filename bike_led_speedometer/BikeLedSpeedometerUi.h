
#ifndef __BikeLedSpeedometerUi_h__
#define __BikeLedSpeedometerUi_h__

#include "AnalogWritablePin.h"
#include "PulseToSpeedStatus.h"
#include "FxFade.h"
#include "FxFadeOut.h"
#include "FxBlink.h"

extern AnalogWritablePin *pulseFeedbackPin;
extern DigitalWritablePin *deceleratingPin;
extern PulseToSpeedStatus *pulseToSpeedStatus;

extern void watchdog();

class BikeLedSpeedometerUi {
  
  FxFadeOut<4> fxFadeOut;
  FxFade<1> fxFade;
  FxBlink<150> fxBlink;
  
public:

  BikeLedSpeedometerUi(Clock *clock) : fxBlink() {
  }

  void tick(Clock *clock) {    
    PulseToSpeedStatus::Status status = pulseToSpeedStatus->getStatus();
    fxFade.tick( clock );
    fxBlink.tick( clock );
    fxFadeOut.tick( clock );
    
    if( status == PulseToSpeedStatus::AcceleratingOrConstant ) {
      //Serial.println( "MMM" );
      updateAcceleratingOrConstant();
    } else if( status == PulseToSpeedStatus::Decelerating ) {
      updateDecelerating();
    } else if ( status == PulseToSpeedStatus::Stopped ) {
      updateStoped();
    }

    if( pulseToSpeedStatus->pulsedAndClearFlag() ) {
      //Serial.println( clock->currentTime() );
      fxFadeOut.set();
    }
    fxFadeOut.apply( pulseFeedbackPin );
    watchdog();
  }
  
private:

  void updateAcceleratingOrConstant() {
    //fxFadeOut.set();
    deceleratingPin->set( false );
  }

  void updateDecelerating() {
    //pulseFeedbackPin->set( 0 );
    deceleratingPin->set( true );
  }

  void updateStoped() {
    //pulseFeedbackPin->set( 0 );
    fxBlink.apply( deceleratingPin );
  }

};

#endif

