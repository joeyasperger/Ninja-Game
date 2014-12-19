//
//  HitDetector.h
//  NinjaGame
//
//  Created by Joey on 3/16/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HitDetector : NSObject

@property (assign,readwrite) NSMutableArray *enemyHitBoxList;
@property (assign,readwrite) NSMutableArray *ninjaHitBoxList;

-(void) runHitDetection:(ccTime) dt;
-(void) runNinjaStarHitDetection:(ccTime) dt;


-(void) drawHitBoxes;

@end


