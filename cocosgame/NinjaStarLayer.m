//
//  NinjaStarLayer.m
//  cocosgame
//
//  Created by Joey on 1/19/13.
//
//

#import "NinjaStarLayer.h"
#import "GameLayer.h"
#import <math.h>
#import "NinjaLayer.h"
#import "Collider.h"
#import "PhysicsSprite.h"
#define pi 3.141592

@implementation NinjaStarLayer

@synthesize ninjaStarBatch = _ninjaStarBatch;

-(id) init
{
    if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        //[self schedule:@selector(nextFrame:)];
        timePassed = 0;
        timePassedSincePrevTouch = 0;
        isSwiping = NO;
        
        self.ninjaStarBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjastar.png"];
        [self addChild:self.ninjaStarBatch];

        //will eventually get this from stored thingy
        self.numStars = 10;
        self.starDamage = 5;
        
        NSString *numStarsString = [NSString stringWithFormat:@"x%d",self.numStars];
        self.numStarsLabel = [CCLabelTTF labelWithString:numStarsString fontName:@"Noteworthy-Bold" fontSize:20];
        self.numStarsLabel.position = ccp(260,60);
        self.numStarsLabel.color = ccc3(100,100,100);
        [self addChild:self.numStarsLabel];
        
        CCSprite *ninjaStarLabelSprite = [CCSprite spriteWithFile:@"ninjastar.png"];
        ninjaStarLabelSprite.position = ccp(225, 60);
        [self addChild:ninjaStarLabelSprite];
    }
    return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:20 swallowsTouches:YES];
}


//should not be automatically scheduled, should be called by hitdetector
-(void) nextFrame:(ccTime)dt{
    if (isSwiping){
        timePassed += dt;
        timePassedSincePrevTouch += dt;
    }
    
    for (NinjaStar *sprite in self.ninjaStarBatch.children){
        //update horizontal and vertical velocities
        //[sprite setYVelocity:([sprite yVelocity]+(colliderInstance.gravity * dt))];
        sprite.position = ccp((sprite.position.x+(colliderInstance.backgroundSpeedX)*dt),(sprite.position.y));
        sprite.position = ccp((sprite.position.x+([sprite xVelocity]*dt)), (sprite.position.y+([sprite yVelocity]*dt)));
        sprite.rect = CGRectInset(sprite.boundingBox, 4, 4); //returns a rect slightly smaller than the default box encompassing the whole image to imporve collision detection
        
        float width = [[CCDirector sharedDirector] winSize].width;
        float height = [[CCDirector sharedDirector] winSize].height;
        //kill stars outside screen
        if ((sprite.position.x>(width+300))||(sprite.position.x<-300)||(sprite.position.y>(height+300))||(sprite.position.y<-300)){
            [self removeChild:sprite cleanup:YES];
        }
    }
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (isSwiping == NO){
        timePassed = 0;
        timePassedSincePrevTouch = 0;
        swipeInitX = location.x;
        swipeInitY = location.y;
        prevPosX = location.x;
        prevPosY = location.y;
        isSwiping = YES;
        wasThrown = NO;
        hasAngle = NO;
        return YES;
    }
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    //making sure star wasn't already thrown in this swipe
    BOOL swipeValid = NO;
    if (wasThrown == NO){
        //if swipe was quick enough
        //if (timePassedSincePrevTouch<0.1){
            //if swipe moved enough
            if (sqrtf(powf((location.x-prevPosX),2.0)+powf((location.y-prevPosY),2.0))>2){
                //setting angle if it hasn't been set already
                if (hasAngle == NO){
                    angle = atanf((location.y-prevPosY)/(location.x-prevPosX));
                    hasAngle = YES;
                }
                if (hasAngle == YES){
                    float currentAngle = atanf((location.y-prevPosY)/(location.x-prevPosX));
                    //if swipe is still moving in same direction
                    if ((fabsf(currentAngle-angle))<(pi/6)){
                        swipeValid = YES;
                    }
                    else{
                        //swipe stopped--reset everything
                        swipeInitX = location.x;
                        swipeInitY = location.y;
                        hasAngle = NO;
                        timePassed = 0;
               // }
            }
                
        }
        
        }
    }
    if (swipeValid ==YES){
        if (self.numStars > 0){
            int distanceRequiredForSwipe = 100;
            //if (timePassedSincePrevTouch<.1){
                distanceRequiredForSwipe = 60;
            //}
            if (sqrtf(powf((location.x-swipeInitX),2.0)+powf((location.y-swipeInitY),2.0))>distanceRequiredForSwipe){
                //throw star
                float throwAngle = atanf((location.y-swipeInitY)/(location.x-swipeInitX));
                if ((location.x-swipeInitX)<0){
                    throwAngle += pi;
                }
                NinjaStar *ninjaStar = [NinjaStar spriteWithFile:@"ninjastar-hd.png"];
                ninjaStar.position = ccp(ninjaLayerInstance.ninja.position.x, ninjaLayerInstance.ninja.position.y);
                [self.ninjaStarBatch addChild:ninjaStar];
                [ninjaStar runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.015f angle:-10]]];
                [ninjaStar setXVelocity:(cosf(throwAngle)*950)];
                [ninjaStar setYVelocity:(sinf(throwAngle)*950)];
                wasThrown = YES;
                self.numStars -= 1;
                [self updateLabel];
            }
        }
    }
                                                     
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (timePassed<1){
    }
    timePassed = 0;
    isSwiping = NO;
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    isSwiping = NO;
    timePassed = 0;
}


-(void) updateLabel{
    NSString *numStarsString = [NSString stringWithFormat:@"x%d",self.numStars];
    self.numStarsLabel.string = numStarsString;
    
}

-(void) dealloc{
    [super dealloc];
}


@end



@implementation NinjaStar

@synthesize xVelocity;
@synthesize yVelocity;

@end