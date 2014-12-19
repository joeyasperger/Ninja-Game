//
//  InterfaceLayer.m
//  NinjaGame
//
//  Created by Joseph Asperger on 11/7/13.
//
//

#import "InterfaceLayer.h"
#import "NinjaLayer.h"
#import "GameLayer.h"

@implementation InterfaceLayer

-(id) init{
    if (self = [super init]){
        [self schedule:@selector(nextFrame:)];
        [self addHealthLabel];
        [self addEnergyLabel];
    }
    return self;
}

-(void) nextFrame:(ccTime)dt{
    [self updateHealthLabel];
    [self updateEnergyLabel];
}

-(void) addHealthLabel{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    NSString *string = [NSString stringWithFormat:@"%d/%d", ninjaLayerInstance.healthLeft, ninjaLayerInstance.maxHealth];
    healthLabel = [CCLabelTTF labelWithString:string fontName:@"Noteworthy-Bold" fontSize:13];
    healthLabel.color = ccc3(100,100,100);
    healthLabel.position = ccp(150,(windowSize.height-19));
    [self addChild:healthLabel];
}

-(void) updateHealthLabel{
    NSString *string = [NSString stringWithFormat:@"%d/%d", ninjaLayerInstance.healthLeft, ninjaLayerInstance.maxHealth];
    healthLabel.string = string;
}

-(void) addEnergyLabel{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    NSString *string = [NSString stringWithFormat:@"%d/%d", gameLayerInstance.energyRemaining,gameLayerInstance.maxEnergy];
    energyLabel = [CCLabelTTF labelWithString:string fontName:@"Noteworthy-Bold" fontSize:13];
    energyLabel.color = ccc3(100,100,100);
    energyLabel.position = ccp(150, (windowSize.height-40));
    [self addChild:energyLabel];
}

-(void) updateEnergyLabel{
    NSString *string = [NSString stringWithFormat:@"%d/%d", gameLayerInstance.energyRemaining,gameLayerInstance.maxEnergy];
    energyLabel.string = string;
}

@end
