//
//  AbilityButtons.m
//  NinjaGame
//
//  Created by Joseph Asperger on 12/20/13.
//
//

#import "AbilityButtonLayer.h"
#import "GameLayer.h"

@implementation AbilityButtonLayer

-(id) init{
    if ( (self = [super init]) ){
        self.isTouchEnabled = YES;
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        poisonButton = [CCSprite spriteWithFile:@"PoisonButton.png"];
        poisonButton.position = ccp(windowSize.width/2 - 50, windowSize.height - 30);
        [self addChild:poisonButton];
        
        invisibilityButton = [CCSprite spriteWithFile:@"InvisibilityButton.png"];
        invisibilityButton.position = ccp(windowSize.width/2-10, windowSize.height - 60);
        [self addChild:invisibilityButton];
        
        freezeButton = [CCSprite spriteWithFile:@"FreezeButton.png"];
        freezeButton.position = ccp(windowSize.width/2+30, windowSize.height - 30);
        [self addChild:freezeButton];
        
        smashButton = [CCSprite spriteWithFile:@"PoisonButton.png"];
        smashButton.position = ccp(windowSize.width/2+70, windowSize.height - 60);
        [self addChild:smashButton];
        
        overdriveButton = [CCSprite spriteWithFile:@"OverdriveButton.png"];
        overdriveButton.position = ccp(windowSize.width/2 + 110, windowSize.height - 30);
        [self addChild:overdriveButton];
        
        poisonButton.opacity = 150;
        invisibilityButton.opacity = 150;
        freezeButton.opacity = 150;
        smashButton.opacity = 150;
        overdriveButton.opacity = 150;
        
    }
    return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(freezeButton.boundingBox, location)){
        [self pressFreezeButton];
        return true;
    }
    else if (CGRectContainsPoint(poisonButton.boundingBox, location)){
        [self pressPoisonButton];
        return true;
    }
    else if (CGRectContainsPoint(invisibilityButton.boundingBox, location)){
        [self pressInvisibilityButton];
        return true;
    }
    else if (CGRectContainsPoint(overdriveButton.boundingBox, location)){
        [self pressOverdriveButton];
        return true;
    }
    return false;
}

-(void) pressPoisonButton{
    [gameLayerInstance usePoisonAbility];
}

-(void) pressFreezeButton{
    [gameLayerInstance useFreezeAbility];
}

-(void) pressInvisibilityButton{
    [gameLayerInstance useInvisibilityAbility];
}

-(void) pressOverdriveButton{
    [gameLayerInstance useOverdriveAbility];
}

-(void) pressSmashButton{
    
}

@end
