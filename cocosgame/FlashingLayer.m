//
//  FlashingLayer.m
//  NinjaGame
//
//  Created by Joseph Asperger on 12/19/13.
//
//

#import "FlashingLayer.h"

@implementation FlashingLayer

-(id) init{
    if (self = [super init]){
        [self schedule:@selector(nextFrame:)];
    }
    return self;
}

-(void) nextFrame:(ccTime)dt{
    for (FlashingSprite *sprite in self.children){
        sprite.opacity -= 1000*dt;
        if (sprite.opacity <= 0){
            [self removeChild:sprite cleanup:true];
        }
    }
}

-(void) flashColor:(ccColor3B)color{
    FlashingSprite * sprite = [FlashingSprite spriteWithFile:@"WhitePixel.png"];
    CGSize screen = [[CCDirector sharedDirector] winSize];
    sprite.position = ccp(screen.width/2,screen.height/2);
    sprite.scaleX = screen.width*2;
    sprite.scaleY = screen.height*2;
    sprite.opacity = 255;
    sprite.color = color;
    [self addChild:sprite];
}

@end

@implementation FlashingSprite

@synthesize gettingBrighter = _gettingBrighter;

@end