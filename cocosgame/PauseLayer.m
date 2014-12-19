//
//  PauseLayer.m
//  cocosgame
//
//  Created by Joey on 1/16/13.
//
//

#import "PauseLayer.h"
//#import "BackgroundLayer.h"
#import "NinjaStarLayer.h"
#import "MainMenuLayer.h"
#import "ForegroundLayer.h"
#import "BackgroundLayer.h"
#import "EnemyLayer.h"
#import "NinjaLayer.h"
#import "LoadingLayer.h"


@implementation PauseLayer

-(id) init
{
    if( (self = [super init]) ){
        [self schedule:@selector(nextFrame:)];
        self.isTouchEnabled = true;
        isActive = false;
        buttonsAreVisible = false;
        plusButtonsActive = false;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PauseMenuSpriteSheet.plist"];
        pauseBatch = [CCSpriteBatchNode batchNodeWithFile:@"PauseMenuSpriteSheet.png"];
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        pauseScreen = [CCSprite spriteWithFile:@"pausebackground.png"];
        pauseScreen.position = ccp((windowSize.width/2),(windowSize.height/2));
        [self addChild:pauseScreen];
        pauseScreen.visible = NO;
        
        [self addResumeAndQuitButtons];
        
        [self addLevelDisplay];
        
        [self addLevelIcons:@"Damage" spriteFile:@"DamageLevelIcon.png" yCoord:(windowSize.height/2 + 80) numIcons:gameLayerInstance.damageLevel];
        [self addLevelIcons:@"Health" spriteFile:@"HealthLevelIcon.png" yCoord:(windowSize.height/2 +30) numIcons:gameLayerInstance.healthLevel];
        [self addLevelIcons:@"Energy" spriteFile:@"EnergyLevelIcon.png" yCoord:(windowSize.height/2 -20) numIcons:gameLayerInstance.energyLevel];
        
        [self checkPlusButtons];
        [self addChild:pauseBatch];
        pauseBatch.visible = false;
    }
    return self;
}

-(void) addResumeAndQuitButtons{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    resumeButton = [CCSprite spriteWithFile:@"BlackButton.png"];
    resumeButton.position = ccp(((windowSize.width/2)+100),((windowSize.height/2)-80));
    [self addChild:resumeButton];
    resumeButton.visible = NO;
    
    quitButton = [CCSprite spriteWithFile:@"BlackButton.png"];
    quitButton.position = ccp(((windowSize.width/2)-100),((windowSize.height/2)-80));
    [self addChild:quitButton];
    quitButton.visible = NO;
    
    quitLabel = [CCLabelTTF labelWithString:@"Quit" fontName:@"Noteworthy-Bold" fontSize:30];
    quitLabel.position = ccp(((windowSize.width/2)-100),((windowSize.height/2)-80));
    [self addChild:quitLabel];
    quitLabel.color = ccc3(255, 255, 255);
    quitLabel.visible = false;
    quitLabel.zOrder = 2;
    
    resumeLabel = [CCLabelTTF labelWithString:@"Resume" fontName:@"Noteworthy-Bold" fontSize:30];
    resumeLabel.position = ccp(((windowSize.width/2)+100),((windowSize.height/2)-80));
    [self addChild:resumeLabel];
    resumeLabel.color = ccc3(255, 255, 255);
    resumeLabel.visible = false;
    resumeLabel.zOrder = 2;
}

-(void) addLevelIcons:(NSString *)text spriteFile:(NSString *)fileName yCoord:(float)yCoord numIcons:(int)numIcons{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *healthLabel = [CCLabelTTF labelWithString:text fontName:@"Noteworthy-Bold" fontSize:20];
    healthLabel.position = ccp((windowSize.width/2 - 130), yCoord);
    healthLabel.color = ccc3(255,255,255);
    healthLabel.visible = false;
    [self addChild:healthLabel];
    
    for (int i = 0; i < numIcons; i++){
        CCSprite *icon = [CCSprite spriteWithSpriteFrameName:fileName];
        icon.position = ccp((windowSize.width/2 - 60 + i*28), yCoord);
        [pauseBatch addChild:icon];
    }
}

