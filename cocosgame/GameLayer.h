//
//  GameLayer.h
//  cocosgame
//
//  Created by Joey on 12/5/12.
//  Copyright Joey Asperger 2012. All rights reserved.
//

//to get line count
//find . -name "*.[hm]" ! -path ./libs\* -print0 | xargs -0 wc -l

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class Collider;
@class HitDetector;
@class ButtonLayer;
@class PauseLayer;
@class RectDrawingLayer;
@class EnemyLayer;
@class BackgroundLayer;
@class ForegroundLayer;
@class EnemyHealthbarLayer;
@class NinjaStarLayer;
@class NinjaLayer;
@class JoystickClass;
@class DeathLayer;
@class InterfaceLayer;
@class FlashingLayer;
@class AbilityButtonLayer;
@class Timer;



CCSprite * joystick;
CCSprite * joystickpad;


Collider * colliderInstance;
JoystickClass *joystickVars;

#pragma mark - GameLayer

//@class NinjaLayer;
//@class JoystickClass;

// HelloWorldLayer
@interface GameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{    
    //sprites that will be put in interfaceBatch
    CCSprite *ninjaHealthBar;
    CCSprite *ninjaHealthBarBackground;
    CCSprite *energyBar;
    CCSprite *energyBarBackground;
    CCProgressTimer *energyProgressTimer;
    CCSprite *experienceBar;
    CCSprite *experienceBarBackground;
    CCProgressTimer *experienceProgressTimer;
    CCProgressTimer *ninjaHealthProgressTimer;
    
    bool levelCompleteTransitionStarted;
    
    
    CCSprite *lightAttackButton;
    
    Timer *energyRecoverTimer;
    

}
//main batch for interface sprites
@property (assign,readwrite) CCSpriteBatchNode *interfaceBatch;

@property (assign,readwrite) HitDetector *hitDetectorInstance;
@property (assign,readwrite) NSMutableArray *damageDisplayList;

@property (assign,readwrite) NSMutableArray *enemyList; //created and released in each frame
    //has enemies from all enemybatches

@property (assign,readwrite) CCLabelTTF *timeLabel; //for displaying time

@property (assign,readwrite) CCSprite *pauseButton;

//ALL THE STATS STORED IN NSUSERDEFAULTS
@property (assign,readwrite) int playerLevel;
@property (assign,readwrite) int playerExperience;
@property (assign,readwrite) int damageLevel;
@property (assign,readwrite) int healthLevel;
@property (assign,readwrite) int energyLevel;

//which stage it is
@property (assign,readwrite) int gameLevel;

//time counter
@property (assign,readwrite) float levelTime;

//Starts at zero and is the total displacement of the ninja in the x-direction since the start of the level
@property (assign,readwrite) float overallPosition;

//stats for levelcomplete scene
@property (assign,readwrite) int damageTaken;
@property (assign,readwrite) int enemiesKilled;
@property (assign,readwrite) int stealthKills;
@property (assign,readwrite) int timesSpotted;

@property (assign,readwrite) int energyRemaining;
@property (assign,readwrite) int maxEnergy;

-(void) updateHealthBar;
-(void) updateEnergyBar;

//initializes health, energy, and experience bars
-(void) setupProgressBars;

-(void) updateDamageLabels:(ccTime)dt;

-(int) levelUpPoints; //returns number of available points to use on skills

-(void) loadUserDefaults;  //load stats.  If first run, set stats to 1

-(void) addDamageDisplay:(int)damage color:(char) color sizeMultiple:(float)sizeMultiple position:(CGPoint)position;
-(void) addBlockDamageDisplay:(CGPoint)position;

// Sets ninja's animation and velocity based on joystick position
-(void) applyJoystickInput;

/**
 Check if the user has completed the level and call completeLevel if so.
 */
-(void) checkLevelComplete;

-(void) completeLevel;

-(void) setupMaxEnergy; //sets max energy based on level
-(void) recoverEnergy:(ccTime)dt; //to be called each frame, recovers energy every 1.5 seconds

-(void) levelup;

-(void) usePoisonAbility;
-(void) useFreezeAbility;
-(void) useInvisibilityAbility;
-(void) useOverdriveAbility;

@end


//layer declarations
BackgroundLayer * backgroundLayerInstance;
ForegroundLayer * foregroundLayerInstance;
EnemyLayer * enemyLayerInstance;
NinjaLayer * ninjaLayerInstance;
PauseLayer *pauseLayerInstance;
NinjaStarLayer *ninjaStarLayerInstance;
GameLayer *gameLayerInstance;
ButtonLayer *buttonLayerInstance;
EnemyHealthbarLayer *enemyHealthbarLayerInstance;
DeathLayer *deathLayerInstance;
InterfaceLayer *interfaceLayerInstance;
FlashingLayer *flashingLayerInstance;
AbilityButtonLayer *abilityButtonLayerInstance;

RectDrawingLayer * rectDrawingLayerInstance;


