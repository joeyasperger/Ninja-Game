//
//  GameLayer.m
//  cocosgame
//
//  Created by Joey on 12/5/12.
//  Copyright Joey Asperger 2012. All rights reserved.
//



// Import the interfaces
#import "GameLayer.h"
#import "JoystickClass.h"
#import "NinjaLayer.h"
#import "NinjaStarLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCTouchDispatcher.h"
#import <math.h>
#import "PauseLayer.h"
//#import "ForegroundLayer.h"
#import "Collider.h"
#import "PhysicsSprite.h"
#import "BackgroundLayer.h"
#import "ForegroundLayer.h"
#import "PauseLayer.h"
#import "HitDetector.h"
#import "EnemySprite.h"
#import "EnemyLayer.h"
#import "EnemyHealthbarLayer.h"
#import "DeathLayer.h"
#import "FlashingLayer.h"
#import "LevelCompleteLayer.h"




// HelloWorldLayer implementation
@implementation GameLayer

@synthesize timeLabel = _timeLabel;

@synthesize pauseButton = _pauseButton;

@synthesize hitDetectorInstance = _hitDetectorInstance;
@synthesize damageDisplayList = _damageDisplayList;

@synthesize playerLevel = _playerLevel;
@synthesize playerExperience = _playerExperience;
@synthesize damageLevel = _damageLevel;
@synthesize healthLevel = _healthLevel;

@synthesize gameLevel = _gameLevel;

@synthesize levelTime = _levelTime;

@synthesize enemyList = _enemyList;
// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init]) ) {
        self.levelTime = 0;
        self.overallPosition = 0;
        
        [self loadUserDefaults];
        
        joystickVars = [[JoystickClass alloc] init];
        [joystickVars setXPos:90 withYPos:75];
        
        colliderInstance = [[Collider alloc] init];
        self.hitDetectorInstance = [[HitDetector alloc] init];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"InterfaceSpriteSheet.plist"];
        self.interfaceBatch = [CCSpriteBatchNode batchNodeWithFile:@"InterfaceSpriteSheet.png"];
        [self addChild:self.interfaceBatch];
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        joystickpad = [CCSprite spriteWithFile:@"joystickpadround.png"];
        joystickpad.position = ccp(90,75);
        [self addChild:joystickpad];
        
        [self setupProgressBars];
        
        joystick = [CCSprite spriteWithFile:@"joystick.png"];
        joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
        [self addChild:joystick];
        
        
        
        self.pauseButton = [CCSprite spriteWithFile:@"pausebutton.png"];
        self.pauseButton.position = ccp((windowSize.width-40),(windowSize.height-65));
        [self addChild: self.pauseButton];
        
        //create timer
        int minutes = self.levelTime / 60; //will truncate this
        int seconds = (int)self.levelTime % 60;
        NSString *timeString = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
        self.timeLabel = [CCLabelTTF labelWithString:timeString fontName:@"Noteworthy-Bold" fontSize:20];
        self.timeLabel.color = ccc3(100, 100, 100);
        self.timeLabel.position = ccp((windowSize.width-50),(windowSize.height-30));
        [self addChild:self.timeLabel];
        
        [self schedule:@selector(nextFrame:)];
        
        colliderInstance.backgroundSpeedX = 0;
        ninjaLayerInstance.ninja.xVelocity = 0;
        
        
        self.isTouchEnabled = YES;
        
        self.damageDisplayList = [NSMutableArray new];
        
    }
    return self;
}



