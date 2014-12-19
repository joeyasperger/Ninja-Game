//
//  GenericForegroundLayer.h
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ForegroundLayer : CCLayer

{
    double STUMP_WIDTH;
    double BRANCH_WIDTH;
    double SEGMENT_HEIGHT;
    double SEGMENT_WIDTH;
    double LOG_WIDTH;
    int GROUND_Y;
}

@property (assign, readwrite) CCSpriteBatchNode *foregroundBatch;

//Functions for creating objects from forest spritesheet
-(void) placeTreeStumpAtX:(float) xCoord withGroundY:(float) yCoord;
-(void) placeLogAtX:(float) xCoord withGroundY:(float) yCoord;
-(void) placeTreeAtX:(float) xCoord withGroundY:(float) yCoord andNumSegments:(int) numSegments;

-(void) layoutBranchesAtX:(double) xStart y:(double)yVal numBranches:(int)numBranches;
-(void) placeBranchAtX:(double)xVal andY:(double)yVal;


// lays out logs on top of one-segment trees
// NOTE: player cant jump high enough to make it up this unassisted
-(void) makeTreeWalkway:(double) xStart groundY: (double) groundY numLogs: (int) numLogs;

// makes a walkway and puts stumps before and after it so you can jump up to it
-(void) makeTreeWalkwayWithStumps:(double) xStart groundY: (double) groundY numLogs: (int) numLogs;


// lays out logs on top of stumps
-(void) makeStumpWalkway:(double) xStart groundY: (double) groundY xEnd: (double) xEnd;

//for creating each level
-(void) setupLevel1Foreground;
-(void) setupLevel2Foreground;
-(void) setupLevel3Foreground;
-(void) setupLevel4Foreground;
-(void) setupLevel5Foreground;

-(void) drawAllRects;

@end
