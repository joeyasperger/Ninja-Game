//
//  AbilityButtons.h
//  NinjaGame
//
//  Created by Joseph Asperger on 12/20/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AbilityButtonLayer : CCLayer

{
    CCSprite *freezeButton;
    CCSprite *poisonButton;
    CCSprite *invisibilityButton;
    CCSprite *overdriveButton;
    CCSprite *smashButton;
}

-(void) pressFreezeButton;
-(void) pressPoisonButton;
-(void) pressInvisibilityButton;
-(void) pressOverdriveButton;
-(void) pressSmashButton;

@end
