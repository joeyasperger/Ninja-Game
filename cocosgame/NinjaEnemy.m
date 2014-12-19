//
//  NinjaEnemy.m
//  NinjaGame
//
//  Created by Joey on 3/17/13.
//
//

#import "NinjaEnemy.h"
#import "HitBox.h"
#import <math.h>
#import "HitDetector.h"
#import "GameLayer.h"
#import "EnemyLayer.h"
#import "NinjaLayer.h"
#import "Timer.h"

//const int WALK_SPEED = 75;

@implementation NinjaEnemy

@synthesize nextHitRect = _nextHitRect;
@synthesize hitRectTimer = _hitRectTimer;
@synthesize finiteActionTimer = _finiteActionTimer;
@synthesize notInFiniteAnimation = _notInFiniteAnimation;
@synthesize knockbackSpeedX = _knockbackSpeedX;
@synthesize knockbackSpeedY = _knockbackSpeedY;
@synthesize deathTimer = _deathTimer;
@synthesize timeSinceInRange = _timeSinceInRange;
@synthesize patrolPaused = _patrolPaused;
@synthesize patrolDistanceToGo = _patrolDistanceToGo;
@synthesize patrolPauseTimer = _patrolPauseTimer;
@synthesize killSequenceStarted = _killSequenceStarted;
@synthesize disabledTimer = _disabledTimer;

/*HITRECT KEY
 0 = none
 1 = light attack right
 2 = light attack left
 */



-(void) startAI{
    WALK_SPEED = 75;
    RUN_SPEED = 350;
    self.finiteActionTimer = 0;
    self.maxHealth = 60;
    self.healthLeft = 60;
    [self setRectHeight:122 withWidth:40 withXOffset:0 andYOffset:-10];
    [self setupHealthbar];
    
    self.poisonDamageTimer = [Timer new];
    self.poisonTimer = [Timer new];
    self.freezeTimer = [Timer new];
    self.disabledTimer = [Timer new];
    
    if (self.mode == STILL_CHANGE_ENEMY){
        self.changeDirectionTimer = 4.0;
    }
    
    if (self.mode == PATROL_ENEMY){
        self.patrolPauseTimer = [Timer new];
        self.patrolPaused = true;
        [self.patrolPauseTimer activateTimer:0.7];
        self.patrolDistanceToGo = self.patrolRange;
    }
}

