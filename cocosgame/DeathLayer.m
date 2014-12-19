//
//  DeathLayer.m
//  NinjaGame
//
//  Created by Joey on 7/1/13.
//
//

#import "DeathLayer.h"
#import "NinjaStarLayer.h"
#import "MainMenuLayer.h"
#import "ForegroundLayer.h"
#import "BackgroundLayer.h"
#import "EnemyLayer.h"
#import "NinjaLayer.h"
#import "GameLayer.h"
#import "LoadingLayer.h"

@implementation DeathLayer

@synthesize isActive = _isActive;
@synthesize tryAgainLabel = _tryAgainLabel;
@synthesize tryAgainSprite = _tryAgainSprite;
@synthesize quitLabel = _quitLabel;
@synthesize quitSprite = _quitSprite;
@synthesize gameOverLabel = _gameOverLabel;
@synthesize timeSinceDeath = _timeSinceDeath;
@synthesize blackPixel = _blackPixel;

-(id)init{
    if ((self = [super init])){
        self.isTouchEnabled = NO;
        self.visible = NO;
        self.isActive = false;

        
    }
    return self;
}

-(void) activateDeathLayer{
    self.isTouchEnabled = true;
    self.visible = true;
    self.isActive = true;
    CGSize screen = [[CCDirector sharedDirector] winSize];
    [self schedule:@selector(nextFrame:)];
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


    self.blackPixel = [CCSprite spriteWithFile:@"BlackPixel.png"];
    self.blackPixel.position = ccp(screen.width/2,screen.height/2);
    self.blackPixel.scaleX = screen.width*2;
    self.blackPixel.scaleY = screen.height*2;
    self.blackPixel.opacity = 0;
    [self addChild:self.blackPixel];
    
    self.gameOverLabel = [CCLabelTTF labelWithString:@"YOU DIED!" fontName:@"Noteworthy-Bold" fontSize:40];
    self.gameOverLabel.position = ccp(screen.width/2, screen.height-70);
    self.gameOverLabel.color = ccc3(220,0,0);
    self.gameOverLabel.opacity = 0;
    [self addChild:self.gameOverLabel];
    
    self.tryAgainSprite = [CCSprite spriteWithFile:@"BlueButton.png"];
    self.tryAgainSprite.position = ccp(screen.width-100, 60);
    self.tryAgainSprite.opacity = 0;
    [self addChild:self.tryAgainSprite];
    
    self.tryAgainLabel = [CCLabelTTF labelWithString:@"Retry" fontName:@"Noteworthy-Bold" fontSize:30];
    self.tryAgainLabel.position = ccp(screen.width-100, 60);
    self.tryAgainLabel.color = ccc3(0,0,0);
    self.tryAgainLabel.opacity = 0;
    [self addChild:self.tryAgainLabel];
    
    
    
    self.quitSprite = [CCSprite spriteWithFile:@"BlueButton.png"];
    self.quitSprite.position = ccp(100, 60);
    self.quitSprite.opacity = 0;
    [self addChild:self.quitSprite];
    
    self.quitLabel = [CCLabelTTF labelWithString:@"Quit" fontName:@"Noteworthy-Bold" fontSize:30];
    self.quitLabel.position = ccp(100, 60);
    self.quitLabel.color = ccc3(0,0,0);
    self.quitLabel.opacity = 0;
    [self addChild:self.quitLabel];
    
    
    
}

-(void) nextFrame:(ccTime)dt{
    self.timeSinceDeath += dt;
    if (self.blackPixel.opacity <180){
        self.blackPixel.opacity += 300*dt;
    }
    if (self.gameOverLabel.opacity <240){
        self.gameOverLabel.opacity += 400*dt;
        self.quitSprite.opacity += 400*dt;
        self.quitLabel.opacity += 400*dt;
        self.tryAgainSprite.opacity += 400*dt;
        self.tryAgainLabel.opacity += 400*dt;
    }
    else{
        self.gameOverLabel.opacity = 255;
        self.quitSprite.opacity = 255;
        self.quitLabel.opacity = 255;
        self.tryAgainSprite.opacity = 255;
        self.tryAgainLabel.opacity = 255;
    }
}


-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(self.quitSprite.boundingBox, location)){
        CCSprite *tempSprite = [CCSprite spriteWithFile:@"GreyedOutButton.png"];
        tempSprite.position = self.quitSprite.position;
        tempSprite.opacity = self.quitSprite.opacity;
        [self removeChild:self.quitSprite cleanup:true];
        self.quitSprite = tempSprite;
        [self addChild:self.quitSprite];
        [LoadingLayer startMainMenu];
    }
    if (CGRectContainsPoint(self.tryAgainSprite.boundingBox, location)){
        CCSprite *tempSprite = [CCSprite spriteWithFile:@"GreyedOutButton.png"];
        tempSprite.position = self.tryAgainSprite.position;
        tempSprite.opacity = self.tryAgainSprite.opacity;
        [self removeChild:self.tryAgainSprite cleanup:true];
        self.tryAgainSprite = tempSprite;
        [self addChild:self.tryAgainSprite];
        [LoadingLayer startLevel:gameLayerInstance.gameLevel];
    }
    return true;
}

@end