- (void) nextFrame:(ccTime)dt{
    
    self.levelTime +=dt;
    
    self.enemyList = [NSMutableArray new];
    for (EnemySprite *sprite in enemyLayerInstance.enemyBatch.children){
        [self.enemyList addObject:sprite];
    }
    for (EnemySprite *sprite in enemyLayerInstance.wolfBatch.children){
        [self.enemyList addObject:sprite];
    }
    
    //check if anything got hit
    [self.hitDetectorInstance runHitDetection:dt];
    
    //detect and analyze all collisions
    [colliderInstance runNinjaCollisionResponse:dt];
    
    //run enemy AI
    for (EnemySprite *enemy in self.enemyList){
        [enemy nextFrame:dt];
    }
    [colliderInstance runEnemyToForegroundCollision:dt];
    
    [ninjaLayerInstance.ninja moveSpriteWithScreen:(colliderInstance.backgroundSpeedX*dt) withYSpeed:(colliderInstance.backgroundSpeedY*dt)];
    colliderInstance.groundY += colliderInstance.backgroundSpeedY*dt;
    
    for (EnemySprite *enemy in self.enemyList){
        [enemy updateHealthbar];//because the way the background moves will mess up its position
    }
    
    [self updateDamageLabels:dt];
    
    //if ninja dies
    if ((ninjaLayerInstance.healthLeft <=0) && (deathLayerInstance.isActive == false)){
        [deathLayerInstance activateDeathLayer];
    }
    
    [self.enemyList release];
    
    //update time
    int minutes = self.levelTime / 60; //will truncate this
    int seconds = (int)self.levelTime % 60;
    NSString *timeString = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    self.timeLabel.string = timeString;
    
    [self checkLevelComplete];
}

-(void) applyJoystickInput{
    //START OF HOW NINJA SHOULD BE CONTROLLED FROM GROUND
    if (!ninjaLayerInstance.inAir){
        //to set crouching
        if (joystickVars->direction8==8){
            ninjaLayerInstance.ninja.xVelocity = 200;
            [ninjaLayerInstance setAnimation:CROUCH_RUN_RIGHT];
        }
        if (joystickVars->direction8==6){
            ninjaLayerInstance.ninja.xVelocity = -200;
            [ninjaLayerInstance setAnimation:CROUCH_RUN_LEFT];
        }
        
        //to set idle animations
        if (joystickVars->direction8 == 0){
            ninjaLayerInstance.ninja.xVelocity = 0;
            if ((([ninjaLayerInstance getDirectionFacing]) == 'R') && (ninjaLayerInstance.inAir == NO)){
                [ninjaLayerInstance setAnimation:IDLE_RIGHT];
            }
            if ((([ninjaLayerInstance getDirectionFacing]) == 'L') && (ninjaLayerInstance.inAir == NO)){
                [ninjaLayerInstance setAnimation:IDLE_LEFT];
            }
        }
        
        if (joystickVars->direction8 == 7){
            if (([ninjaLayerInstance getDirectionFacing] == 'R') && (ninjaLayerInstance.inAir == NO)){
                [ninjaLayerInstance setAnimation:CROUCH_IDLE_RIGHT];
                ninjaLayerInstance.ninja.xVelocity = 0;
            }
            if (([ninjaLayerInstance getDirectionFacing] == 'L') && (ninjaLayerInstance.inAir == NO)){
                [ninjaLayerInstance setAnimation:CROUCH_IDLE_LEFT];
                ninjaLayerInstance.ninja.xVelocity = 0;
            }
        }
        
        //to set running animations
        if ((joystickVars->direction8 == 1) && (ninjaLayerInstance.inAir == NO)){
            ninjaLayerInstance.ninja.xVelocity= 500;
            [ninjaLayerInstance setAnimation:RUN_RIGHT];
        }
        if ((joystickVars->direction8 == 5) && (ninjaLayerInstance.inAir == NO)){
            ninjaLayerInstance.ninja.xVelocity = -500;
            [ninjaLayerInstance setAnimation:RUN_LEFT];
        }
        
        
        //to set jumping animations
        if ((joystickVars->direction8==2) || (joystickVars->direction8==3) || (joystickVars->direction8==4)){
            [ninjaLayerInstance startJump]; //will attempt to jump if not already in air
            //set animation
            if (joystickVars->direction =='R'){
                ninjaLayerInstance.ninja.xVelocity = 500;
                [ninjaLayerInstance setAnimation:JUMP_RIGHT];
            }
            if (joystickVars->direction=='L'){
                ninjaLayerInstance.ninja.xVelocity = -500;
                [ninjaLayerInstance setAnimation:JUMP_LEFT];
            }
        }
    }
    
    //END OF GROUND-BASED CONTROL
    
    //STUFF THAT NEEDS TO BE DONE WHILE NINJA IS IN THE AIR
    
    //to change direction mid-air
    if (ninjaLayerInstance.inAir == YES){
        if (joystickVars->direction == 'L'){
            [ninjaLayerInstance setAnimation:JUMP_LEFT];
            if (ninjaLayerInstance.ninja.xVelocity >= -500){
                ninjaLayerInstance.ninja.xVelocity -= 50;
            }
        }
        
        if (joystickVars->direction == 'R'){
            [ninjaLayerInstance setAnimation:JUMP_RIGHT];
            if (ninjaLayerInstance.ninja.xVelocity <= 500){
                ninjaLayerInstance.ninja.xVelocity += 50;
            }
            
        }
        //if not direction is selected
        if (joystickVars->direction == '0'){
            //set proper animations
            if (([ninjaLayerInstance getDirectionFacing])=='R'){
                [ninjaLayerInstance setAnimation:JUMP_RIGHT];
            }
            if (([ninjaLayerInstance getDirectionFacing])=='L'){
                [ninjaLayerInstance setAnimation:JUMP_LEFT];
            }
            
            //slow the velocity to zero because
            if (ninjaLayerInstance.ninja.xVelocity <= 0){
                ninjaLayerInstance.ninja.xVelocity += 30;
            }
            if (ninjaLayerInstance.ninja.xVelocity >= 0){
                ninjaLayerInstance.ninja.xVelocity -= 30;
            }
        }
    }
    
    //END OF STUFF THAT NEEDS TO BE DONE IN THE AIR
    
    
}

