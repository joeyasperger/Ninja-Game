//
//  NinjaEnemy.h
//  NinjaGame
//
//  Created by Joey on 3/17/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemySprite.h"

@class Timer;

@interface NinjaEnemy : EnemySprite

{
    bool hasSpottedNinja;
    bool stealthKill;
    int WALK_SPEED;
    int RUN_SPEED;
}

@property (assign,readwrite) int nextHitRect;
@property (assign,readwrite) float hitRectTimer;
@property (assign,readwrite) BOOL notInFiniteAnimation;//probably don't need this
@property (assign,readwrite) float finiteActionTimer;
@property (assign,readwrite) float knockbackSpeedX;
@property (assign,readwrite) float knockbackSpeedY;
@property (assign,readwrite) float deathTimer;
@property (assign,readwrite) float timeSinceInRange;
@property (assign,readwrite) bool patrolPaused;
@property (assign,readwrite) double patrolDistanceToGo;
@property (assign,readwrite) Timer *patrolPauseTimer;
@property (assign,readwrite) Timer *poisonTimer; // for determining when to unpoison enemy
@property (assign,readwrite) Timer *poisonDamageTimer; // for determining if enough time has passed to inflict damage from poison
@property (assign,readwrite) Timer *freezeTimer;
@property (assign,readwrite) Timer *disabledTimer;
@property (assign,readwrite) int patrolRange;
@property (assign,readwrite) bool killSequenceStarted;



-(void) updateAnimation;

//for when enemy loses sight of ninja
-(void) resetAI;

-(bool) canSeeNinja;

//animates ninjaEnemy running in direction of player
-(void) runTowardsNinja:(ccTime)dt;

//Checks if player is out of range or in attack range and adjusts mode accordingly
-(void) checkRange;

//crappy function name, but does what it says
-(void) runAttackModeAlgorithm:(ccTime)dt;

-(void) startLightAttackA; //determines direction and starts animation

-(void) animateMoveRight;
-(void) animateMoveLeft;
-(void) animateIdleRight;
-(void) animateIdleLeft;
-(void) animateLightAttackRight;
-(void) animateLightAttackLeft;
-(void) animateWalkRight;
-(void) animateWalkLeft;

-(void) hitLightAttackRight;
-(void) hitLightAttackLeft;

// use if ninja is about to die -> fades out ninja and eventually switches to death scene
-(void) startKillSequence;

//immediately kill self
-(void) killSelf;

//checks if has reached end of patrolling range and pauses patrol if needed
-(void) checkAndPausePatrol:(ccTime)dt;

@end
