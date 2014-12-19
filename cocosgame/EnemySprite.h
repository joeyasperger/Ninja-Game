//
//  EnemySprite.h
//  NinjaGame
//
//  Created by Joey on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"

#define PATROL_ENEMY 0
#define STILL_ENEMY 1
#define SEEK_ENEMY 2
#define STILL_CHANGE_ENEMY 3
#define ATTACKING_ENEMY 4

@class Timer;

@interface EnemySprite : PhysicsSprite

@property (assign,readwrite) bool inAir;
@property (assign,readwrite) int mode;
@property (assign,readwrite) char originalMode; //to reset if loses sight of player
@property (assign,readwrite) char directionLooking;
@property (assign,readwrite) CGPoint originalPosition;//for patrolling


@property (assign,readwrite) int previousAnimation;
@property (assign,readwrite) int animation;

@property (assign,readwrite) BOOL inAttack;

//activated after being hit -> stops anything from working
@property (assign,readwrite) Timer *disabledTimer;  //maybe make same as finite action timer

@property (assign,readwrite) float finiteActionTimer;

// 'n' = normal, 'r' = red, 'g' = green, 'b' = blue
@property (assign,readwrite) char colorType;

//stuff used when in mode 'c' (stand still but change direction)
@property (assign,readwrite) float changeDirectionTimer;

//for attack mode
@property (assign,readwrite) float timeSinceAttack;

//health stuff
@property (assign,readwrite) int maxHealth;
@property (assign,readwrite) int healthLeft;
@property (assign,readwrite) CCProgressTimer *healthbar;
@property (assign,readwrite) BOOL aboutToDie;

@property (assign,readwrite) bool poisoned;
@property (assign,readwrite) bool frozen;



//create nextFrame: function
-(void) startAI;

-(void) nextFrame:(ccTime)dt;

//for healthbar progress timer
-(void) setupHealthbar;  //call when initializing each enemy
-(void) updateHealthbar;

//note: knockback is directional
-(void) takeHitWithDamage:(int) damage andKnockback:(int) knockback;

-(void) poisonSelf;
-(void) freezeSelf;
-(void) unfreezeSelf;
-(void) inflictPoisonDamage;

//to reset after being disabled by a hit
-(void) endDisabling;


@end
