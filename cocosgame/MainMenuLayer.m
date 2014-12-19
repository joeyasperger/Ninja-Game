//
//  MainMenu.m
//  cocosgame
//
//  Created by Joey on 1/23/13.
//
//

#import "MainMenuLayer.h"
#import "GameLayer.h"
#import <math.h>
#import "GameScene.h"
#import "LevelSelectLayer.h"
#define pi 3.14159


@implementation MainMenuLayer

+(CCScene*) scene{
    CCScene *scene = [CCScene node];
    CCLayer * mainMenuLayerInstance = [MainMenuLayer node];
    [scene addChild:mainMenuLayerInstance];
    return scene;
}

-(id) init{
    if( (self = [super init]) ){
        self.isTouchEnabled = YES;
        [self schedule:@selector(nextFrame:)];
        isPlayGamePressed = NO;
        isSettingsPressed = NO;
        isCreditsPressed = NO;
        playGameMoved = NO;
        settingsMoved = NO;
        creditsMoved = NO;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainmenuspritesheet.plist"];
        CCSpriteBatchNode *menuBatch = [CCSpriteBatchNode batchNodeWithFile:@"mainmenuspritesheet.png"];
        [self addChild:menuBatch];
        
    
        menuBackground = [CCSprite spriteWithSpriteFrameName:@"menubackground.png"];
        menuBackground.position = ccp([[CCDirector sharedDirector] winSize].width/2, [[CCDirector sharedDirector] winSize].height/2);
        [menuBatch addChild:menuBackground];
        
        playGame = [CCSprite spriteWithSpriteFrameName:@"playgame.png"];
        playGame.position = ccp(-120, (4.8*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:playGame];
        
        playGamePressed = [CCSprite spriteWithSpriteFrameName:@"playgamepressed.png"];
        playGamePressed.position = ccp([[CCDirector sharedDirector] winSize].width/3.3, (4.8*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:playGamePressed];
        playGamePressed.visible = NO;
        
        settings = [CCSprite spriteWithSpriteFrameName:@"settings.png"];
        settings.position = ccp(-100, (3*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:settings];
        
        settingsPressed = [CCSprite spriteWithSpriteFrameName:@"settingspressed.png"];
        settingsPressed.position = ccp([[CCDirector sharedDirector] winSize].width/3.3, (3*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:settingsPressed];
        settingsPressed.visible = NO;
        
        
        credits = [CCSprite spriteWithSpriteFrameName:@"credits.png"];
        credits.position = ccp(-120, (1.2*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:credits];
        
        creditsPressed = [CCSprite spriteWithSpriteFrameName:@"creditspressed.png"];
        creditsPressed.position = ccp([[CCDirector sharedDirector] winSize].width/3.3, (1.2*[[CCDirector sharedDirector] winSize].height)/6);
        [menuBatch addChild:creditsPressed];
        creditsPressed.visible = NO;
        
        
        ninja = [CCSprite spriteWithSpriteFrameName:@"menuninja.png"];
        ninja.position = ccp([[CCDirector sharedDirector] winSize].width/1.35, (1*[[CCDirector sharedDirector] winSize].height)/2);
        [menuBatch addChild:ninja];
        
    }
    return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(playGame.boundingBox, location)){
        playGame.visible = NO;
        playGamePressed.visible = YES;
        isPlayGamePressed = YES;
        return YES;
    }
    if (CGRectContainsPoint(settings.boundingBox, location)){
        settings.visible = NO;
        settingsPressed.visible = YES;
        isSettingsPressed = YES;
        return YES;
    }
    
    if (CGRectContainsPoint(credits.boundingBox, location)){
        credits.visible = NO;
        creditsPressed.visible = YES;
        isCreditsPressed = YES;
        return YES;
    }

    return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (isPlayGamePressed){
        if (CGRectContainsPoint(playGame.boundingBox, location)){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.5 scene:[LevelSelectLayer scene] withColor:ccBLACK]];
        }
        else{
            playGame.visible = YES;
            playGamePressed.visible = NO;
            isPlayGamePressed = NO;
        }
    }
    if (isSettingsPressed){
        if (CGRectContainsPoint(settings.boundingBox, location)){
        }
        else{
            settings.visible = YES;
            settingsPressed.visible = NO;
            isSettingsPressed = NO;
        }
    }
    if (isCreditsPressed){
        if (CGRectContainsPoint(credits.boundingBox, location)){
        }
        else{
            credits.visible = YES;
            creditsPressed.visible = NO;
            isCreditsPressed = NO;
        }
        
    }
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (isPlayGamePressed){
        if ((CGRectContainsPoint(playGame.boundingBox, location))==NO){
            playGame.visible = YES;
            playGamePressed.visible = NO;
            isPlayGamePressed = NO;
        }
    }
    if (isSettingsPressed){
        if ((CGRectContainsPoint(settings.boundingBox, location))==NO){
            settings.visible = YES;
            settingsPressed.visible = NO;
            isSettingsPressed = NO;
        }
    }
    if (isCreditsPressed){
        if ((CGRectContainsPoint(credits.boundingBox, location))==NO){
            credits.visible = YES;
            creditsPressed.visible = NO;
            isCreditsPressed = NO;
        }
        
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    playGame.visible = YES;
    playGamePressed.visible = NO;
    isPlayGamePressed = NO;
    settings.visible = YES;
    settingsPressed.visible = NO;
    isSettingsPressed = NO;
    credits.visible = YES;
    creditsPressed.visible = NO;
    isCreditsPressed = NO;
    
}

-(void) nextFrame: (ccTime)dt{
    time += dt;
    if ((time>.5)&&(playGameMoved == NO)){
        [playGame runAction:[CCMoveTo actionWithDuration:.3 position:ccp([[CCDirector sharedDirector] winSize].width/3.3, (4.8*[[CCDirector sharedDirector] winSize].height)/6)]];
        playGameMoved = YES;
    }
    if ((time>.8)&&(settingsMoved == NO)){
        [settings runAction:[CCMoveTo actionWithDuration:.3 position:ccp([[CCDirector sharedDirector] winSize].width/3.3, (3*[[CCDirector sharedDirector] winSize].height)/6)]];
        settingsMoved = YES;
    }
    if ((time>1.1)&&(creditsMoved == NO)){
        [credits runAction:[CCMoveTo actionWithDuration:.3 position:ccp([[CCDirector sharedDirector] winSize].width/3.3, (1.2*[[CCDirector sharedDirector] winSize].height)/6)]];
        creditsMoved = YES;
    }
    
    [self killStarsOutsideScreen];
    
    //change this if I want to bring back random ninja stars
    int num = arc4random()%120;
    if (num <= 4){
        //[self shootNinjaStar];
    }
}

-(void) shootNinjaStar{
    int num = arc4random()%4;
    CCSprite *ninjaStar = [CCSprite spriteWithFile:@"ninjastar-hd.png"];
    CGSize size = [[CCDirector sharedDirector] winSize];
    int velocity = 450;
    int angle = arc4random()%180;
    float angleRadians = ((angle*pi)/180);
    switch (num){
        case 1:
            ninjaStar.position = ccp(-30,(arc4random()%(int)(size.height)));
            angleRadians -= pi/2;
            break;
        case 2:
            ninjaStar.position = ccp((size.width+30),(arc4random()%(int)(size.height)));
            angleRadians += pi/2;
            break;
        case 3:
            ninjaStar.position = ccp((arc4random()%(int)(size.width)),-30);
            break;
        case 4:
            ninjaStar.position = ccp((arc4random()%(int)(size.width)),(size.height+30));
            angleRadians += pi;
            break;
    }
    [self addChild:ninjaStar];
    [ninjaStar runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.015f angle:15]]];
    [ninjaStar runAction:[CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:1 position: ccp((velocity*cosf(angleRadians)), (velocity*sinf(angleRadians)))]]];
}

-(void) killStarsOutsideScreen{
    CGSize size = [[CCDirector sharedDirector] winSize];
    for (CCSprite *sprite in self.children){
        if ((sprite.position.x>(size.width+200))||(sprite.position.x<-200)||(sprite.position.y>(size.height+200))||(sprite.position.y<-200)){
            [self removeChild:sprite cleanup:YES];
        }
    }
}

@end
