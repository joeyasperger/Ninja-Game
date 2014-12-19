//
//  Timer.m
//  NinjaGame
//
//  Created by Joseph Asperger on 11/4/13.
//
//

#import "Timer.h"

@implementation Timer

-(id) init{
    if (self = [super init]){
        time = 0;
        isActive = false;
        isPaused = false;
    }
    return self;
}

-(void) activateTimer:(double)initialTime{
    time = initialTime;
    isActive = true;
    isPaused = false;
}

-(void) deactivateTimer{
    time = 0;
    isActive = false;
    isPaused = false;
}

-(void) advanceTimer:(ccTime)dt{
    if (isActive && !isPaused){
        time -= dt;
    }
}

-(bool) isActive{
    return isActive;
}

-(double) timeRemaining{
    return time;
}

-(bool) stillRunning{
    if (isActive && !isPaused && (time > 0)){
        return true;
    }
    return false;
}

-(bool) expired{
    if (isActive && time <= 0){
        return true;
    }
    return false;
}

-(void) pauseTimer{
    isPaused = true;
}

-(void) resumeTimer{
    isPaused = false;
}

-(bool) isPaused{
    return isPaused;
}


@end
