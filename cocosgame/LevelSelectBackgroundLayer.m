//
//  LevelSelectBackgroundLayer.m
//  NinjaGame
//
//  Created by Joey on 5/14/13.
//
//

#import "LevelSelectBackgroundLayer.h"

@implementation LevelSelectBackgroundLayer

-(id) init{
    if ((self = [super init])){
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainmenuspritesheet.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"menubackground.png"];
        background.position = ccp(windowSize.width/2,windowSize.height/2);
        [self addChild:background];
    }
    return self;
}


@end
