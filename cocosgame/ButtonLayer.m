//
//  ButtonLayer.m
//  NinjaGame
//
//  Created by Joey on 2/26/13.
//
//

#import "ButtonLayer.h"
#import "NinjaLayer.h"
#import "GameLayer.h"

@implementation ButtonLayer

-(id) init{
    if ( (self = [super init]) ){
        self.isTouchEnabled = YES;
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        lightAttackButton = [CCSprite spriteWithFile:@"LightAttackButton.png"];
        lightAttackButton.position = ccp((windowSize.width-60),80);
        [self addChild: lightAttackButton];
        
        blockButton = [CCSprite spriteWithFile:@"BlockButton.png"];
        blockButton.position = ccp(windowSize.width-130,50);
        [self addChild:blockButton];
        
    }
    return self;
}


-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(lightAttackButton.boundingBox, location)){
        [self pressLightAttack];
        return true;
    }
    else if (CGRectContainsPoint(blockButton.boundingBox, location)){
        [self pressBlockButton];
        return true;
    }
    return false;
}

-(void) pressLightAttack{
    if (!ninjaLayerInstance.isDisabled){
        [ninjaLayerInstance startLightAttack];
    }
    CCSprite *tempSprite = [CCSprite spriteWithFile:@"LightAttackButtonPressed.png"];
    tempSprite.position = lightAttackButton.position;
    [self removeChild:lightAttackButton cleanup:true];
    lightAttackButton = tempSprite;
    [self addChild:lightAttackButton];
    lightPressed = true;
}

-(void) depressLightAttack{
    CGPoint position = lightAttackButton.position;
    [self removeChild:lightAttackButton cleanup:true];
    lightAttackButton = [CCSprite spriteWithFile:@"LightAttackButton.png"];
    lightAttackButton.position = position;
    [self addChild:lightAttackButton];
    lightPressed = false;
}

-(void) pressBlockButton{
    //GAMEPLAYSTUFF
    
    CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlockButtonPressed.png"];
    tempSprite.position = blockButton.position;
    [self removeChild:blockButton cleanup:true];
    blockButton = tempSprite;
    [self addChild:blockButton];
    blockPressed = true;
    [ninjaLayerInstance startBlock];
}

-(void) depressBlockButton{
    CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlockButton.png"];
    tempSprite.position = blockButton.position;
    [self removeChild:blockButton cleanup:true];
    blockButton = tempSprite;
    [self addChild:blockButton];
    blockPressed = false;
    [ninjaLayerInstance endBlock];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (lightPressed){
        [self depressLightAttack];
    }
    else if (blockPressed){
        [self depressBlockButton];
    }
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    [self ccTouchEnded:touch withEvent:event];
}



@end
