//
//  GenericEnemyLayer.h
//  NinjaGame
//
//  Created by Joey on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyLayer : CCLayer

@property (assign, readwrite) CCSpriteBatchNode *enemyBatch;
@property (assign, readwrite) CCSpriteBatchNode *wolfBatch;


//for adding different kinds of enemies
-(void) addStillNinjaEnemy:(CGPoint)position withType:(char)type andDirection:(char)direction;
-(void) addPatrolingNinjaEnemy:(CGPoint)position type:(char)type direction:(char)direction patrolRange:(int)patrolRange;
-(void) addStillBanditEnemy:(CGPoint)position withType:(char)type andDirection:(char)direction;
-(void) addPatrolingBanditEnemy:(CGPoint)position type:(char)type direction:(char)direction patrolRange:(int)patrolRange;

-(void) addPatrolingWolf:(CGPoint)position diretion:(char)direction range:(int)range;

//for batches
-(void) startWolfBatch;

//for setting up each level
-(void) setupLevel1EnemyLayer;
-(void) setupLevel2EnemyLayer;
-(void) setupLevel3EnemyLayer;
-(void) setupLevel4EnemyLayer;
-(void) setupLevel5EnemyLayer;
-(void) setupLevel6EnemyLayer;

-(void) poisonEnemiesOnScreen;
-(void) freezeEnemiesOnScreen;

-(void) drawAllRects;


@end
