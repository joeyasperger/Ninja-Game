//
//  GenericBackgroundLayer.m
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import "BackgroundLayer.h"
#import "GameLayer.h"
#import "Collider.h"

@implementation BackgroundLayer

@synthesize groundBatch = _groundBatch;
@synthesize treeBatch = _treeBatch;


-(id) init{
    if ((self = [super init])){
        [self schedule:@selector(nextFrame:)];
        
        if (gameLayerInstance.gameLevel == 1){
            [self setupLevel1Background];
        }
        if (gameLayerInstance.gameLevel == 2){
            [self setupLevel2Background];
        }
        if (gameLayerInstance.gameLevel == 3){
            [self setupLevel3Background];
        }
        if (gameLayerInstance.gameLevel == 4){
            [self setupLevel4Background];
        }
        if (gameLayerInstance.gameLevel == 5){
            [self setupLevel5Background];
        }
        if (gameLayerInstance.gameLevel == 6){
            [self setupLevel6Background];
        }
        
        
          
    }
    return self;
}

-(void)nextFrame:(ccTime)dt{
    
    for (CCSprite *sprite in self.groundBatch.children){
        sprite.position = ccp((sprite.position.x+(colliderInstance.backgroundSpeedX * dt)),sprite.position.y + (colliderInstance.backgroundSpeedY * dt));
    }
    
    
    for (BackgroundSprite *sprite in self.treeBatch.children){
        sprite.position = ccp((sprite.position.x+((colliderInstance.backgroundSpeedX * dt) * sprite.parallaxFactor)),sprite.position.y + (colliderInstance.backgroundSpeedY * dt));
    }
    
}

-(void) addNightSky{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sky = [CCSprite spriteWithFile:@"NightSky.png"];
    sky.position = ccp(windowSize.width/2,windowSize.height/2);
    [self addChild:sky];
}

-(void) addDaySky{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sky = [CCSprite spriteWithFile:@"DaySky.png"];
    sky.position = ccp(windowSize.width/2,windowSize.height/2);
    [self addChild:sky];
}

-(void) addRedSky{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sky = [CCSprite spriteWithFile:@"RedSky.png"];
    sky.position = ccp(windowSize.width/2,windowSize.height/2);
    [self addChild:sky];
}

-(void) addSnowSky{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sky = [CCSprite spriteWithFile:@"SnowSky.png"];
    sky.position = ccp(windowSize.width/2,windowSize.height/2);
    [self addChild:sky];
}

-(void) addForestGround{
    self.groundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestGround.png"];
    [self addChild:self.groundBatch];
    
    for(int i = 1; i<30; ++i){
        CCSprite *background = [CCSprite spriteWithFile:@"ForestGround.png"];
        background.position = ccp((-3500+500*i), 38);
        [self.groundBatch addChild:background];
    }
}

-(void) setupForestGroundWithXStart:(double)xStart xEnd:(double)xEnd{
    self.groundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestGround.png"];
    [self addChild:self.groundBatch];
    
    for (int i = xStart; i < xEnd; i+= 500){
        CCSprite *ground = [CCSprite spriteWithFile:@"ForestGround.png"];
        ground.position = ccp(i, 38);
        [self.groundBatch addChild:ground];
    }
}

-(void) addDesertGround{
    self.groundBatch = [CCSpriteBatchNode batchNodeWithFile:@"DesertGround.png"];
    [self addChild:self.groundBatch];
    
    for(int i = 1; i<30; ++i){
        CCSprite *background = [CCSprite spriteWithFile:@"DesertGround.png"];
        background.position = ccp((-3500+500*i), 38);
        [self.groundBatch addChild:background];
    }
}

-(void) addSnowGround{
    self.groundBatch = [CCSpriteBatchNode batchNodeWithFile:@"snowtile.png"];
    [self addChild:self.groundBatch];
    
    for(int i = 1; i<300; ++i){
        CCSprite *background = [CCSprite spriteWithFile:@"snowtile.png"];
        background.position = ccp((-3500+99*i), 40);
        [self.groundBatch addChild:background];
    }
}

-(void) setupTreeBackgroundWithXStart:(double)xStart xEnd:(double)xEnd numSegments:(int)numSegments{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestBackgroundSpriteSheet.plist"];
    self.treeBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestBackgroundSpriteSheet.png"];
    [self addChild:self.treeBatch];
    double parallaxFactors[4] = {.725,.775,.85,1};
    for (int i = 0; i < 4;i++){
        for (int j = xStart; j < xEnd; j += 300){
            int num = arc4random()%300;
            [self placeTreeAtX:j+num withGroundY:80 andNumSegments:numSegments parallaxFactor:parallaxFactors[i]];
            
        }
    }
}


-(void) placeTreeAtX:(double)xCoord withGroundY:(double)yCoord andNumSegments:(int)numSegments parallaxFactor:(double) parallaxFactor{
    BackgroundSprite *Treebase = [BackgroundSprite spriteWithSpriteFrameName:@"TreeMediumLight.png"];
    Treebase.position = ccp(xCoord+Treebase.boundingBox.size.width/2,(yCoord + 80));
    [self.treeBatch addChild:Treebase];
    Treebase.parallaxFactor = parallaxFactor;
    if (numSegments > 1){
        int yPosition = yCoord + 80;
        while (numSegments > 1){
            yPosition += 152;
            BackgroundSprite *Treesegment = [BackgroundSprite spriteWithSpriteFrameName:@"TreeSegmentLight.png"];
            Treesegment.position = ccp(xCoord+Treebase.boundingBox.size.width/2, yPosition);
            [self.treeBatch addChild:Treesegment];
            Treesegment.parallaxFactor = parallaxFactor;
            numSegments -= 1;
        }
    }
}


-(void) setupLevel3Background{
    
    [self addNightSky];
    
    [self setupTreeBackgroundWithXStart:-1000 xEnd:13000 numSegments:6];
    [self addForestGround];
    
    
    
}

-(void) setupLevel2Background{
    [self setupLevel1Background]; //just for now
}

-(void) setupLevel1Background{
    [self addNightSky];
    [self setupTreeBackgroundWithXStart:-1000 xEnd:13000 numSegments:6];
    [self setupForestGroundWithXStart:-1000 xEnd:13000];

    
}

-(void) setupLevel4Background{
    [self addSnowSky];
    [self addSnowGround];
}

-(void) setupLevel5Background{
    [self setupLevel1Background]; //just for now
}

-(void) setupLevel6Background{
    [self setupLevel1Background];
}

@end


@implementation BackgroundSprite

@synthesize parallaxFactor = _parallaxFactor;

@end