-(void) addSingleLevelIcon:(NSString *)filename yPos:(float)yPos skillLevel:(int)skillLevel{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCSprite *icon = [CCSprite spriteWithSpriteFrameName:filename];
    icon.position = ccp((windowSize.width/2 - 60 + (skillLevel-1)*28), yPos);
    [pauseBatch addChild:icon];
}

-(void) activateLevelUpButtons{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    //tried to do this in addPlusButton function but then I couldn't access it by the intance variable
    //so I gues they need to be initialized before being passed as arguments
    damagePlusButton = [CCSprite spriteWithSpriteFrameName:@"PlusButton.png"];
    healthPlusButton = [CCSprite spriteWithSpriteFrameName:@"PlusButton.png"];
    energyPlusButton = [CCSprite spriteWithSpriteFrameName:@"PlusButton.png"];
    
    if (gameLayerInstance.damageLevel < 8){
        [self addPlusButton:damagePlusButton yPos:(windowSize.height/2 + 80)];
    }
    if (gameLayerInstance.healthLevel < 8){
        [self addPlusButton:healthPlusButton yPos:(windowSize.height/2 + 30)];
    }
    if (gameLayerInstance.energyLevel < 8){
        [self addPlusButton:energyPlusButton yPos:(windowSize.height/2 - 20)];
    }
    
    plusButtonsActive = true;
}

-(void) deactivateLevelUpButtons{
    if (damagePlusButton){
        [pauseBatch removeChild:damagePlusButton cleanup:true];
    }
    if (healthPlusButton){
        [pauseBatch removeChild:healthPlusButton cleanup:true];
    }
    if (energyPlusButton){
        [pauseBatch removeChild:energyPlusButton cleanup:true];
    }
    plusButtonsActive = false;
}

-(void) addPlusButton:(CCSprite *)plusButton yPos:(float)yPos{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    plusButton.position = ccp((windowSize.width/2 + 170),yPos);
    [pauseBatch addChild:plusButton];
}

-(void) checkPlusButtons{
    if (!plusButtonsActive){
        if ([gameLayerInstance levelUpPoints] > 0){
            [self activateLevelUpButtons];
        }
    }
    if (plusButtonsActive){
        if ([gameLayerInstance levelUpPoints] <= 0){
            [self deactivateLevelUpButtons];
        }
        if (damagePlusButton && (gameLayerInstance.damageLevel >= 8)){
            [self removeChild:damagePlusButton cleanup:true];
        }
        if (healthPlusButton && (gameLayerInstance.healthLevel >= 8)){
            [self removeChild:healthPlusButton cleanup:true];
        }
        if (energyPlusButton && (gameLayerInstance.energyLevel >= 8)){
            [self removeChild:energyPlusButton cleanup:true];
        }
    }
}

-(void) addLevelDisplay{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    NSString *string = [NSString stringWithFormat:@"Level %d Ninja", gameLayerInstance.playerLevel];
    CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:string fontName:@"Noteworthy-Bold" fontSize:20];
    levelLabel.position = ccp(windowSize.width/2, windowSize.height/2 + 117);
    levelLabel.color = ccc3(255,255,255);
    [self addChild:levelLabel];
    levelLabel.visible = false;
}