-(void) nextFrame:(ccTime)dt{
    
    if (self.aboutToDie && !self.inAir){
        if (!self.killSequenceStarted){
            [self startKillSequence];
            self.killSequenceStarted = true;
        }
    }
    
    if ([self.disabledTimer stillRunning]){
        [self moveSprite:self.knockbackSpeedX*dt withY:0];
        [self.disabledTimer advanceTimer:dt];
        if ([self.disabledTimer expired]){
            [self endDisabling];
        }
    }
    if (![self.disabledTimer stillRunning]){
        if (self.finiteActionTimer <= 0){
            //not in finite action
            
            if ((self.mode == STILL_ENEMY) || (self.mode == STILL_CHANGE_ENEMY) || (self.mode == PATROL_ENEMY)){
                if ([self canSeeNinja]){
                    self.mode = SEEK_ENEMY;
                    hasSpottedNinja = true;
                }
            }
            
            if (self.mode == PATROL_ENEMY){
                if (self.patrolPaused){
                    [self.patrolPauseTimer advanceTimer:dt];
                    if ([self.patrolPauseTimer expired]){
                        self.patrolPaused = false;
                        [self.patrolPauseTimer deactivateTimer];
                        //start walking in opposite direction
                        if (self.directionLooking == 'r'){
                            self.animation = 7; //walk left
                            self.patrolDistanceToGo = self.patrolRange;
                            self.directionLooking = 'l';
                        }
                        else{
                            self.animation = 6;
                            self.patrolDistanceToGo = self.patrolRange;
                            self.directionLooking = 'r';
                        }
                    }
                }
                else{
                    [self checkAndPausePatrol:dt];
                }
            }
            
            if (self.mode == STILL_CHANGE_ENEMY){
                self.changeDirectionTimer -= dt;
                if (self.changeDirectionTimer < 0){
                }
                
                if (self.directionLooking == 'r'){
                    self.animation = 1;
                    self.directionLooking = 'l';
                }
                
                if (self.directionLooking == 'l'){
                    self.animation = 0;
                    self.directionLooking = 'r';
                }
            }
            
            if (self.mode == SEEK_ENEMY){
                [self runTowardsNinja:dt];
                [self checkRange];
            }
            
            if (self.mode == ATTACKING_ENEMY){
                [self runAttackModeAlgorithm:dt];
            }
        }
        if (self.finiteActionTimer > 0){
            //is in finite action
            self.finiteActionTimer -= dt;
        }
        if (self.nextHitRect != 0){
            //countdown the hit timer
            self.hitRectTimer -= dt;
            if (self.hitRectTimer < 0){
                //generate hitboxes for everything
                switch (self.nextHitRect) {
                    case 1:
                        [self hitLightAttackRight];
                        break;
                    case 2:
                        [self hitLightAttackLeft];
                        break;
                }
                self.nextHitRect = 0;
            }
        }
    }
    //Start of stuff that will be done regardless of disabled status
    [self updateAnimation];
    
    //check if ninja is alive
    if (!self.aboutToDie){
        if (self.healthLeft <= 0){
            self.aboutToDie = true;
            self.deathTimer = 2.0;
        }
    }
    
    if (self.poisoned){
        [self.poisonTimer advanceTimer:dt];
        [self.poisonDamageTimer advanceTimer:dt];
        if ([self.poisonTimer expired]){
            self.poisoned = false;
            [self endDisabling]; //to reset color
        }
        else{
            if ([self.poisonDamageTimer expired]){
                [self inflictPoisonDamage];
                [self.poisonDamageTimer activateTimer:.3];
            }
        }
    }
    
    //for fade out
    if (self.aboutToDie){
        self.deathTimer -= dt;
        if (self.deathTimer <=0){
            [self killSelf];
        }
    }
}

-(void) runTowardsNinja:(ccTime)dt{
    if (ninjaLayerInstance.ninja.position.x > self.position.x){
        //should chase ninja right
        [self moveSprite:RUN_SPEED*dt withY:0];
        self.animation = 2;
        self.directionLooking = 'r';
    }
    else{
        //should chase ninja left
        [self moveSprite:-RUN_SPEED*dt withY:0];
        self.animation = 3;
        self.directionLooking = 'l';
    }
}

-(void) checkAndPausePatrol:(ccTime)dt{
    if (self.patrolDistanceToGo < 0){
        self.patrolPaused = true;
        [self.patrolPauseTimer activateTimer:0.7];
        
        if (self.directionLooking == 'l'){
            self.animation = 1;
        }
        else{
            self.animation = 0;
        }
        
    }
    else{
        if (self.directionLooking == 'l'){
            [self moveSprite:-WALK_SPEED*dt withY:0];
        }
        else{
            [self moveSprite:WALK_SPEED*dt withY:0];
        }
        self.patrolDistanceToGo -= WALK_SPEED*dt;
    }
}

-(void) checkRange{
    //ninja is out of range
    if ((fabsf(ninjaLayerInstance.ninja.position.x - self.position.x) >400) || ninjaLayerInstance.invisible){
        self.mode = self.originalMode;
        hasSpottedNinja = false;
    }
    //in attack range
    else if (fabsf(ninjaLayerInstance.ninja.position.x - self.position.x) <50){
        self.mode = ATTACKING_ENEMY;
        self.timeSinceInRange = 0;
        self.timeSinceAttack = .4; //because first attack should be based on timeSinceInRange
    }
}

-(void) runAttackModeAlgorithm:(ccTime)dt{
    float xDistanceToNinja = ninjaLayerInstance.ninja.position.x - self.position.x;

    //both will need to get high enough for an attack to start
    self.timeSinceInRange += dt;
    self.timeSinceAttack += dt;
    
    if (!self.inAttack){
        if (xDistanceToNinja < 0){
            self.animation = 1;
            self.directionLooking = 'l';
            
        }
        
        if (xDistanceToNinja > 0){
            self.animation = 0;
            self.directionLooking = 'r';
        }
    }
    if (ninjaLayerInstance.invisible){
        self.mode = self.originalMode;
        hasSpottedNinja = false;
    }
    else if (fabsf(xDistanceToNinja) > 70){
        self.mode = SEEK_ENEMY;
    }
    
    
    if ((self.timeSinceInRange >= .05) && (self.timeSinceAttack >=.4)){
        if (arc4random()%5 == 0){
            [self startLightAttackA];
            self.timeSinceAttack = 0;
            self.timeSinceInRange = 0;
        }
        else{
            self.timeSinceInRange = 0;
        }
    }
}

