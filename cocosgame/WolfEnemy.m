//
//  WolfEnemy.m
//  NinjaGame
//
//  Created by Joey on 7/17/13.
//
//

#import "WolfEnemy.h"

@implementation WolfEnemy

/*
 ANIMATION KEY
 0 = walk right
 1 = walk left
 */

@synthesize range = _range;
@synthesize patrolSpeed = _patrolSpeed;

-(void) startAI{
    self.disabledTimer = 0;
    self.finiteActionTimer = 0;
    self.maxHealth = 30;
    self.healthLeft = 80;
    self.patrolSpeed = 57;
    [self setRectHeight:70 withWidth:110 withXOffset:0 andYOffset:0];
    [self setupHealthbar];
    
    
}

-(void) nextFrame:(ccTime)dt{

    
    if (self.mode == 'p'){
        if (self.directionLooking == 'r'){
            [self moveSprite:self.patrolSpeed*dt withY:0];
            self.animation = 0;
            if (self.position.x > (self.originalPosition.x + self.range / 2.0)){
                //reached end of range, should turn around
                self.directionLooking = 'l';
                
            }
        }
        if (self.directionLooking == 'l'){
            [self moveSprite:-self.patrolSpeed*dt withY:0];
            self.animation = 1;
            if (self.position.x < (self.originalPosition.x - self.range / 2.0)){
                //reached end of range, should turn around
                self.directionLooking = 'r';
            }
        }
    }
    if (self.animation != self.previousAnimation){
        [self stopAllActions];
        switch (self.animation){
            case 0:
                [self animateWalkRight];
                break;
            case 1:
                [self animateWalkLeft];
                break;
        }
    }
    self.previousAnimation = self.animation;
}

-(void) animateWalkLeft{
    [self runAction:[self makeContinuousAction:@"WolfWalkLeft" withNumFrames:8 andFrameDuration:.09]];
}

-(void) animateWalkRight{
    [self runAction:[self makeContinuousAction:@"WolfWalkRight" withNumFrames:8 andFrameDuration:.09]];
    
}

@end
