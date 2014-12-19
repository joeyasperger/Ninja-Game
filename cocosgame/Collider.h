//
//  Collider.h
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Collider : NSObject


@property (assign, readwrite) float backgroundSpeedX;
@property (assign, readwrite) float screenAdjustmentSpeedX;//kinda confusing, but how the backround is moving excluding offsetting the ninja's movement, so what its doing to move ninja to different sides of screen
@property (assign, readwrite) float backgroundSpeedY;
@property (assign, readwrite) float gravity;
@property (assign, readwrite) float groundY;



//call this from gamelayer and this will call all other neccessary functions from self
-(void) runCollisionResponse:(ccTime)dt;

//for ninja
-(void) runNinjaCollisionResponse:(ccTime)dt;

-(void) runEnemyToForegroundCollision:(ccTime)dt;


-(void) setFinalBackgroundSpeedX:(ccTime)dt;
-(void) setFinalBackgroundSpeedY;


@end
