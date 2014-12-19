//
//  LoadingLayer.m
//  NinjaGame
//
//  Created by Joey on 7/6/13.
//
//

#import "LoadingLayer.h"
#import "GameScene.h"
#import "MainMenuLayer.h"
#import "LevelSelectLayer.h"

@implementation LoadingLayer

@synthesize level = _level;
@synthesize type = _type;

+(void) startLevel:(int)level{
    
    CCScene *scene = [CCScene node];
    LoadingLayer *loadLayerInstance = [LoadingLayer node];
    [scene addChild:loadLayerInstance];
    loadLayerInstance.type = 'l';
    loadLayerInstance.level = level;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:.3 scene:scene]];
}

+(void) startMainMenu{
    CCScene *scene = [CCScene node];
    LoadingLayer *loadLayerInstance = [LoadingLayer node];
    [scene addChild:loadLayerInstance];
    loadLayerInstance.type = 'm';
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.5 scene:scene withColor:ccBLACK]];
    [loadLayerInstance loadMainMenu];
}

+(void) enterLoadingScene{
    CCScene *scene = [CCScene node];
    LoadingLayer *loadingLayerInstance = [LoadingLayer node];
    [scene addChild:loadingLayerInstance];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:.3 scene:scene]];
    
    //temporaryStuff
    loadingLayerInstance.level = 1;
    loadingLayerInstance.type = 'l';
}

+(void) enterLevelSelectScene{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.5 scene:[LevelSelectLayer scene] withColor:ccBLACK]];
}

-(id) init{
    if ((self = [super init])){
        hasStartedTransition = false;
        
        CCSprite *background = [CCSprite spriteWithFile:@"LoadScreenBackground.png"];
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        background.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:background];
        
        loadingLabel = [CCLabelTTF labelWithString:@"Loading" fontName:@"Noteworthy-Bold" fontSize:60];
        loadingLabel.color = ccBLACK;
        loadingLabel.position = ccp(windowSize.width/2, windowSize.height/2 + 60);
        [self addChild:loadingLabel];
        
    }
    return self;
}

-(void) onEnterTransitionDidFinish{
    if (self.type == 'l'){
        //Why doesn't this work
        [self schedule:@selector(nextFrame:)];
    }
    if (self.type == 'm'){
        [self loadMainMenu];
    }
}

-(void) nextFrame:(ccTime)dt{
    if (!hasStartedTransition){
        if (self.type == 'l'){
            hasStartedTransition = true;
            [self loadLevel:self.level];
        }
    }

}

-(void) loadLevel:(int)level{
    GameScene *gameScene = [[GameScene alloc] initWithLevel:level];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.5 scene:gameScene withColor:ccBLACK]];
}

-(void) loadMainMenu{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.5 scene:[MainMenuLayer scene] withColor:ccBLACK]];
}


@end
