//
//  Joystick.m
//  cocosgame
//
//  Created by Joey on 12/7/12.
//
//

#import "JoystickClass.h"
#import <math.h>
#define pi 3.1415926
#import "GameLayer.h"
#import "NinjaLayer.h"

/*DIRECTION8 KEY
 0 = none
 1 = right
 2 = up right
 3 = up
 4 = up left
 5 = left
 6 = down left
 7 = down
 8 = down right
 */

@implementation JoystickClass

-(void) moveJoystick: (float) xLocation withY:(float)yLocation{
    
    float relativePosX = xLocation - xInitPosition;
    float relativePosY = yLocation - yInitPosition;
    
    //to compute angle and magnitude
    float angle = atanf(relativePosY/relativePosX);
    if (relativePosX<0){
        angle+=pi;
    }
    if (angle<0){
        angle+=(2*pi);
    }
    
    
    
    //to set position
    direction8=0;
    if ((angle>=((15*pi)/8)) || ((angle)<(pi/8))){
        direction8 = 1;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((pi)/8)) && ((angle)<((3*pi)/8))){
        direction8 = 2;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((3*pi)/8)) && ((angle)<((5*pi)/8))){
        direction8 = 3;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((5*pi)/8)) && ((angle)<((7*pi)/8))){
        direction8 = 4;
        xPosition = xLocation;
        yPosition = yLocation;
        
    }
    if ((angle>=((7*pi)/8)) && ((angle)<((9*pi)/8))){
        direction8 = 5;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((9*pi)/8)) && ((angle)<((11*pi)/8))){
        direction8 = 6;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((11*pi)/8)) && ((angle)<((13*pi)/8))){
        direction8 = 7;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    if ((angle>=((13*pi)/8)) && ((angle)<((15*pi)/8))){
        direction8 = 8;
        xPosition = xLocation;
        yPosition = yLocation;
    }
    
    float magnitude = sqrtf(powf(relativePosX, 2.0) + powf(relativePosY, 2.0));
    if (magnitude<27.0){
        direction8=0;
    }
    
}


-(void) touchEnded{
    direction8 = 0;
    direction = '0';
}

-(void) joystickDirection{
    if ((direction8==1) || (direction8==2) || (direction8==8)){
        direction = 'R';
    }
    else if ((direction8==4) || (direction8==5) || (direction8==6)){
        direction = 'L';
    }
    else direction = '0';
}

-(void) setXPos:(float)XValue withYPos:(float)YValue{
    xInitPosition = XValue;
    xPosition = XValue;
    yInitPosition = YValue;
    yPosition = YValue;
    direction = '0';
}

-(void) restorePosition{
    xPosition = xInitPosition;
    yPosition = yInitPosition;
}

-(int) getdirection8{
    return direction8;
}

@end
