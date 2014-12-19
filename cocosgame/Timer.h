//
//  Timer.h
//  NinjaGame
//
//  Created by Joseph Asperger on 11/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Timer : NSObject
{
    double time;
    bool isActive;
    bool isPaused;
}

//activates timer and starts counting down
-(void) activateTimer:(double) initialTime;

//deactivates timer. Cannot resume
-(void) deactivateTimer;

//to be called each frame while timer is active;
-(void) advanceTimer:(ccTime) dt;

//pauses and resumes timer without deactivating
-(void) resumeTimer;
-(void) pauseTimer;

//for getting info on timer
-(bool) isActive;  //true if timer has been actived
-(bool) expired; //true if timer has reached zero
-(bool) isPaused; //true if timer is paused
-(bool) stillRunning; //not exact opposite of expired
-(double) timeRemaining;


@end
