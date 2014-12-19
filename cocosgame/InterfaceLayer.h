//
//  InterfaceLayer.h
//  NinjaGame
//
//  Created by Joseph Asperger on 11/7/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InterfaceLayer : CCLayer

{
    CCLabelTTF *healthLabel;
    CCLabelTTF *energyLabel;
    CCLabelTTF *experienceLabel;
}

//for creating and updating a string displaying the health the ninja has left
-(void) addHealthLabel;

-(void) addEnergyLabel;
-(void) addExperienceLabel;

-(void) updateHealthLabel;
-(void) updateEnergyLabel;
-(void) updateExperienceLable;

@end