-(void) setupProgressBars{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    //CAN DEFINETELY CREATE OTHER FUNCTION TO REDUCE CODE HERE
    //set up health bar
    ninjaHealthBar = [CCSprite spriteWithSpriteFrameName:@"HealthBar.png"];
    ninjaHealthProgressTimer = [CCProgressTimer progressWithSprite:ninjaHealthBar];
    ninjaHealthProgressTimer.type = kCCProgressTimerTypeBar;
    ninjaHealthProgressTimer.position = ccp(80,(windowSize.height - 20));
    ninjaHealthProgressTimer.midpoint = ccp(0,.5f);
    ninjaHealthProgressTimer.barChangeRate = ccp(1,0);
    ninjaHealthProgressTimer.percentage = 100;
    ninjaHealthProgressTimer.opacity = 160;
    [self addChild:ninjaHealthProgressTimer];
    
    //set up experience bar
    experienceBar = [CCSprite spriteWithSpriteFrameName:@"ExperienceBar.png"];
    experienceProgressTimer = [CCProgressTimer progressWithSprite:experienceBar];
    experienceProgressTimer.type = kCCProgressTimerTypeBar;
    experienceProgressTimer.position = ccp(80,(windowSize.height - 60));
    experienceProgressTimer.midpoint = ccp(0,.5f);
    experienceProgressTimer.barChangeRate = ccp(1,0);
    experienceProgressTimer.percentage = 100;
    experienceProgressTimer.opacity = 160;
    [self addChild:experienceProgressTimer];
    
    //set up energy bar
    energyBar = [CCSprite spriteWithSpriteFrameName:@"EnergyBar.png"];
    energyProgressTimer = [CCProgressTimer progressWithSprite:energyBar];
    energyProgressTimer.type = kCCProgressTimerTypeBar;
    energyProgressTimer.position = ccp(80,(windowSize.height - 40));
    energyProgressTimer.midpoint = ccp(0,.5f);
    energyProgressTimer.barChangeRate = ccp(1,0);
    energyProgressTimer.percentage = 100;
    energyProgressTimer.opacity = 160;
    [self addChild:energyProgressTimer];
    
    ninjaHealthBarBackground = [CCSprite spriteWithSpriteFrameName:@"HealthBarBox.png"];
    ninjaHealthBarBackground.position = ccp(80,(windowSize.height - 20));
    ninjaHealthBarBackground.opacity = 140;
    [self.interfaceBatch addChild:ninjaHealthBarBackground];
    
    experienceBarBackground = [CCSprite spriteWithSpriteFrameName:@"HealthBarBox.png"];
    experienceBarBackground.position = ccp(80,(windowSize.height - 60));
    experienceBarBackground.opacity = 140;
    [self.interfaceBatch addChild:experienceBarBackground];
    
    energyBarBackground = [CCSprite spriteWithSpriteFrameName:@"HealthBarBox.png"];
    energyBarBackground.position = ccp(80,(windowSize.height - 40));
    energyBarBackground.opacity = 140;
    [self.interfaceBatch addChild:energyBarBackground];
}

