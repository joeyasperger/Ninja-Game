//
//  Collider.m
//  NinjaGame
//
//  Created by Joey on 2/13/13.
//
//

#import "Collider.h"
#import "NinjaLayer.h"
#import "ForegroundLayer.h"
#import "EnemyLayer.h"
#import "EnemySprite.h"
#import "GameLayer.h"
#import "PhysicsSprite.h"
#import <math.h>
#define pi 3.14159


@implementation Collider

@synthesize gravity = _gravity;
@synthesize backgroundSpeedX = _backgroundSpeedX;
@synthesize screenAdjustmentSpeedX = _screenAdjustmentSpeedX;
@synthesize backgroundSpeedY = _backgroundSpeedY;
@synthesize groundY = _groundY;

-(id) init{
    if ( (self = [super init]) ){
        self.gravity = -1300;
        self.groundY = 80;
    }
    return self;
}

-(void) runCollisionResponse:(ccTime)dt{
    [self runNinjaCollisionResponse:dt];
}

-(void) runNinjaCollisionResponse:(ccTime)dt{
    
    BOOL ninjaLanded = NO;
    
    ninjaLayerInstance.ninja.yVelocity += (colliderInstance.gravity*dt);
    [ninjaLayerInstance moveNinja:0 withYdistance:(ninjaLayerInstance.ninja.yVelocity*dt)];
    
    //test ground
    if (ninjaLayerInstance.ninja.nextRect.origin.y < self.groundY){
        [ninjaLayerInstance.ninja moveSprite:0 withY:(self.groundY-ninjaLayerInstance.ninja.nextRect.origin.y)];
        //[ninjaLayerInstance.ninja resetNextRectY:self.groundY];
        //ninjaLayerInstance.inAir = 0;
        ninjaLanded = YES;
        //ninjaLayerInstance.ninja.yVelocity = 0; //probably should be changed
    }
    
    for (PhysicsSprite *object in foregroundLayerInstance.foregroundBatch.children){
        if (CGRectIntersectsRect(ninjaLayerInstance.ninja.nextRect, object.nextRect)){
            //NSLog(@"1");
            
            CGRect intersectingRect = CGRectIntersection(ninjaLayerInstance.ninja.nextRect, object.rect);
            if (intersectingRect.size.width >= intersectingRect.size.height){
                //need to fix vertically
                if ((ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height/2) >= (object.nextRect.origin.y + object.nextRect.size.height/2)){
                    //ninja is on top of object
                    [ninjaLayerInstance moveNinja:0 withYdistance:((object.nextRect.origin.y + object.nextRect.size.height) - ninjaLayerInstance.ninja.nextRect.origin.y)];
                    if (ninjaLayerInstance.ninja.yVelocity <= 0){
                        ninjaLanded = YES;
                    }
                }
                else{
                    //ninja is below object
                    [ninjaLayerInstance moveNinja:0 withYdistance:-((ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height) - object.nextRect.origin.y)];
                    if (ninjaLayerInstance.ninja.yVelocity >= 0){
                        ninjaLayerInstance.ninja.yVelocity = 0;
                    }
                }
            }
            else{
                //need to fix horizontally
                if ((ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width/2) >= (object.nextRect.origin.x + object.nextRect.size.width/2)){
                    //ninja is on right of object
                    [ninjaLayerInstance moveNinja:((object.nextRect.origin.x + object.nextRect.size.width) - ninjaLayerInstance.ninja.nextRect.origin.x) withYdistance:0];
                }
                else{
                    //ninja is on left of object
                    [ninjaLayerInstance moveNinja:-((ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width) - object.nextRect.origin.x) withYdistance:0];
                }
            }
        }
        else{
        }
    }
    
    //NINJA TO ENEMY COLLISION
    BOOL ninjaIntersectsEnemy = false;
    for (EnemySprite *enemy in gameLayerInstance.enemyList){
        if (!enemy.aboutToDie){
            if (CGRectIntersectsRect(ninjaLayerInstance.ninja.nextRect, enemy.nextRect)){
                ninjaIntersectsEnemy = true;
                
                //OLD THING(ninja collides instead of slows down when hitting enemy)
                /*
                CGRect intersectingRect = CGRectIntersection(ninjaLayerInstance.ninja.nextRect, enemy.rect);
                if (intersectingRect.size.width >= intersectingRect.size.height){
                    //need to fix vertically
                    if ((ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height/2) >= (enemy.nextRect.origin.y + enemy.nextRect.size.height/2)){
                        //ninja is on top of object
                        [ninjaLayerInstance moveNinja:0 withYdistance:((enemy.nextRect.origin.y + enemy.nextRect.size.height) - ninjaLayerInstance.ninja.nextRect.origin.y)];
                        if (ninjaLayerInstance.ninja.yVelocity <= 0){
                            ninjaLanded = YES;
                        }
                    }
                    else{
                        //ninja is below object
                        [ninjaLayerInstance moveNinja:0 withYdistance:-((ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height) - enemy.nextRect.origin.y)];
                        if (ninjaLayerInstance.ninja.yVelocity >= 0){
                            ninjaLayerInstance.ninja.yVelocity = 0;
                        }
                    }
                }
                else{
                    //need to fix horizontally
                    if ((ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width/2) >= (enemy.nextRect.origin.x + enemy.nextRect.size.width/2)){
                        //ninja is on right of object
                        [ninjaLayerInstance moveNinja:((enemy.nextRect.origin.x + enemy.nextRect.size.width) - ninjaLayerInstance.ninja.nextRect.origin.x) withYdistance:0];
                    }
                    else{
                        //ninja is on left of object
                        [ninjaLayerInstance moveNinja:-((ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width) - enemy.nextRect.origin.x) withYdistance:0];
                    }
                }
                */
            }
            else{
            }
        }
    }
    
    if (ninjaIntersectsEnemy){
        //will move at half speed, so move ninja back halfway to original position
        [ninjaLayerInstance moveNinja:(ninjaLayerInstance.ninja.position.x - ninjaLayerInstance.ninja.nextXVal) * 3 / 4 withYdistance:0];
    }

    
    
    
    
    if (ninjaLanded == YES){
        ninjaLayerInstance.inAir = NO;
        ninjaLayerInstance.ninja.yVelocity = 0;
    }
    else{
        ninjaLayerInstance.inAir = YES;
    }
    
    [self setFinalBackgroundSpeedX:dt];
    [self setFinalBackgroundSpeedY];
    [ninjaLayerInstance.ninja finalMove];
}


