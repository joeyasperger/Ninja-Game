//
//  LevelCompleteScene.h
//  NinjaGame
//
//  Created by Joey on 7/24/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Timer;

@interface LevelCompleteLayer : CCLayer

{
    CCLabelTTF *headerLabel;
    bool fontGrowing;
    int mode;
    
    CCLabelTTF *killsField;
    CCLabelTTF *stealthKillsField;
    CCLabelTTF *damageTakenField;
    CCLabelTTF *timeField;
    
    float currentKills;
    float currentStealthKills;
    float currentDamageTaken;
    float currentTime;
    
    Timer *fieldTimer;
    
    CCSprite *mapButton;
    
}

@property (assign,readwrite) int level;
@property (assign,readwrite) int levelTime;
@property (assign,readwrite) int kills;
@property (assign,readwrite) int stealthKills;
@property (assign,readwrite) int damageTaken;



+(CCScene*) createSceneWithLevel:(int)level time:(double)time kills:(int)kills stealthKills:(int)stealthKills damageTaken:(int)damageTaken;

-(void) cycleHeader:(ccTime)dt;

-(void) createKillsField;
-(void) createStealthKillsField;
-(void) createDamageField;
-(void) createTimeField;

-(void) updateKillsField:(ccTime)dt;
-(void) updateStealthKillsField:(ccTime)dt;
-(void) updateDamageField:(ccTime)dt;
-(void) updateTimeField:(ccTime)dt;

-(void) mapButtonPressed;


@end
