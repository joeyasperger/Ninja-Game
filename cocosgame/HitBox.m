//
//  HitBox.m
//  NinjaGame
//
//  Created by Joey on 3/24/13.
//
//

#import "HitBox.h"

//used for tag property, increases every time a HitBox is made
static int num = 0;


@implementation HitBox

@synthesize rect = _rect;
@synthesize duration = _duration;
@synthesize damage = _damage;
@synthesize knockback = _knockback;
@synthesize tag = _tag;


-(id) init{
    if ((self = [super init])){
        NSLog(@"DO NOT USE REGULAR INIT FOR HITBOX!!!");
    }
    return self;
}

//always use this, not regular init
-(id) initWithRect:(CGRect) rect{
    if ((self = [super init])){
        self.tag = num; //set tag
        ++num;
        
        self.rect = (rect);       
        
    }
    return self;
}

-(void) setHitBoxDamage:(int)damage withKnockback:(int)knockback andRectDuration:(float)duration{
    self.damage = damage;
    self.knockback = knockback;
    self.duration = duration;
}



@end