-(bool) canSeeNinja{
    if (!ninjaLayerInstance.invisible){
        if (fabsf(ninjaLayerInstance.ninja.position.x - self.position.x) <170){
            if (self.directionLooking == 'r'){
                if (ninjaLayerInstance.ninja.position.x >= self.position.x){
                    return true;
                }
            }
            else{
                if (ninjaLayerInstance.ninja.position.x <= self.position.x){
                    return true;
                }
            }
        }
    }
    return false;
}

-(void) updateAnimation{
    /*KEY
     0 = idle right
     1 = idle left
     2 = run right
     3 = run left
     4 = attack right
     5 = attack left
     6 = walk right
     7 = walk left
     */
    if (self.animation != self.previousAnimation){
        [self stopAllActions];
        switch (self.animation){
            case 0:
                [self animateIdleRight];
                break;
            case 1:
                [self animateIdleLeft];
                break;
            case 2:
                [self animateMoveRight];
                break;
            case 3:
                [self animateMoveLeft];
                break;
            case 4:
                [self animateLightAttackRight];
                break;
            case 5:
                [self animateLightAttackLeft];
                break;
            case 6:
                [self animateWalkRight];
                break;
            case 7:
                [self animateWalkLeft];
                break;
        }
        
    }
    self.previousAnimation = self.animation;
}

-(void) startLightAttackA{
    float xDistanceToNinja = ninjaLayerInstance.ninja.position.x - self.position.x;

    if (xDistanceToNinja < 0){
        self.animation = 5;
        
    }
    
    if (xDistanceToNinja > 0){
        self.animation = 4;
    }
}

-(void) animateIdleRight{
    [self runAction:[self makeIdleAction:@"ninjaidleright.png"]];
}

-(void) animateIdleLeft{
    [self runAction:[self makeIdleAction:@"ninjaidleleft.png"]];
}

-(void) animateMoveRight{
    [self runAction:[self makeContinuousAction:@"ninjarunningright" withNumFrames:20 andFrameDuration:.038f]];
}

-(void) animateMoveLeft{
    [self runAction:[self makeContinuousAction:@"ninjarunningleft" withNumFrames:20 andFrameDuration:.038f]];
}

-(void) animateWalkRight{
    [self runAction:[self makeContinuousAction:@"NinjaWalkRight" withNumFrames:10 andFrameDuration:.1]];
}

-(void) animateWalkLeft{
    [self runAction:[self makeContinuousAction:@"NinjaWalkLeft" withNumFrames:10 andFrameDuration:.1]];
}

-(void) animateLightAttackLeft{
    [self runAction:[self makeFiniteAction:@"NinjaLightAttackLeft" withNumFrames:4 andFrameDuration:.04f]];
    self.finiteActionTimer = 0.4;
    self.nextHitRect = 2;
    self.hitRectTimer = .08f;
}

-(void) animateLightAttackRight{
    [self runAction:[self makeFiniteAction:@"NinjaLightAttackRight" withNumFrames:4 andFrameDuration:.04f]];
    self.finiteActionTimer = 0.4;
    self.nextHitRect = 1;
    self.hitRectTimer = .08f;
}

