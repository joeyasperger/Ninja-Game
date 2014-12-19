//
//  GenericBackgroundLayer.h
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer

//all the batches I might use
@property (assign,readwrite) CCSpriteBatchNode *groundBatch;
@property (assign,readwrite) CCSpriteBatchNode *treeBatch;

-(void) addNightSky;
-(void) addRedSky;
-(void) addDaySky;
-(void) addSnowSky;

-(void) placeTreeAtX:(double)xCoord withGroundY:(double)yCoord andNumSegments:(int)numSegments parallaxFactor:(double)parallaxFactor;


// adds frames to cache, sets up batch, and lays out 4 layers of paralax trees
-(void) setupTreeBackgroundWithXStart:(double)xStart xEnd:(double)xEnd numSegments:(int)numSegments;
-(void) setupForestGroundWithXStart:(double)xStart xEnd:(double)xEnd;


-(void) addForestGround;
-(void) addDesertGround;
-(void) addSnowGround;


-(void) setupLevel1Background;
-(void) setupLevel2Background;
-(void) setupLevel3Background;
-(void) setupLevel4Background;
-(void) setupLevel5Background;
-(void) setupLevel6Background;

@end


@interface BackgroundSprite : CCSprite

@property (readwrite, assign) float parallaxFactor;

@end