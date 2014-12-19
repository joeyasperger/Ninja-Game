//
//  LevelCompleteScene.m
//  NinjaGame
//
//  Created by Joey on 7/24/13.
//
//

#import "LevelCompleteLayer.h"
#import "Timer.h"
#import "LoadingLayer.h"

@implementation LevelCompleteLayer

+(CCScene*) createSceneWithLevel:(int)level time:(double)time kills:(int)kills stealthKills:(int)stealthKills damageTaken:(int)damageTaken{
    
    CCScene *scene = [CCScene node];
    LevelCompleteLayer *layer = [LevelCompleteLayer node];
    [scene addChild:layer];
    
    layer.level = level;
    layer.levelTime = time;
    layer.kills = kills;
    layer.stealthKills = stealthKills;
    layer.damageTaken = damageTaken;
    
    return scene;
}

-(id) init{
    if ((self = [super init])){
        [self schedule:@selector(nextFrame:)];
        CGSize screen = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = true;
        
        fieldTimer = [Timer new];
        [fieldTimer activateTimer:1];
        
        /*
        CCSprite *background = [CCSprite spriteWithFile:@"WhitePixel.png"];
        background.position = ccp(screen.width/2,screen.height/2);
        background.scaleX = screen.width*2;
        background.scaleY = screen.height*2;
        [self addChild:background];*/
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainmenuspritesheet.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"menubackground.png"];
        background.position = ccp(screen.width/2,screen.height/2);
        [self addChild:background];
        
        headerLabel = [CCLabelTTF labelWithString:@"Level Complete!" fontName:@"Baskerville-BoldItalic" fontSize:40];
        headerLabel.color = ccc3(255, 0, 0);
        headerLabel.position = ccp(screen.width/2,screen.height-60);
        [self addChild:headerLabel];
        fontGrowing = true;
        
        CCLabelTTF *killsLabel = [CCLabelTTF labelWithString:@"Kills:" fontName:@"Noteworthy-Bold" fontSize:20];
        killsLabel.position = ccp(screen.width/2-10-killsLabel.boundingBox.size.width/2,screen.height-110);
        killsLabel.color = ccBLACK;
        [self addChild:killsLabel];
        
        CCLabelTTF *stealthKillsLabel = [CCLabelTTF labelWithString:@"Stealth Kills:" fontName:@"Noteworthy-Bold" fontSize:20];
        stealthKillsLabel.position = ccp(screen.width/2-10-stealthKillsLabel.boundingBox.size.width/2,screen.height-140);
        stealthKillsLabel.color = ccBLACK;
        [self addChild:stealthKillsLabel];
        
        CCLabelTTF *damageTakenLabel = [CCLabelTTF labelWithString:@"Damage Taken:" fontName:@"Noteworthy-Bold" fontSize:20];
        damageTakenLabel.position = ccp(screen.width/2-10-damageTakenLabel.boundingBox.size.width/2,screen.height-170);
        damageTakenLabel.color = ccBLACK;
        [self addChild:damageTakenLabel];
        
        CCLabelTTF *timeLabel = [CCLabelTTF labelWithString:@"Time:" fontName:@"Noteworthy-Bold" fontSize:20];
        timeLabel.position = ccp(screen.width/2-10-timeLabel.boundingBox.size.width/2,screen.height-200);
        timeLabel.color = ccBLACK;
        [self addChild:timeLabel];
        
        mapButton = [CCSprite spriteWithFile:@"BlackButton.png"];
        mapButton.position = ccp(screen.width-80,50);
        [self addChild:mapButton];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Map" fontName:@"Noteworthy-Bold" fontSize:20];
        label.position = mapButton.position;
        label.color = ccWHITE;
        label.zOrder = 4;
        [self addChild:label];
        
    }
    return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(mapButton.boundingBox, location)){
        [self mapButtonPressed];
        return true;
    }
    return false;
}

-(void) createKillsField{
    CGSize screen = [[CCDirector sharedDirector] winSize];

    currentKills = 0;
    NSString *killsString = [NSString stringWithFormat:@"%d",(int)currentKills];
    killsField = [CCLabelTTF labelWithString:killsString fontName:@"Noteworthy-Bold" fontSize:20];
    killsField.position = ccp(screen.width/2+killsField.boundingBox.size.width/2,screen.height-110);
    killsField.color = ccBLACK;
    [self addChild:killsField];
}

-(void) createStealthKillsField{
    CGSize screen = [[CCDirector sharedDirector] winSize];
    
    currentStealthKills = 0;
    NSString *stealthKillsString = [NSString stringWithFormat:@"%d",(int)currentStealthKills];
    stealthKillsField = [CCLabelTTF labelWithString:stealthKillsString fontName:@"Noteworthy-Bold" fontSize:20];
    stealthKillsField.position = ccp(screen.width/2+stealthKillsField.boundingBox.size.width/2,screen.height-110);
    stealthKillsField.color = ccBLACK;
    [self addChild:stealthKillsField];
}

