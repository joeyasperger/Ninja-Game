//
//  PhysicsSprite.h
//  cocosgame
//
//  Created by Joey on 1/23/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PhysicsSprite : CCSprite

{
    float rectOffsetX;
    float rectOffsetY;
    BOOL rectIsSet;
    
}


@property (readwrite, assign) CGRect rect;
@property (readwrite, assign) CGRect nextRect;
@property (readwrite, assign) float nextYVal;
@property (readwrite, assign) float nextXVal;
@property (readwrite, assign) float yVelocity;
@property (readwrite, assign) float xVelocity;


//for animations
-(id) makeContinuousAction:(NSString*) animationName withNumFrames:(int)numFrames andFrameDuration:(float)frameDuration;
-(id) makeIdleAction:(NSString*) animationName;
-(id) makeFiniteAction:(NSString*) animationName withNumFrames:(int)numFrames andFrameDuration:(float)frameDuration;


//to create rect
-(void) setRectHeight:(float)height withWidth:(float)width;
-(void) setRectHeight:(float)height withWidth:(float)width withXOffset:(float)xOffset andYOffset:(float)yOffset;
-(void) setRectFromBoundingBox;

//for moving sprite outside other box
-(void) resetNextRectY:(float)yPos;
-(void) resetNextRectBottom:(float)bottom;

//call to move both rect and sprite
-(void) moveSprite:(float)xDistance withY:(float)yDistance;

-(void) drawRect;

//collision functions
-(BOOL) testCollision:(CGRect) spriteRect;

//after collisions are tested, call this to move the sprites to nextrect
-(void) finalMove;

//then call this to update all aspects of sprite's position based on background movement
-(void) moveSpriteWithScreen:(float) xSpeed withYSpeed:(float) ySpeed;


@end
