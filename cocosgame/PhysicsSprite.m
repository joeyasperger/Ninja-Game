//
//  PhysicsSprite.m
//  cocosgame
//
//  Created by Joey on 1/23/13.
//
//

#import "PhysicsSprite.h"


@implementation PhysicsSprite


@synthesize rect = _rect;
@synthesize nextRect = _nextRect;
@synthesize nextYVal = _nextYVal;
@synthesize nextXVal = _nextXVal;
@synthesize yVelocity = _yVelocity;
@synthesize xVelocity = _xVelocity;


-(id) init{
    if ( (self = [super init]) ){
        rectIsSet = NO;
    }
    return self;
}

//NEED TO DEAL WITH PREVIOUS RECT AND CHANGING RECT HEIGHT/WIDTH


-(id) makeContinuousAction:(NSString *)animationName withNumFrames:(int)numFrames andFrameDuration:(float)frameDuration{
    NSMutableArray *frameList = [NSMutableArray array];
    for (int x = 1; (x<(numFrames + 1)); ++x){
        [frameList addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%04d.png", animationName,x]]];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frameList delay:frameDuration];
    CCAction *action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    return action;
}

-(id) makeFiniteAction:(NSString *)animationName withNumFrames:(int)numFrames andFrameDuration:(float)frameDuration{
    NSMutableArray *frameList = [NSMutableArray array];
    for (int x = 1; (x<(numFrames + 1)); ++x){
        [frameList addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%04d.png", animationName,x]]];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frameList delay:frameDuration];
    CCAction *action = [CCAnimate actionWithAnimation:animation];
    return action;
}

-(id) makeIdleAction:(NSString *)animationName{
    NSMutableArray *frameList = [NSMutableArray array];
    [frameList addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animationName]];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frameList delay:1.0f];
    CCAction *action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    return action;
}



-(void) setRectHeight:(float)height withWidth:(float)width{
    self.rect = CGRectMake(self.position.x - (width/2), self.position.y - (height/2), width, height);
    self.nextRect = self.rect;
    self.nextXVal = self.position.x;
    self.nextYVal = self.position.y;
    
    rectIsSet = YES;
    
}

-(void) setRectFromBoundingBox{
    self.rect = CGRectMake(self.position.x - (self.boundingBox.size.width/2), self.position.y - (self.boundingBox.size.height/2), self.boundingBox.size.width, self.boundingBox.size.height);
    self.nextRect = self.rect;
    self.nextXVal = self.position.x;
    self.nextYVal = self.position.y;
    rectIsSet = true;
}

-(void) setRectHeight:(float)height withWidth:(float)width withXOffset:(float)xOffset andYOffset:(float)yOffset{
    self.rect = CGRectMake((self.position.x - (width/2) + xOffset), (self.position.y - (height/2) + yOffset), width, height);
    rectOffsetX = xOffset;
    rectOffsetY = yOffset;
    self.nextRect = self.rect;
    self.nextXVal = self.position.x;
    self.nextYVal = self.position.y;
    
    
    rectIsSet = YES;
}

-(void) resetNextRectY:(float)yPos{
    self.nextRect = CGRectMake((self.nextXVal - (self.nextRect.size.width/2) + rectOffsetX), (yPos - (self.nextRect.size.height/2) + rectOffsetY), self.nextRect.size.width, self.nextRect.size.height);
    self.nextYVal = yPos;
}

-(void) resetNextRectBottom:(float)bottom{
    
}

-(void) moveSprite:(float)xDistance withY:(float)yDistance{
    self.nextXVal = self.nextXVal + xDistance;
    self.nextYVal = self.nextYVal + yDistance;
    self.nextRect = CGRectOffset(self.nextRect, xDistance, yDistance);
}


-(void) drawRect{
    if (rectIsSet){
        CGPoint vertices[4] = {
            ccp(self.rect.origin.x, self.rect.origin.y),
            ccp((self.rect.origin.x+self.rect.size.width), self.rect.origin.y),
            ccp((self.rect.origin.x+self.rect.size.width), (self.rect.origin.y+self.rect.size.height)),
            ccp(self.rect.origin.x, (self.rect.origin.y+self.rect.size.height)),
        };
        
        ccDrawPoly(vertices, 4, YES);
    }
}

-(BOOL) testCollision:(CGRect) spriteRect{
    //spriteRect is rect of other sprite
    if (CGRectIntersectsRect(self.rect, spriteRect)){
        return YES;
    }
    return NO;
}

-(void) finalMove{
    self.position = ccp(self.nextXVal, self.nextYVal);
    self.rect = self.nextRect;
}

-(void) moveSpriteWithScreen:(float)xSpeed withYSpeed:(float)ySpeed{
    self.position = ccp((self.position.x + xSpeed), (self.position.y + ySpeed));
    self.rect = CGRectOffset(self.rect, xSpeed, ySpeed);
    self.nextRect = CGRectOffset(self.nextRect, xSpeed, ySpeed);
    self.nextXVal += xSpeed;
    self.nextYVal += ySpeed;
}

//test after collision is found
//-(int) getSideRelativeToRect


/*
-(void) draw{
#if Draw_Bounds
    [self drawRect:rect];
    
#endif
    [super draw];
}*/

@end