-(void) createDamageField{
    CGSize screen = [[CCDirector sharedDirector] winSize];
    
    currentDamageTaken = 0;
    NSString *damageString = [NSString stringWithFormat:@"%d",(int)currentDamageTaken];
    damageTakenField = [CCLabelTTF labelWithString:damageString fontName:@"Noteworthy-Bold" fontSize:20];
    damageTakenField.position = ccp(screen.width/2+damageTakenField.boundingBox.size.width/2,screen.height-170);
    damageTakenField.color = ccBLACK;
    [self addChild:damageTakenField];
}

-(void) createTimeField{
    CGSize screen = [[CCDirector sharedDirector] winSize];
    
    currentTime = 0;
    NSString *timeString = [NSString stringWithFormat:@"%d:%02d",(int)(currentTime/60),(int)currentTime%60];
    timeField = [CCLabelTTF labelWithString:timeString fontName:@"Noteworthy-Bold" fontSize:20];
    timeField.position = ccp(screen.width/2+timeField.boundingBox.size.width/2,screen.height-200);
    timeField.color = ccBLACK;
    [self addChild:timeField];
}

-(void) nextFrame:(ccTime)dt{
    [self cycleHeader:dt];
    
    [fieldTimer advanceTimer:dt];
    if ([fieldTimer expired]) {
        [self createKillsField];
        mode = 1;
        [fieldTimer deactivateTimer];
    }
    
    if (mode == 1){
        [self updateKillsField:dt];
    }
    else if (mode == 2){
        [self updateStealthKillsField:dt];
    }
    else if (mode == 3){
        [self updateDamageField:dt];
    }
    else if (mode == 4){
        [self updateTimeField:dt];
    }
  
}

-(void) updateKillsField:(ccTime)dt{
    if (currentKills < self.kills){
        currentKills += 20 *dt;
    }
    else{
        currentKills = self.kills;
        mode = 2;
        if (!stealthKillsField){
            [self createStealthKillsField];
        }
    }
    CGSize screen = [[CCDirector sharedDirector] winSize];
    NSString *killsString = [NSString stringWithFormat:@"%d",(int)currentKills];
    killsField.string = killsString;
    killsField.position = ccp(screen.width/2+killsField.boundingBox.size.width/2,screen.height-110);
}

-(void) updateStealthKillsField:(ccTime)dt{
    if (currentStealthKills < self.stealthKills){
        currentStealthKills += 15 *dt;
    }
    else{
        currentStealthKills = self.stealthKills;
        mode = 3;
        if (!damageTakenField){
            [self createDamageField];
        }
    }
    CGSize screen = [[CCDirector sharedDirector] winSize];
    NSString *stealthKillsString = [NSString stringWithFormat:@"%d",(int)currentStealthKills];
    stealthKillsField.string = stealthKillsString;
    stealthKillsField.position = ccp(screen.width/2+stealthKillsField.boundingBox.size.width/2,screen.height-140);
}

-(void) updateDamageField:(ccTime)dt{
    if (currentDamageTaken < self.damageTaken){
        currentDamageTaken += 50 *dt;
    }
    else{
        currentDamageTaken = self.damageTaken;
        mode = 4;
        if (!timeField){
            [self createTimeField];
        }
    }
    CGSize screen = [[CCDirector sharedDirector] winSize];
    NSString *damageString = [NSString stringWithFormat:@"%d",(int)currentDamageTaken];
    damageTakenField.string = damageString;
    damageTakenField.position = ccp(screen.width/2+damageTakenField.boundingBox.size.width/2,screen.height-170);
}

-(void) updateTimeField:(ccTime)dt{
    if (currentTime < self.levelTime){
        currentTime += 60 *dt;
    }
    else{
        currentTime = self.levelTime;
        mode = 5;
    }
    CGSize screen = [[CCDirector sharedDirector] winSize];
    NSString *timeString = [NSString stringWithFormat:@"%d:%02d",(int)(currentTime/60),(int)currentTime%60];
    timeField.string = timeString;
    timeField.position = ccp(screen.width/2+timeField.boundingBox.size.width/2,screen.height-200);}

-(void) cycleHeader:(ccTime)dt{
    // Make the header label grow and shrink cyclicly
    if (fontGrowing){
        headerLabel.fontSize += pow((61-headerLabel.fontSize),1.4)/1.3*dt; // give a bouncing feel to the
        // cycles so the font will grow/shrink quicker when it is smaller
        if (headerLabel.fontSize > 50){
            fontGrowing = false;
        }
    }
    else{
        headerLabel.fontSize -= pow((61-headerLabel.fontSize),1.4)/1.3*dt;
        if (headerLabel.fontSize < 40){
            fontGrowing = true;
        }
    }
}

-(void) mapButtonPressed{
    CCSprite *temp = [CCSprite spriteWithFile:@"BlueButton.png"];
    temp.position = mapButton.position;
    [self removeChild:mapButton cleanup:true];
    mapButton = temp;
    [self addChild:mapButton];          
    [LoadingLayer enterLevelSelectScene];
}

-(void) dealloc{
    [fieldTimer release];
    [super dealloc];
}

@end
