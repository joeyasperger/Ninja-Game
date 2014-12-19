//
//  DeathLayer.h
//  NinjaGame
//
//  Created by Joey on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DeathLayer : CCLayer

@property (assign,readwrite) BOOL isActive;
@property (assign,readwrite) CCSprite *tryAgainSprite;
@property (assign,readwrite) CCSprite *quitSprite;
@property (assign,readwrite) CCLabelTTF *tryAgainLabel;
@property (assign,readwrite) CCLabelTTF *quitLabel;
@property (assign,readwrite) CCLabelTTF *gameOverLabel;
@property (assign,readwrite) float timeSinceDeath;
@property (assign,readwrite) CCSprite *blackPixel;

-(void) activateDeathLayer;

@end
