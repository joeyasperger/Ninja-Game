//
//  FlashingLayer.h
//  NinjaGame
//
//  Created by Joseph Asperger on 12/19/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FlashingLayer : CCLayer

-(void) flashColor:(ccColor3B)color;

@end

@interface FlashingSprite : CCSprite

@property (assign,readwrite) bool gettingBrighter; 

@end