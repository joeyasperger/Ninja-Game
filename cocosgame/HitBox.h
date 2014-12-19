//
//  HitBox.h
//  NinjaGame
//
//  Created by Joey on 3/24/13.
//
//

#import <Foundation/Foundation.h>

@interface HitBox : NSObject

@property (assign,readwrite) CGRect rect;

@property (assign,readwrite) float duration;
@property (assign,readwrite) int damage;
@property (assign,readwrite) int knockback;

//to make sure same attack can't hit someone twice
@property (assign,readwrite) int tag;

-(id) initWithRect:(CGRect) rect;  //always use this

-(void) setHitBoxDamage:(int)damage withKnockback:(int)knockback andRectDuration:(float) duration;

@end