-(int) levelUpPoints{
    return self.playerLevel + 2 - self.damageLevel - self.healthLevel - self.energyLevel;
}

-(void) updateHealthBar{
    ninjaHealthProgressTimer.percentage = (((float)ninjaLayerInstance.healthLeft / (float)ninjaLayerInstance.maxHealth) * 100);
}

-(void) updateDamageLabels:(ccTime)dt{
    //update display labels for damage
    for (int i = [self.damageDisplayList count]; i>0; i--){
        CCLabelTTF *damageLabel = [self.damageDisplayList objectAtIndex:i-1];
        damageLabel.position = ccp(damageLabel.position.x + colliderInstance.backgroundSpeedX*dt, damageLabel.position.y + 80*dt + colliderInstance.backgroundSpeedY*dt);
        damageLabel.opacity -= 3;
        if (damageLabel.opacity <10){
            [self removeChild:damageLabel cleanup:true];
            [self.damageDisplayList removeObject:damageLabel];
        }
    }
}

-(void) addDamageDisplay:(int)damage color:(char)color sizeMultiple:(float)sizeMultiple position:(CGPoint)position{
    NSString *damageString = [NSString stringWithFormat:@"%d",damage];
    CCLabelTTF *damageLabel = [CCLabelTTF labelWithString:damageString fontName:@"Noteworthy-Bold" fontSize:20 * sizeMultiple];
    damageLabel.position = position;
    if (color == 'r'){
        damageLabel.color = ccc3(218,0,0);
    }
    if (color == 'g'){
        damageLabel.color = ccc3(35,215,41);
    }
    [self addChild:damageLabel];
    [self.damageDisplayList addObject:damageLabel];
}

-(void) addBlockDamageDisplay:(CGPoint)position{
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Blocked" fontName:@"Noteworthy-Bold" fontSize:20];
    label.color = ccc3(150,150,150);
    label.position = position;
    [self addChild:label];
    [self.damageDisplayList addObject:label];
}

-(void) loadUserDefaults{
    //Load Stats
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.playerLevel = [defaults integerForKey:@"playerLevel"];
    self.playerExperience = [defaults integerForKey:@"playerExperience"];
    self.damageLevel = [defaults integerForKey:@"damageLevel"];
    self.energyLevel = [defaults integerForKey:@"energyLevel"];
    self.healthLevel = [defaults integerForKey:@"healthLevel"];
    
    //testing
    self.healthLevel = 4;
    self.damageLevel = 3;
    self.energyLevel = 3;
    self.playerLevel = 20;
    
    //change stats from zero if it's first run
    if (self.playerLevel == 0){
        self.playerLevel = 1;
    }
    if (self.playerExperience == 0){
        self.playerExperience = 1;
    }
    if (self.damageLevel == 0){
        self.damageLevel = 1;
    }
    if (self.energyLevel == 0){
        self.energyLevel = 1;
    }
    if (self.healthLevel == 0){
        self.healthLevel = 1;
    }
}



