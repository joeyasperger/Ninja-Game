//
//  GameSceneLevel1.h
//  NinjaGame
//
//  Created by Joey on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene

{
}
@property (assign,readwrite) int level;

-(id) initWithLevel:(int)level;


@end