-(void) runEnemyToForegroundCollision:(ccTime)dt{
    for (EnemySprite *enemy in gameLayerInstance.enemyList){
        enemy.yVelocity += (colliderInstance.gravity*dt);
        [enemy moveSprite:0 withY:(enemy.yVelocity*dt)];
        
        enemy.inAir = true;
        
        //test ground
        if (enemy.nextRect.origin.y < self.groundY){
            [enemy moveSprite:0 withY:(self.groundY-enemy.nextRect.origin.y)];
            enemy.inAir = false;
        }
        
        for (PhysicsSprite *object in foregroundLayerInstance.foregroundBatch.children){
            if (CGRectIntersectsRect(enemy.nextRect, object.nextRect)){
                //NSLog(@"1");
                
                CGRect intersectingRect = CGRectIntersection(enemy.nextRect, object.rect);
                if (intersectingRect.size.width >= intersectingRect.size.height){
                    //need to fix vertically
                    if ((enemy.nextRect.origin.y + enemy.nextRect.size.height/2) >= (object.nextRect.origin.y + object.nextRect.size.height/2)){
                        //enemy is on top of object
                        [enemy moveSprite:0 withY:((object.nextRect.origin.y + object.nextRect.size.height) - enemy.nextRect.origin.y)];
                        enemy.inAir = false;
                        
                        if (enemy.yVelocity <= 0){
                            enemy.yVelocity = 0;
                        }
                    }
                    else{
                        //enemy is below object
                        [enemy moveSprite:0 withY:-((enemy.nextRect.origin.y + enemy.nextRect.size.height) - object.nextRect.origin.y)];
                        if (enemy.yVelocity >= 0){
                            enemy.yVelocity = 0;
                        }
                    }
                }
                else{
                    //need to fix horizontally
                    if ((enemy.nextRect.origin.x + enemy.nextRect.size.width/2) >= (object.nextRect.origin.x + object.nextRect.size.width/2)){
                        //enemy is on right of object
                        [enemy moveSprite:((object.nextRect.origin.x + object.nextRect.size.width) - enemy.nextRect.origin.x) withY:0];
                    }
                    else{
                        //enemy is on left of object
                        [enemy moveSprite:-((enemy.nextRect.origin.x + enemy.nextRect.size.width) - object.nextRect.origin.x) withY:0];
                    }
                }
            }
            else{
                //NSLog(@"0");
            }
        }
        
        //ENEMY TO NINJA COLLISION
        
        if (!enemy.aboutToDie){
            if (CGRectIntersectsRect(enemy.nextRect, ninjaLayerInstance.ninja.nextRect)){
                //NSLog(@"1");
                
                CGRect intersectingRect = CGRectIntersection(enemy.nextRect, ninjaLayerInstance.ninja.rect);
                if (intersectingRect.size.width >= intersectingRect.size.height){
                    //need to fix vertically
                    if ((enemy.nextRect.origin.y + enemy.nextRect.size.height/2) >= (ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height/2)){
                        //enemy is on top of object
                        [enemy moveSprite:0 withY:((ninjaLayerInstance.ninja.nextRect.origin.y + ninjaLayerInstance.ninja.nextRect.size.height) - enemy.nextRect.origin.y)];
                        
                        if (enemy.yVelocity <= 0){
                        }
                    }
                    else{
                        //enemy is below object
                        [enemy moveSprite:0 withY:-((enemy.nextRect.origin.y + enemy.nextRect.size.height) - ninjaLayerInstance.ninja.nextRect.origin.y)];
                        if (enemy.yVelocity >= 0){
                            enemy.yVelocity = 0;
                        }
                    }
                }
                else{
                    //need to fix horizontally
                    if ((enemy.nextRect.origin.x + enemy.nextRect.size.width/2) >= (ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width/2)){
                        //enemy is on right of object
                        [enemy moveSprite:((ninjaLayerInstance.ninja.nextRect.origin.x + ninjaLayerInstance.ninja.nextRect.size.width) - enemy.nextRect.origin.x) withY:0];
                    }
                    else{
                        //enemy is on left of object
                        [enemy moveSprite:-((enemy.nextRect.origin.x + enemy.nextRect.size.width) - ninjaLayerInstance.ninja.nextRect.origin.x) withY:0];
                    }
                }
            }
            else{
                //NSLog(@"0");
            }
        }
        

        
        
        //FINALMOVE
        [enemy finalMove]; 
        [enemy moveSpriteWithScreen:self.backgroundSpeedX*dt withYSpeed:self.backgroundSpeedY*dt];
    }
}


