//
//  Joystick.h
//  cocosgame
//
//  Created by Joey on 12/7/12.
//
//

#import <Foundation/Foundation.h>

@interface JoystickClass : NSObject


{
@public
     //initial positions
    float xInitPosition;
    float yInitPosition;
   
    //current positions
    float xPosition;
    float yPosition;
    
    int direction8;
    char direction;
    
    
}

@property (assign,readwrite) bool pressed;


//use after initializing
-(void) setXPos: (float) XValue withYPos: (float) YValue;

//sets direction variable
-(void) joystickDirection;

//sets joystick to touch
-(void) moveJoystick: (float) xLocation withY: (float) yLocation;
-(void) touchEnded;


//restores initial position
-(void) restorePosition;

-(int) getdirection8;



@end
