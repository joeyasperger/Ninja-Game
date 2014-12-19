//
//  WolfEnemy.h
//  NinjaGame
//
//  Created by Joey on 7/17/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemySprite.h"

@interface WolfEnemy : EnemySprite

//variables for patrolling
@property (assign,readwrite) int range;
@property (assign,readwrite) int patrolSpeed;


//animations
-(void) animateWalkRight;
-(void) animateWalkLeft;


@end
