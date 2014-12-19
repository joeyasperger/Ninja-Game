//
//  BanditEnemy.m
//  NinjaGame
//
//  Created by Joseph Asperger on 1/13/14.
//
//

#import "BanditEnemy.h"
#import "Timer.h"

@implementation BanditEnemy


-(void) startAI{
    WALK_SPEED = 65;
    RUN_SPEED = 350;
    self.finiteActionTimer = 0;
    self.maxHealth = 60;
    self.healthLeft = 60;
    [self setRectHeight:122 withWidth:40 withXOffset:0 andYOffset:-16];
    [self setupHealthbar];
    
    self.poisonDamageTimer = [Timer new];
    self.poisonTimer = [Timer new];
    self.freezeTimer = [Timer new];
    self.disabledTimer = [Timer new];
    
    if (self.mode == STILL_CHANGE_ENEMY){
        self.changeDirectionTimer = 4.0;
    }
    
    if (self.mode == PATROL_ENEMY){
        self.patrolPauseTimer = [Timer new];
        self.patrolPaused = true;
        [self.patrolPauseTimer activateTimer:0.7];
        self.patrolDistanceToGo = self.patrolRange;
    }
}

-(void) animateIdleRight{
    [self runAction:[self makeIdleAction:@"BanditIdleRight.png"]];
}

-(void) animateIdleLeft{
    [self runAction:[self makeIdleAction:@"BanditIdleLeft.png"]];
}

-(void) animateMoveRight{
    [self runAction:[self makeContinuousAction:@"BanditRunRight" withNumFrames:12 andFrameDuration:.060]];
}

-(void) animateMoveLeft{
    [self runAction:[self makeContinuousAction:@"BanditRunLeft" withNumFrames:12 andFrameDuration:.060]];
}

-(void) animateWalkRight{
    [self runAction:[self makeContinuousAction:@"BanditWalkRight" withNumFrames:10 andFrameDuration:.1]];
}

-(void) animateWalkLeft{
    [self runAction:[self makeContinuousAction:@"BanditWalkLeft" withNumFrames:10 andFrameDuration:.1]];
}

-(void) animateLightAttackLeft{
    [self runAction:[self makeFiniteAction:@"BanditAttackLeft" withNumFrames:5 andFrameDuration:.05f]];
    self.finiteActionTimer = 0.4;
    self.nextHitRect = 2;
    self.hitRectTimer = .10f;
}

-(void) animateLightAttackRight{
    [self runAction:[self makeFiniteAction:@"BanditAttackRight" withNumFrames:5 andFrameDuration:.05f]];
    self.finiteActionTimer = 0.4;
    self.nextHitRect = 1;
    self.hitRectTimer = .10f;
}

@end
