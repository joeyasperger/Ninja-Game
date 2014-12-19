//
//  LoadingLayer.h
//  NinjaGame
//
//  Created by Joey on 7/6/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingLayer : CCLayer

{
    bool hasStartedTransition;
    CCLabelTTF *loadingLabel;
}

@property (assign,readwrite) int level;
@property (assign,readwrite) char type; //'l' = level, 'm' = main meny


+(void) startLevel:(int)level;
+(void) startMainMenu;
+(void) enterLoadingScene;
+(CCScene*) loadingScene;
+(void) enterLevelSelectScene;

-(void) loadLevel:(int)level;
-(void) loadMainMenu;

@end
