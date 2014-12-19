//
//  NinjaStarLayer.h
//  cocosgame
//
//  Created by Joey on 1/19/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NinjaStarLayer : CCLayer


{
    float swipeInitX;
    float swipeInitY;
    float prevPosX;
    float prevPosY;
    float timePassed;
    float timePassedSincePrevTouch;
    float angle; //in radians
    
    
    BOOL isSwiping;
    BOOL wasThrown;
    BOOL hasAngle;
   
}

@property (assign,readwrite) CCSpriteBatchNode *ninjaStarBatch;
@property (assign,readwrite) CCLabelTTF *numStarsLabel;
@property (assign,readwrite) int numStars;
@property (assign,readwrite) float starDamage;

-(void) updateLabel;
-(void) nextFrame:(ccTime)dt;

@end

@interface NinjaStar : CCSprite

@property (assign,readwrite) float xVelocity;
@property (assign,readwrite) float yVelocity;
@property (assign,readwrite) CGRect rect;


@end