-(void) nextFrame:(ccTime)dt{
    //make buttons visible after menu expands
    if ((isActive)&&(buttonsAreVisible==NO)&&(pauseScreen.scaleX ==1)){
        for (CCSprite *sprite in self.children){
            sprite.visible = YES;
            
        }
        buttonsAreVisible = YES;
    }
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    //checking if resumebutton was pressed
    if ((isActive)&&(buttonsAreVisible)&&(CGRectContainsPoint(resumeButton.boundingBox, location))){
        [self deactivatePauseLayer];
        return YES;
    }
    
    //checking if menubutton was pressed
    if ((isActive)&&(buttonsAreVisible)&&(CGRectContainsPoint(quitButton.boundingBox, location))){
        CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlueButton.png"];
        tempSprite.position = quitButton.position;
        [self removeChild:quitButton cleanup:true];
        quitButton = tempSprite;
        [self addChild:quitButton];
        [LoadingLayer startMainMenu];
    }
    
    if (isActive && buttonsAreVisible && plusButtonsActive){
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        if (gameLayerInstance.damageLevel < 8){
            if (CGRectContainsPoint(CGRectInset(damagePlusButton.boundingBox, -5, -5), location)){
                gameLayerInstance.damageLevel += 1;
                [gameLayerInstance levelup];
                [self addSingleLevelIcon:@"DamageLevelIcon.png" yPos:(windowSize.height/2 + 80) skillLevel:gameLayerInstance.damageLevel];

            }
        }
        if (gameLayerInstance.healthLevel < 8){
            if (CGRectContainsPoint(CGRectInset(healthPlusButton.boundingBox, -5, -5), location)){
                gameLayerInstance.healthLevel += 1;
                [gameLayerInstance levelup];
                [self addSingleLevelIcon:@"HealthLevelIcon.png" yPos:(windowSize.height/2 + 30) skillLevel:gameLayerInstance.healthLevel];
                [ninjaLayerInstance adjustMaxHealth];
            }
        }
        if (gameLayerInstance.energyLevel < 8){
            if (CGRectContainsPoint(CGRectInset(energyPlusButton.boundingBox, -5, -5), location)){
                gameLayerInstance.energyLevel += 1;
                [gameLayerInstance levelup];
                [self addSingleLevelIcon:@"EnergyLevelIcon.png" yPos:(windowSize.height/2 - 20) skillLevel:gameLayerInstance.energyLevel];
            }
        }
        [self checkPlusButtons];
    }
    

    return NO;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) activatePauseLayer{
    [self pauseAllGameplayLayers];
    self.isTouchEnabled = YES;
    isActive = YES;
    pauseScreen.visible = YES;
    [pauseScreen setScaleX:.001];
    [pauseScreen runAction:[CCScaleTo actionWithDuration:.11 scaleX:1 scaleY:1]];
}

-(void) pauseAllGameplayLayers{
    [ninjaLayerInstance pauseSchedulerAndActions];
    [ninjaLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
    [backgroundLayerInstance pauseSchedulerAndActions];
    [backgroundLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
    
    [ninjaStarLayerInstance pauseSchedulerAndActions];
    [ninjaStarLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
    [foregroundLayerInstance pauseSchedulerAndActions];
    [foregroundLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
    [gameLayerInstance pauseSchedulerAndActions];
    [gameLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
    [enemyLayerInstance pauseSchedulerAndActions];
    [enemyLayerInstance.children makeObjectsPerformSelector:@selector(pauseSchedulerAndActions)];
}

-(void) deactivatePauseLayer{
    self.isTouchEnabled = NO;
    isActive = NO;
    for (CCSprite *sprite in self.children){
        sprite.visible = NO;
    }
    buttonsAreVisible = NO;
    pauseScreen.visible = NO;
    //[pauseScreen runAction:[CCScaleTo actionWithDuration:.07 scaleX:1 scaleY:1]];
    //[pauseScreen runAction:[CCMoveTo actionWithDuration:.1 position:ccp(400,285)]];
    [ninjaLayerInstance resumeSchedulerAndActions];
    [ninjaLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    [backgroundLayerInstance resumeSchedulerAndActions];
    [backgroundLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    [gameLayerInstance resumeSchedulerAndActions];
    [gameLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    [foregroundLayerInstance resumeSchedulerAndActions];
    [foregroundLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    [ninjaStarLayerInstance resumeSchedulerAndActions];
    [ninjaStarLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    [enemyLayerInstance resumeSchedulerAndActions];
    [enemyLayerInstance.children makeObjectsPerformSelector:@selector(resumeSchedulerAndActions)];
    gameLayerInstance.isTouchEnabled = YES;

}

@end
