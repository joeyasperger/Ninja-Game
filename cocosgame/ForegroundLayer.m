//
//  GenericForegroundLayer.m
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import "ForegroundLayer.h"
#import "PhysicsSprite.h"
#import "GameLayer.h"
#import "Collider.h"

@implementation ForegroundLayer

@synthesize foregroundBatch = _foregroundBatch;

-(id) init{
    if ( (self = [super init]) ){
        STUMP_WIDTH = 80;
        LOG_WIDTH = 245;
        BRANCH_WIDTH = 110;
        SEGMENT_HEIGHT = 160;
        SEGMENT_WIDTH = 75;
        GROUND_Y = 80;
        
        [self schedule:@selector(nextFrame:)];
        
        if (gameLayerInstance.gameLevel == 1){
            [self setupLevel1Foreground];
        }
        if (gameLayerInstance.gameLevel == 2){
            [self setupLevel2Foreground];
        }
        if (gameLayerInstance.gameLevel == 3){
            [self setupLevel3Foreground];
        }
        if (gameLayerInstance.gameLevel == 4){
            [self setupLevel4Foreground];
        }
        if (gameLayerInstance.gameLevel == 5){
            [self setupLevel5Foreground];
        }
        if (gameLayerInstance.gameLevel == 6){
            [self setupLevel6Foreground];
        }
    }
    return self;
}



-(void) placeTreeStumpAtX:(float)xCoord withGroundY:(float)yCoord{
    PhysicsSprite *stump = [PhysicsSprite spriteWithSpriteFrameName:@"TreeStump.png"];
    stump.position = ccp(xCoord+stump.boundingBox.size.width/2,(yCoord + 40));
    [self.foregroundBatch addChild:stump];
    [stump setRectHeight:76 withWidth:75 withXOffset:0 andYOffset:0];
}

-(void) placeBranchAtX:(double)xVal andY:(double)yVal{
    PhysicsSprite *branch = [PhysicsSprite spriteWithSpriteFrameName:@"TreeBranch.png"];
    branch.position = ccp(xVal+branch.boundingBox.size.width/2,yVal+branch.boundingBox.size.height/2);
    [self.foregroundBatch addChild:branch];
    [branch setRectFromBoundingBox];
}

-(void) placeLogAtX:(float)xCoord withGroundY:(float)yCoord{
    PhysicsSprite *log = [PhysicsSprite spriteWithSpriteFrameName:@"Log.png"];
    log.position = ccp(xCoord+log.boundingBox.size.width/2,(yCoord + 40));
    [self.foregroundBatch addChild:log];
    [log setRectHeight:76 withWidth:230 withXOffset:0 andYOffset:0];
}

-(void) placeTreeAtX:(float)xCoord withGroundY:(float)yCoord andNumSegments:(int)numSegments{
    PhysicsSprite *Treebase = [PhysicsSprite spriteWithSpriteFrameName:@"TreeMedium.png"];
    Treebase.position = ccp(xCoord+Treebase.boundingBox.size.width/2,(yCoord + 80));
    [self.foregroundBatch addChild:Treebase];
    [Treebase setRectHeight:154 withWidth:75 withXOffset:0 andYOffset:0];
    if (numSegments > 1){
        int yPosition = yCoord + 80;
        while (numSegments > 1){
            yPosition += 155;
            PhysicsSprite *Treesegment = [PhysicsSprite spriteWithSpriteFrameName:@"TreeSegment.png"];
            Treesegment.position = ccp(xCoord+Treebase.boundingBox.size.width/2, yPosition);
            [self.foregroundBatch addChild:Treesegment];
            [Treesegment setRectHeight:160 withWidth:75 withXOffset:0 andYOffset:0];
            numSegments -= 1;
        }
    }
}

-(void) makeTreeWalkway:(double)xStart groundY:(double)groundY numLogs:(int)numLogs{
    [self placeTreeAtX:xStart withGroundY:80 andNumSegments:1];
    for (int i = 0; i < numLogs; i++){
        [self placeTreeAtX:xStart + LOG_WIDTH*(1+i) withGroundY:groundY andNumSegments:1];
        [self placeLogAtX:xStart + LOG_WIDTH*i + 50 withGroundY:groundY+155];
    }
}

-(void) makeTreeWalkwayWithStumps:(double)xStart groundY:(double)groundY numLogs:(int)numLogs{
    [self placeTreeStumpAtX:xStart withGroundY:groundY];
    [self makeTreeWalkway:xStart+STUMP_WIDTH groundY:groundY numLogs:numLogs];
    [self placeTreeStumpAtX:xStart + STUMP_WIDTH*2 + LOG_WIDTH*numLogs withGroundY:groundY];
}

-(void) layoutBranchesAtX:(double) xStart y:(double)yVal numBranches:(int)numBranches{
    for (int i = 0;i < numBranches; i++){
        [self placeBranchAtX:xStart+BRANCH_WIDTH*i andY:yVal];
    }
}


