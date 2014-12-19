//
//  NinjaLayer.h
//  cocosgame
//
//  Created by Joey on 1/6/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class PhysicsSprite;
@class Timer;


#define NO_ANIMATION 0
#define IDLE_RIGHT 1
#define IDLE_LEFT 2
#define CROUCH_IDLE_RIGHT 3
#define CROUCH_IDLE_LEFT 4
#define RUN_RIGHT 5
#define RUN_LEFT 6
#define CROUCH_RUN_RIGHT 7
#define CROUCH_RUN_LEFT 8
#define JUMP_RIGHT 9
#define JUMP_LEFT 10
#define ATTACK_A_RIGHT 11
#define ATTACK_B_RIGHT 13
#define ATTACK_C_RIGHT 15
#define ATTACK_A_LEFT 12
#define ATTACK_B_LEFT 14
#define ATTACK_C_LEFT 16
#define BLOCK_RIGHT 17
#define BLOCK_LEFT 18



@interface NinjaLayer : CCLayer
{
    float xPosition;
    float yPosition;
    char directionFacing;
    int lastanimation;
    int currentBoundBox;
    float actionTimer;
    
    //to do hitboxes
    int nextHit;
    /*KEY FOR NEXTHIT
     0 = none
     1 = light attack right A
     2 = light attack left A
     3 = light attack right B
     4 = light attack left B
     5 = light attack right C
     6 = light attack left C
    */
    
    Timer *comboTimer;// if still running, attack will be next in combo
    Timer *swingTimer;// attacks cannot start while this is running
        // NOTE: finite action timer will keep other actions from occuring for longer
    Timer *hitTimer;// when this expires, HitBox will be generated
    
    Timer *overdriveTimer;
    Timer *invisibilityTimer;
    
}

//probably should change this eventually, but this is for when jump is held continuously
@property (assign, readwrite) BOOL inAir;
@property (assign, readwrite) BOOL justFinishedJump;
@property (assign, readwrite) PhysicsSprite *ninja;
@property (assign, readwrite) BOOL inFiniteAnimation;
@property (assign, readwrite) int healthLeft;
@property (assign, readwrite) int maxHealth;
@property (assign, readwrite) int animation;
@property (assign, readwrite) BOOL isDisabled;
@property (assign, readwrite) int nextCombo; //number for next attack in light attack sequence
@property (assign, readwrite) bool blockPressed;
@property (assign, readwrite) bool isBlocking;
@property (assign, readwrite) bool overdrive;
@property (assign, readwrite) bool invisible;



//uses switch case to see if animation is same as previous frame or should be changed
-(void) checkAnimation;

//sets maxhealth based on health level 
-(void) setInitialHealth;

//if maxhealth is increased in the middle of a level
-(void) adjustMaxHealth;

//checks HitTimer and determines if a hitbox needs to be sent to hit detector
-(void) checkHitBox:(ccTime) dt;

//view variables
-(float) xPos;
-(float) yPos;


//always set up with this
-(void) setXPosition: (float) Xcoord withYPosition: (float) Ycoord;

//then use this (never call more than once)
-(void) addNinja;

//use to move a specific distance
-(void) moveNinja: (float) Xval withYdistance: (float) Yval;

//to set and get the direction the ninja is facing
-(void) setDirectionFacing: (char) directionChar;
-(char) getDirectionFacing;

//randomly pick base damage number between range determined by damage level
-(int) generateRandomDamage;

// Slow down ninja's x-velocity in middle of attack
-(void) slowDuringAttack:(ccTime)dt;

//sets animation to block in the proper direction
-(void) setBlockingAnimation;

//continuous animations
-(void) animateRunRight;
-(void) animateRunLeft;
-(void) animateIdleRight;
-(void) animateIdleLeft;
-(void) animateSingleJumpRight;
-(void) animateSingleJumpLeft;
-(void) animateCrouchIdleRight;
-(void) animateCrouchIdleLeft;
-(void) animateCrouchRunRight;
-(void) animateCrouchRunLeft;
-(void) animateBlockRight;
-(void) animateBlockLeft;
//finite animations
-(void) animateLightAttackRight;
-(void) animateLightAttackLeft;
-(void) animateLightAttackRightB;
-(void) animateLightAttackLeftB;
-(void) animateLightAttackRightC;
-(void) animateLightAttackLeftC;


//set up hitboxes
-(void) hitLightAttackRight;
-(void) hitLightAttackLeft;
-(void) hitLightAttackRightB;
-(void) hitLightAttackLeftB;
-(void) hitLightAttackRightC;
-(void) hitLightAttackLeftC;

// sent from buttonlayer to signify that block button is currently pressed 
-(void) startBlock;
-(void) endBlock;

//to start jump
-(void) startJump;

-(void) startLightAttack;

//to end an animation
-(void) stopAnimations;

-(void) activateOverdrive;
-(void) activateInvisibility;


//to check and update active bounding box
-(void) updateRectSize;
-(void) updateRectInt;

-(void) resetColor;

//to take damage
-(void) takeHitWithDamage:(int) damage andKnockback:(int) knockback;

//to draw ninja
-(void) drawAllRects;

@end
