//
//  RectDrawingLayer.m
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import "RectDrawingLayer.h"
#import "ForegroundLayer.h"
#import "GameLayer.h"
#import "NinjaLayer.h"
#import "Collider.h"
#import "PhysicsSprite.h"
#import "EnemyLayer.h"
#import "HitDetector.h"

@implementation RectDrawingLayer


-(void) draw{
    ccDrawColor4B(255, 255, 255, 0);
    [foregroundLayerInstance drawAllRects];
    [ninjaLayerInstance drawAllRects];
    [enemyLayerInstance drawAllRects];
    ccDrawLine(ccp(0,colliderInstance.groundY), ccp(480,colliderInstance.groundY));
    
    glLineWidth(1.8f);
    ccDrawColor4B(255, 0, 0, 0);
    
    [gameLayerInstance.hitDetectorInstance drawHitBoxes];
    
    [super draw];
}

@end
