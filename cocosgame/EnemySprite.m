//
//  EnemySprite.m
//  NinjaGame
//
//  Created by Joey on 3/13/13.
//
//

#import "EnemySprite.h"
#import "EnemyHealthbarLayer.h"
#import "GameLayer.h"


/*
 MODE KEY
 'p' = patrol
 's' = seek (saw ninja)
 'w' = watch (static direction)
 'c' = stand still but change directions
 
 */

@implementation EnemySprite


@synthesize timeSinceAttack = _timeSinceAttack;
@synthesize changeDirectionTimer = _changeDirectionTimer;
@synthesize mode = _mode;
@synthesize directionLooking = _directionLooking;
@synthesize originalMode = _originalMode;
@synthesize previousAnimation = _previousAnimation;
@synthesize animation = _animation;
@synthesize inAttack = _inAttack;
@synthesize colorType = _colorType;
@synthesize maxHealth = _maxHealth;
@synthesize healthLeft = _healthLeft;
@synthesize aboutToDie = _aboutToDie;
@synthesize originalPosition = _originalPosition;
@synthesize inAir = _inAir;


//overriding physicsSprite method so originalPosition can be updated
-(void) moveSpriteWithScreen:(float)xSpeed withYSpeed:(float)ySpeed{
    self.position = ccp((self.position.x + xSpeed), (self.position.y + ySpeed));
    self.originalPosition = ccp((self.originalPosition.x + xSpeed), (self.originalPosition.y + ySpeed));
    self.rect = CGRectOffset(self.rect, xSpeed, ySpeed);
    self.nextRect = CGRectOffset(self.nextRect, xSpeed, ySpeed);
    self.nextXVal += xSpeed;
    self.nextYVal += ySpeed;
}

-(void) setupHealthbar{
    //this can definetely be moved to the generic enemy sprite class
    CCSprite *healthbarSprite = [CCSprite spriteWithSpriteFrameName:@"HealthBar.png"];
    self.healthbar = [CCProgressTimer progressWithSprite:healthbarSprite];
    self.healthbar.type = kCCProgressTimerTypeBar;
    self.healthbar.position = ccp(self.position.x,(self.nextRect.origin.y+self.nextRect.size.height+20));
    self.healthbar.midpoint = ccp(.5f,.5f);
    self.healthbar.barChangeRate = ccp(1,0);
    self.healthbar.percentage = (((float)self.healthLeft / (float)self.maxHealth) * 100);
    self.healthbar.opacity = 160;
    //add to game layer as child (not sure if this will work how I want it to
    [enemyHealthbarLayerInstance addChild:self.healthbar];
}

-(void) updateHealthbar{
    self.healthbar.position = ccp(self.position.x,(self.nextRect.origin.y+self.nextRect.size.height+20));
    self.healthbar.percentage = (((float)self.healthLeft / (float)self.maxHealth) * 100); //realHealth is a percentage
    
}

@end
