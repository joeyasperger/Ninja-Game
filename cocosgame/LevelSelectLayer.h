//
//  LevelSelectLayer.h
//  NinjaGame
//
//  Created by Joey on 5/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelSelectLayer : CCLayer

@property (assign,readwrite) NSMutableArray *iconList; //contains LevelIcons


//play button and back button
@property (assign,readwrite) CCSprite *playGameSprite;
@property (assign,readwrite) CCLabelTTF *playGameLabel;
@property (assign,readwrite) CCSprite *backSprite;
@property (assign,readwrite) CCLabelTTF *backLabel;
@property (assign,readwrite) BOOL buttonsActive;
@property (assign,readwrite) float clickTimer; //to determine whether a touch is a swipe or click
@property (assign,readwrite) BOOL isSwiping;
@property (assign,readwrite) float positionX; //to move back after stuff is off the screen
@property (assign,readwrite) float lastPositionX; //for determining speed
@property (assign,readwrite) int positionRange; //how far right it can move
@property (assign,readwrite) CGPoint touchLocation;
@property (assign,readwrite) BOOL touchPending; //true while deterimining what to do with a touch
@property (assign,readwrite) float swipeSpeed;
@property (assign,readwrite) BOOL inPostSwipe; //the automatic adjustments after a swipe ends




+(id) scene; //returns level select scene
-(void) activateButtons;
-(void) respondToTouch:(CGPoint)location; // after it's determined that a touch is a click

@end


@interface LevelIcon : NSObject

//contains a sprite and a label
@property (assign,readwrite) CCSprite *sprite;
@property (assign,readwrite) CCSprite *highlightSprite;
@property (assign,readwrite) CCLabelTTF *label;
@property (assign,readwrite) BOOL isSelected;
@property (assign,readwrite) int levelNumber;

//still need to add sprite and label as children to the layer after using this
-(id) initWithLevelNumber:(int) num andPosition:(CGPoint) position;

-(void) moveIcon:(float)xDistance;



@end