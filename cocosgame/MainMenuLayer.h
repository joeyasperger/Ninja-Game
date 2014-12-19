//
//  MainMenu.h
//  cocosgame
//
//  Created by Joey on 1/23/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer

{
    CCSprite *menuBackground;
    CCSprite *playGame;
    CCSprite *playGamePressed;
    CCSprite *settings;
    CCSprite *settingsPressed;
    CCSprite *credits;
    CCSprite *creditsPressed;
    CCSprite *ninja;
    
    BOOL isPlayGamePressed;
    BOOL isSettingsPressed;
    BOOL isCreditsPressed;
    
    float time;
    BOOL playGameMoved;
    BOOL settingsMoved;
    BOOL creditsMoved;
}


+(CCScene*) scene;

-(void) pressedPlayGame;
-(void) pressedSettings;
-(void) pressedCredits;
-(void) shootNinjaStar;
-(void) killStarsOutsideScreen;

@end
