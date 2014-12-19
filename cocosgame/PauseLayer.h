//
//  PauseLayer.h
//  cocosgame
//
//  Created by Joey on 1/16/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface PauseLayer : CCLayer
{
    CCSpriteBatchNode *pauseBatch;
    
    bool isActive;
    bool buttonsAreVisible;
    bool plusButtonsActive;
    CCSprite *pauseScreen;
    CCSprite *resumeButton;
    CCSprite *quitButton;
    CCLabelTTF *resumeLabel;
    CCLabelTTF *quitLabel;
    
    CCSprite *damagePlusButton;
    CCSprite *healthPlusButton;
    CCSprite *energyPlusButton;
}


-(void) activatePauseLayer;
-(void) deactivatePauseLayer;

-(void) addLevelDisplay;

-(void) activateLevelUpButtons;
-(void) deactivateLevelUpButtons;
-(void) addPlusButton:(CCSprite*) plusButton yPos:(float) yPos;

-(void) addResumeAndQuitButtons;

//check if there are points left to spend and adds or removes plus buttons if necessary
-(void) checkPlusButtons;

-(void) pauseAllGameplayLayers;

/* For use at when level is initializing
 * Adds specified number of level icons to pausescreen and text for the attribute name
 */
-(void) addLevelIcons:(NSString*) text spriteFile:(NSString*) fileName yCoord:(float) yCoord numIcons:(int) numIcons;

/* Adds one level icon when plus button is pressed
 * Parameters: filename, y-position, and level of given skill to determine x-position
 */
-(void) addSingleLevelIcon:(NSString*) filename yPos:(float) yPos skillLevel:(int) skillLevel;



@end