-(void) setupLevel3Foreground{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestSpriteSheet.plist"];
    
    self.foregroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestSpriteSheet.png"];
    [self addChild:self.foregroundBatch];
    
    [self placeTreeAtX:-50 withGroundY:80 andNumSegments:4];
    [self placeTreeStumpAtX:610 withGroundY:80];
    [self placeLogAtX:770 withGroundY:80];
    [self placeLogAtX:1600 withGroundY:80];
    [self placeTreeStumpAtX:1765 withGroundY:80];
    [self placeTreeStumpAtX:1970 withGroundY:80];
    [self placeLogAtX:1845 withGroundY:155];
    [self placeTreeStumpAtX:2215 withGroundY:80];
    [self placeLogAtX:2090 withGroundY:155];
    [self placeTreeStumpAtX:2460 withGroundY:80];
    [self placeLogAtX:2335 withGroundY:155];
    [self placeTreeStumpAtX:2705 withGroundY:80];
    [self placeLogAtX:2580 withGroundY:155];
    [self placeTreeStumpAtX:2950 withGroundY:80];
    [self placeLogAtX:2825 withGroundY:155];
    [self placeTreeStumpAtX:3195 withGroundY:80];
    [self placeLogAtX:3070 withGroundY:155];
    [self placeTreeStumpAtX:3440 withGroundY:80];
    [self placeLogAtX:3315 withGroundY:155];
    
    for (int xPos = 5000; xPos < 5600; xPos += 245) {
        if (xPos == 5000){
            [self placeTreeStumpAtX:xPos withGroundY:80]; //only does this once
        }
        [self placeTreeStumpAtX:xPos + 245 withGroundY:80];
        [self placeLogAtX:xPos + 125 withGroundY:155];
    }
    
    for (int xPos = 6000; xPos < 7200; xPos += 245) {
        if (xPos == 6000){
            [self placeTreeAtX:xPos withGroundY:80 andNumSegments:1]; //only does this once
        }
        [self placeTreeAtX:xPos + 245 withGroundY:80 andNumSegments:1];
        [self placeLogAtX:xPos + 125 withGroundY:235];
    }
    [self placeTreeStumpAtX:7315 withGroundY:80];
    
    PhysicsSprite *ground = [PhysicsSprite spriteWithFile:@"ForestGround.png"];
    ground.position = ccp(240,20);
}

-(void) setupLevel2Foreground{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestSpriteSheet.plist"];
    
    self.foregroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestSpriteSheet.png"];
    [self addChild:self.foregroundBatch];
    
    [self placeTreeAtX:-100 withGroundY:GROUND_Y andNumSegments:4];
    
    for (int i = 0; i < 3; i++){
        [self placeLogAtX:800 + LOG_WIDTH*i withGroundY:GROUND_Y];
    }
    [self makeTreeWalkway:800+LOG_WIDTH*3 groundY:GROUND_Y numLogs:5]; //place where the 3 logs end
    
    //At around x=2830 now
    [self placeTreeStumpAtX:2830 withGroundY:GROUND_Y];
    
    [self layoutBranchesAtX:2962 y:GROUND_Y+220 numBranches:5];
    [self placeTreeAtX:3500 withGroundY:GROUND_Y andNumSegments:2];
    [self layoutBranchesAtX:3510 y:GROUND_Y+SEGMENT_HEIGHT*2-5 numBranches:5];
    
    [self placeTreeAtX:3985 withGroundY:GROUND_Y andNumSegments:2];
    [self layoutBranchesAtX:4060 y:240 numBranches:10];
    [self layoutBranchesAtX:5230 y:300 numBranches:3];
    [self layoutBranchesAtX:5620 y:270 numBranches:2];
    [self layoutBranchesAtX:5900 y:330 numBranches:5];
    
    [self placeTreeStumpAtX:6500 withGroundY:GROUND_Y];
    [self placeTreeAtX:6500+STUMP_WIDTH withGroundY:GROUND_Y andNumSegments:1];
    [self layoutBranchesAtX:6500+STUMP_WIDTH+10 y:GROUND_Y+SEGMENT_HEIGHT-5 numBranches:8];
    [self placeTreeAtX:7400 withGroundY:GROUND_Y andNumSegments:1];
    
}

-(void) setupLevel1Foreground{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestSpriteSheet.plist"];
    
    self.foregroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestSpriteSheet.png"];
    [self addChild:self.foregroundBatch];
    
    //leave a lot of empty space
    
    [self placeTreeAtX:-200 withGroundY:GROUND_Y andNumSegments:4];
    
    [self placeTreeStumpAtX:2400 withGroundY:GROUND_Y];
    [self makeTreeWalkway:2400+STUMP_WIDTH groundY:GROUND_Y numLogs:11];
    [self placeTreeStumpAtX:5270 withGroundY:GROUND_Y];
    [self layoutBranchesAtX:7000 y:GROUND_Y+80 numBranches:8];
    [self layoutBranchesAtX:7920 y:GROUND_Y+150 numBranches:15];
    [self layoutBranchesAtX:9620 y:GROUND_Y+80 numBranches:12];

    
}

-(void) setupLevel4Foreground{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestSpriteSheet.plist"];
    
    self.foregroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestSpriteSheet.png"];
    [self addChild:self.foregroundBatch];
    
}

-(void) setupLevel5Foreground{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ForestSpriteSheet.plist"];
    
    self.foregroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"ForestSpriteSheet.png"];
    [self addChild:self.foregroundBatch];
    
}

-(void) setupLevel6Foreground{
    
}



-(void) drawAllRects{
    for (PhysicsSprite *sprite in self.foregroundBatch.children){
        [sprite drawRect];
    }
}

-(void) nextFrame:(ccTime)dt{
    //move all sprites
    for (PhysicsSprite *sprite in self.foregroundBatch.children){
        [sprite moveSpriteWithScreen:(colliderInstance.backgroundSpeedX * dt) withYSpeed:(colliderInstance.backgroundSpeedY*dt)];
    }
    
}

@end
