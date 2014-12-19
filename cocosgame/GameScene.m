//
//  GameSceneLevel1.m
//  NinjaGame
//
//  Created by Joey on 2/4/13.
//
//

#import "GameScene.h"
#import "GameLayer.h"
#import "NinjaStarLayer.h"
#import "NinjaLayer.h"
#import "PauseLayer.h"
#import "RectDrawingLayer.h"
#import "ButtonLayer.h"
#import "EnemyLayer.h"
#import "EnemyHealthbarLayer.h"
#import "BackgroundLayer.h"
#import "ForegroundLayer.h"
#import "DeathLayer.h"
#import "InterfaceLayer.h"
#import "FlashingLayer.h"
#import "AbilityButtonLayer.h"

#define Draw_Bounds 0

@implementation GameScene

@synthesize level = _level;

-(id) initWithLevel:(int)level
{
    if( (self = [super init]) ){
        self.level = level;
        
        // 'layer' is an autorelease object.
        gameLayerInstance = [GameLayer node];
        
        gameLayerInstance.gameLevel = self.level;
        
        ninjaLayerInstance = [NinjaLayer node];
        backgroundLayerInstance = [BackgroundLayer node];
        pauseLayerInstance = [PauseLayer node];
        ninjaStarLayerInstance = [NinjaStarLayer node];
        foregroundLayerInstance = [ForegroundLayer node];
        buttonLayerInstance = [ButtonLayer node];
        enemyHealthbarLayerInstance = [EnemyHealthbarLayer node];
        enemyLayerInstance = [EnemyLayer node];
        deathLayerInstance = [DeathLayer node];
        interfaceLayerInstance = [InterfaceLayer node];
        flashingLayerInstance = [FlashingLayer node];
        abilityButtonLayerInstance = [AbilityButtonLayer node];
        
        

        
        // add layer as a child to scene
        [self addChild:backgroundLayerInstance];
        [self addChild:foregroundLayerInstance];
        [self addChild:enemyLayerInstance];
        [self addChild:ninjaLayerInstance];
        [self addChild:ninjaStarLayerInstance];
        [self addChild:enemyHealthbarLayerInstance];
        [self addChild:flashingLayerInstance];
        [self addChild:gameLayerInstance];
        [self addChild:buttonLayerInstance];
        [self addChild:abilityButtonLayerInstance];
        [self addChild:interfaceLayerInstance];
        [self addChild:pauseLayerInstance];
        [self addChild:deathLayerInstance];

        


        //only use when drawing bounding boxes
#if Draw_Bounds
        rectDrawingLayerInstance = [RectDrawingLayer node];
        [self addChild:rectDrawingLayerInstance];
#endif
        
        

        [ninjaLayerInstance setXPosition:240 withYPosition:120];
        [ninjaLayerInstance addNinja];
        
    }
    return self;
}

-(void) onEnterTransitionDidFinish{
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}


@end