-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (sqrtf(powf((location.x-joystickVars->xInitPosition),2.0)+powf((location.y-joystickVars->yInitPosition),2.0))<=100){
        [joystickVars moveJoystick:location.x withY:location.y];
        [joystickVars joystickDirection];
        joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
        if ((joystickVars->direction)=='R'){
            [ninjaLayerInstance setDirectionFacing:'R'];
        }
        if ((joystickVars->direction)=='L'){
            [ninjaLayerInstance setDirectionFacing:'L'];
        }
        
        return YES;
    }
    if (sqrtf(powf((location.x-self.pauseButton.position.x),2.0)+powf((location.y-self.pauseButton.position.y),2.0))<=35){
        [joystickVars restorePosition];
        [joystickVars touchEnded];
        joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
        self.isTouchEnabled = NO;
        [pauseLayerInstance activatePauseLayer];
        
        return YES;
        
    }
    
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (sqrtf(powf((location.x-joystickVars->xInitPosition),2.0)+powf((location.y-joystickVars->yInitPosition),2.0))<=100){
        [joystickVars moveJoystick:location.x withY:location.y];
        [joystickVars joystickDirection];
        joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
        if ((joystickVars->direction)=='R'){
            [ninjaLayerInstance setDirectionFacing:'R'];
        }
        if ((joystickVars->direction)=='L'){
            [ninjaLayerInstance setDirectionFacing:'L'];
        }
        
    }else{
        joystickVars->direction = '0';
        [joystickVars restorePosition];
        [joystickVars touchEnded];
        joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
    }
    
    
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    joystickVars->direction = '0';
    [joystickVars touchEnded];
    [joystickVars restorePosition];
    
    joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    joystickVars->direction = '0';
    [joystickVars restorePosition];
    [joystickVars touchEnded];
    joystick.position = ccp(joystickVars->xPosition,joystickVars->yPosition);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    [joystickVars release];
    [colliderInstance release];
    [self.hitDetectorInstance release];
    [self.damageDisplayList release];
    
    // don't forget to call "super dealloc"
    [super dealloc];
}

-(void) usePoisonAbility{
    // First check if can use ability
    // DECREASE ENERGY
    [enemyLayerInstance poisonEnemiesOnScreen];
    [flashingLayerInstance flashColor:ccc3(0,150,0)];
}

-(void) useFreezeAbility{
    //check if possible
    //decrease energy
    
    [enemyLayerInstance freezeEnemiesOnScreen];
    [flashingLayerInstance flashColor:ccc3(150,150,255)];
}

-(void) useOverdriveAbility{
    //check if possible
    //decrease energy
    
    [flashingLayerInstance flashColor:ccc3(150,0,0)];
    [ninjaLayerInstance activateOverdrive];
}

-(void) useInvisibilityAbility{
    //check if possible
    //decrease energy
    
    [flashingLayerInstance flashColor:ccc3(110, 110, 110)];
    [ninjaLayerInstance activateInvisibility];
}

-(void) checkLevelComplete{
    switch (self.gameLevel){
        case 1:
            if (self.overallPosition > 11000){
                [self completeLevel];
            }
            break;
    }
}

-(void) completeLevel{
    if (!levelCompleteTransitionStarted){
        CCScene *scene = [LevelCompleteLayer createSceneWithLevel:self.gameLevel time:self.levelTime kills:self.enemiesKilled stealthKills:self.stealthKills damageTaken:self.damageTaken];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccBLACK]];
        levelCompleteTransitionStarted = true;
    }
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}
@end