-(void) setFinalBackgroundSpeedX:(ccTime)dt{
    //to set background speed
    /*
    float ninjaOffsetX = ninjaLayerInstance.ninja.nextXVal - ninjaLayerInstance.ninja.position.x;
    if (ninjaLayerInstance.ninja.position.x>360){
        colliderInstance.backgroundSpeedX = -fabsf(ninjaOffsetX);
    }
    else if (ninjaLayerInstance.ninja.position.x<120){
        colliderInstance.backgroundSpeedX = fabsf(ninjaOffsetX);
    }
    else{
        colliderInstance.backgroundSpeedX = -((ninjaLayerInstance.ninja.position.x-240)*9);
    }*/
   
    //how much ninja has moved  this frame
    float ninjaOffsetX = ninjaLayerInstance.ninja.nextXVal - ninjaLayerInstance.ninja.position.x;

    //odd animation means facing right
    if (ninjaLayerInstance.animation % 2 == 1){
        //need to move ninja to left of screen
        if (ninjaLayerInstance.ninja.nextXVal > 180){
            //want to make screen slow down gradually after ninja stops moving if not yet at proper side
            if (ninjaLayerInstance.ninja.xVelocity == 0){
                //if screen is moving too fast in negative direction
                if (colliderInstance.backgroundSpeedX < -200){
                    colliderInstance.backgroundSpeedX = colliderInstance.backgroundSpeedX + 500*dt;
                }
                else{
                    colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt - 200;
                    //divide by dt because it will be multiplied by dt later
                }
            }
            else{
                colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt - 200;
            }
        }
        else{
            colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt;
        }
    }
    else{
        if (ninjaLayerInstance.ninja.nextXVal < 300){
            if (ninjaLayerInstance.ninja.xVelocity == 0){
                if (colliderInstance.backgroundSpeedX > 200){
                    colliderInstance.backgroundSpeedX = colliderInstance.backgroundSpeedX - 500*dt;
                }
                else{
                    colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt + 200;
                }
            }
            else{
                colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt + 200;

            }
        }
        else{
            colliderInstance.backgroundSpeedX = -ninjaOffsetX/dt;
        }
    }
}

-(void) setFinalBackgroundSpeedY{
    
    float ninjaOffsetY = ninjaLayerInstance.ninja.nextYVal - ninjaLayerInstance.ninja.position.y;
    if (ninjaLayerInstance.ninja.position.y>280){
        colliderInstance.backgroundSpeedY = -fabsf(ninjaOffsetY);
    }
    else if (ninjaLayerInstance.ninja.position.y<40){
        colliderInstance.backgroundSpeedY = fabsf(ninjaOffsetY);
    }
    else{
        colliderInstance.backgroundSpeedY = -((ninjaLayerInstance.ninja.position.y-160)*8);
    }
}

@end
