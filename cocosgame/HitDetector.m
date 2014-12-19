//
//  HitDetector.m
//  NinjaGame
//
//  Created by Joey on 3/16/13.
//
//

#import "HitDetector.h"
#import "HitBox.h"
#import "EnemySprite.h"
#import "GameLayer.h"
#import "EnemyLayer.h"
#import "NinjaStarLayer.h"
#import "NinjaLayer.h"

@implementation HitDetector

@synthesize enemyHitBoxList = _enemyHitBoxList;
@synthesize ninjaHitBoxList = _ninjaHitBoxList;

-(id) init{
    if ( (self = [super init]) ){
        self.enemyHitBoxList = [NSMutableArray new];
        self.ninjaHitBoxList = [NSMutableArray new];
    }
    return self;
}

-(void) runHitDetection:(ccTime) dt{
    // test all ninjaboxes with all enemy sprites
    for (HitBox *hitBox in self.ninjaHitBoxList){
        for (EnemySprite *enemy in enemyLayerInstance.enemyBatch.children){
            if (!enemy.aboutToDie){
                if (CGRectIntersectsRect(hitBox.rect, enemy.nextRect)){
                    [enemy takeHitWithDamage:hitBox.damage andKnockback:hitBox.knockback];
                }
            }
        }
        
        
        [self.ninjaHitBoxList removeObject:hitBox];
    }
    for (int i = [self.enemyHitBoxList count]; i>0; i--){
        HitBox *enemyHitBox = [self.enemyHitBoxList objectAtIndex:i-1];
        if (CGRectIntersectsRect(enemyHitBox.rect, ninjaLayerInstance.ninja.nextRect)){
            [ninjaLayerInstance takeHitWithDamage:enemyHitBox.damage andKnockback:enemyHitBox.knockback];
            
        }
        [self.enemyHitBoxList removeObject:enemyHitBox];
    }
    [self runNinjaStarHitDetection:dt];
}

-(void) runNinjaStarHitDetection:(ccTime)dt{
    [ninjaStarLayerInstance nextFrame:dt];
    for (NinjaStar *star in ninjaStarLayerInstance.ninjaStarBatch.children){
        for (EnemySprite *enemy in enemyLayerInstance.enemyBatch.children){
            if (CGRectIntersectsRect(star.rect, enemy.nextRect)){
                //determine direction of knockback
                int starKnockback = 0;
                if (star.xVelocity > 0){
                    starKnockback = 4;
                }
                if (star.xVelocity < 0){
                    starKnockback = -4;
                }
                [enemy takeHitWithDamage:ninjaStarLayerInstance.starDamage andKnockback:starKnockback];
                //[ninjaStarLayerInstance.ninjaStarBatch removeChild:star cleanup:true];
                //need to figure out the problem with this
            }
        }
    }
}


-(void) dealloc{
    [self.enemyHitBoxList release];
    [self.ninjaHitBoxList release];
    
    [super dealloc];
}



-(void) drawHitBoxes{
    for (HitBox *box in self.ninjaHitBoxList){
        CGPoint vertices[4] = {
            ccp(box.rect.origin.x, box.rect.origin.y),
            ccp((box.rect.origin.x+box.rect.size.width), box.rect.origin.y),
            ccp((box.rect.origin.x+box.rect.size.width), (box.rect.origin.y+box.rect.size.height)),
            ccp(box.rect.origin.x, (box.rect.origin.y+box.rect.size.height)),
        };
        
        ccDrawPoly(vertices, 4, YES);
    }
    for (HitBox *box in self.enemyHitBoxList){
        CGPoint vertices[4] = {
            ccp(box.rect.origin.x, box.rect.origin.y),
            ccp((box.rect.origin.x+box.rect.size.width), box.rect.origin.y),
            ccp((box.rect.origin.x+box.rect.size.width), (box.rect.origin.y+box.rect.size.height)),
            ccp(box.rect.origin.x, (box.rect.origin.y+box.rect.size.height)),
        };
        
        ccDrawPoly(vertices, 4, YES);
    }
}


@end