-(void) takeHitWithDamage:(int)damage andKnockback:(int)knockback{
    self.nextHitRect = 0; //stop any attacks
    
    [gameLayerInstance addDamageDisplay:damage color:'g' sizeMultiple:1 position:self.position];
    
    self.healthLeft -= damage;
    
    if (!hasSpottedNinja){
        //dies instantly
        self.healthLeft = 0;
        stealthKill = true;
    }
    
    self.knockbackSpeedX = knockback * 30;
    self.yVelocity = abs(knockback) * 45;
    
    if (self.healthLeft > 0){
        //dont change direction if enemy is dead
        if (knockback > 0){
            self.animation = 1; //will make specific animation later
            self.directionLooking = 'l';
        }
        else{
            self.animation = 0;
            self.directionLooking = 'r';
        }
    }
    
    

    
    self.color = ccc3(255,180,0);
    if ([self.disabledTimer timeRemaining]  < .4){
        [self.disabledTimer activateTimer:.4];; //why is that automatic and not an argument?  need to fix that
    }
    if (self.healthLeft <= 0){
        [self.disabledTimer activateTimer:100];
    }
}

-(void) inflictPoisonDamage{
    int damage = 2; //to be adjusted later
    self.healthLeft -= damage;
    [gameLayerInstance addDamageDisplay:damage color:'g' sizeMultiple:.6 position:self.position];
}

-(void) endDisabling{
    if (self.poisoned){
        self.color = ccc3(0,255,0);
    }
    if (self.colorType == 'r'){
        self.color = ccc3(255, 0, 0);
    }
    else if (self.colorType == 'b'){
        self.color = ccc3(140, 140, 255);
    }
    else if (self.colorType == 'g'){
        self.color = ccc3(0, 255, 0);
    }
    else if (self.colorType == '0'){
        self.color = ccWHITE;
    }
    self.knockbackSpeedX = 0;
}

-(void) hitLightAttackRight{
    CGRect rect = CGRectMake(self.position.x+15, self.position.y-50, 60, 115);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:10 withKnockback:4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.enemyHitBoxList addObject:attack];
    [attack release];
    
}

-(void) hitLightAttackLeft{
    CGRect rect = CGRectMake(self.position.x-75, self.position.y-50, 60, 115);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:10 withKnockback:-4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.enemyHitBoxList addObject:attack];
    [attack release];
}

-(void) setupHealthbar{
    //this can definetely be moved to the generic enemy sprite class
    CCSprite *healthbarSprite = [CCSprite spriteWithSpriteFrameName:@"HealthBar.png"];
    self.healthbar = [CCProgressTimer progressWithSprite:healthbarSprite];
    self.healthbar.type = kCCProgressTimerTypeBar;
    self.healthbar.position = ccp(self.position.x,(self.nextRect.origin.y+self.nextRect.size.height+20));
    self.healthbar.midpoint = ccp(.5f,.5f);
    self.healthbar.barChangeRate = ccp(1,0);
    self.healthbar.percentage = (((float)self.healthLeft / (float)self.maxHealth) * 100);
    self.healthbar.opacity = 160;
    //add to game layer as child (not sure if this will work how I want it to
    [enemyHealthbarLayerInstance addChild:self.healthbar];
}

-(void) poisonSelf{
    self.poisoned = true;
    [self.poisonTimer activateTimer:5];
    [self inflictPoisonDamage];
    [self.poisonDamageTimer activateTimer:.3];
    self.color = ccc3(0,255,0);
}

-(void) freezeSelf{
    self.frozen = true;
    [self.freezeTimer activateTimer:7];
    self.color = ccc3(100,100,255); // not going to work, cant get good blue just by tinting
}

-(void) updateHealthbar{
    self.healthbar.position = ccp(self.position.x,(self.nextRect.origin.y+self.nextRect.size.height+20));
    self.healthbar.percentage = (((float)self.healthLeft / (float)self.maxHealth) * 100); //realHealth is a percentage
   
}

//will need to update this later if there are multiple enemy batches
-(void) killSelf{
    gameLayerInstance.enemiesKilled += 1;
    if (stealthKill){
        gameLayerInstance.stealthKills += 1;
    }
    [enemyLayerInstance.enemyBatch removeChild:self cleanup:YES];
}

-(void) startKillSequence{
    self.aboutToDie = true;
    self.deathTimer = .5;
    [self.disabledTimer activateTimer:.5];
    self.knockbackSpeedX = 0;
    self.yVelocity = 0;
    self.xVelocity = 0;
    [self runAction:[CCFadeOut actionWithDuration:.5]];
}

-(void) dealloc{
    [self.patrolPauseTimer release];
    [self.poisonTimer release];
    [self.poisonDamageTimer release];
    [super dealloc];
}

@end
