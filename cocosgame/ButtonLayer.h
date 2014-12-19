//
//  ButtonLayer.h
//  NinjaGame
//
//  Created by Joey on 2/26/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ButtonLayer : CCLayer

{
    CCSprite *lightAttackButton;
    CCSprite *blockButton;

    bool lightPressed;
    bool blockPressed;
    
}

-(void) pressLightAttack;
-(void) depressLightAttack;
-(void) pressBlockButton;
-(void) depressBlockButton;

@end
