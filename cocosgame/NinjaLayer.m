//
//  NinjaLayer.m
//  cocosgame
//
//  Created by Joey on 1/6/13.
//
//

#import "NinjaLayer.h"
#import "Gamelayer.h"
#import "PhysicsSprite.h"
#import "HitBox.h"
#import "HitDetector.h"
#import "Timer.h"
#import "math.h"
#import "JoystickClass.h"





/*
 KEY FOR INT ANIMATION
 0 = no animation
 1 = running right
 2 = running left
 3 = idle right
 4 = idle left
 5 = single jump right
 6 = single jump left
 7 = crouch run right
 8 = crouch run left
 9 = crouch idle right
 10 = crouch idle left
 11 = light attack right
 12 = light attack left
 13 = light attack right B
 14 = light attack left B
 15 = light attack right C
 16 = light attack left C
 
 BOUNDBOX KEY
 0 = regular box
 1 = crouch idle right box
 2 = crouch idle left box
 
 
 */


@implementation NinjaLayer

@synthesize ninja = _ninja;
@synthesize justFinishedJump;
@synthesize inFiniteAnimation = _inFiniteAnimation;
@synthesize inAir = _inAir;
@synthesize healthLeft = _healthLeft;
@synthesize maxHealth = _maxHealth;
@synthesize animation = _animation;
@synthesize isDisabled = _isDisabled;
@synthesize nextCombo = _nextCombo;
@synthesize blockPressed = _blockPressed;
@synthesize isBlocking = _isBlocking;
@synthesize overdrive = _overdrive;



-(id) init
{
    if( (self = [super init]) ){
        self.animation = NO_ANIMATION;
        lastanimation = NO_ANIMATION;
        currentBoundBox = 0;
        self.nextCombo = 1;
        actionTimer = 0;
        self.isDisabled = NO;
        [self schedule:@selector(nextFrame:)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninjaspritesheet.plist"];
        CCSpriteBatchNode*ninjaBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjaspritesheet.png"];
        [self addChild:ninjaBatch];
        
        hitTimer = [[Timer alloc] init];
        comboTimer = [[Timer alloc] init];
        swingTimer = [[Timer alloc] init];
        overdriveTimer = [Timer new];
        invisibilityTimer = [Timer new];
        
        [self setInitialHealth];
        

    }
    return self;
}

-(void) nextFrame:(ccTime)dt{
    if (!self.blockPressed) {
        self.isBlocking = false;
    }
    
    
    
    //actiontimer stuff
    if (self.inFiniteAnimation){
        actionTimer -= dt;
        if (actionTimer <= 0){
            self.inFiniteAnimation = NO;
            if (self.isDisabled){
                //end disabling
                self.isDisabled = false;
                [self resetColor];
            }
        }
        if (self.isDisabled){
            if (!self.inAir){
                self.ninja.xVelocity = 0;
            }
            [self moveNinja:ninjaLayerInstance.ninja.xVelocity*dt withYdistance:0];
        }
        if (!self.isDisabled){
            //because this is for slowing down attacks not affecting disabled movement
            if (ninjaLayerInstance.ninja.xVelocity != 0){
                //this slows ninja down while in attacks
                [self slowDuringAttack:dt];
                [self moveNinja:ninjaLayerInstance.ninja.xVelocity*dt withYdistance:0];
            }
        }
    }
    else{
        //not in finite animation
        
        if (self.blockPressed && !self.inAir){
            [self setBlockingAnimation];
            self.isBlocking = true;
        }
        else{
            [gameLayerInstance applyJoystickInput];
            
            if (self.ninja.xVelocity != 0){
                [self moveNinja:(ninjaLayerInstance.ninja.xVelocity*dt) withYdistance:0];
            }
        }
    }
    
    if (self.overdrive){
        [overdriveTimer advanceTimer:dt];
        if ([overdriveTimer expired]){
            self.overdrive = false;
            [self resetColor];
        }
    }
    
    if (self.invisible){
        [invisibilityTimer advanceTimer:dt];
        if ([invisibilityTimer expired]){
            self.invisible = false;
            self.ninja.opacity = 255;
        }
    }
    
    [self checkAnimation];
    
    [self updateRectSize];
    if (justFinishedJump && (self.animation == JUMP_RIGHT)){
        [self animateSingleJumpRight];
    }
    if (justFinishedJump && (self.animation == JUMP_LEFT)){
        [self animateSingleJumpLeft];
    }
    [self setJustFinishedJump:NO];
    lastanimation = self.animation;
    
    [self checkHitBox:dt];
    
    [comboTimer advanceTimer:dt];
    [swingTimer advanceTimer:dt];
    [gameLayerInstance updateHealthBar];
}

-(void) resetColor{
    if (self.isDisabled){
        self.ninja.color = ccc3(255,180,0);
    }
    else if (self.overdrive){
        self.ninja.color = ccc3(255,0,0);
    }
    else{
        self.ninja.color = ccc3(255,255,255);
    }
}

-(void) addNinja{
    //ninja2 = [CCSprite spriteWithSpriteFrameName:@"ninjarunningright1"];
    self.ninja = [PhysicsSprite spriteWithSpriteFrameName:@"ninjaidleright.png"];
    self.ninja.position = ccp(xPosition,yPosition);
    self->directionFacing = 'R';
    [self addChild:self.ninja];
    [self.ninja setRectHeight:122 withWidth:40 withXOffset:0 andYOffset:-10];
    
}

-(void) setInitialHealth{
    self.maxHealth = pow(70,(1 + gameLayerInstance.healthLevel*.04));
    self.healthLeft = self.maxHealth;
}

-(void) adjustMaxHealth{
    self.maxHealth = pow(70,(1 + gameLayerInstance.healthLevel*.04));
    self.healthLeft = self.maxHealth;
}

-(void) checkHitBox:(ccTime)dt{
    if (nextHit != 0){
        //countdown the hit timer
        [hitTimer advanceTimer:dt];
        
        if ([hitTimer expired]){
            //generate hitboxes for everything
            switch (nextHit) {
                case 1:
                    [self hitLightAttackRight];
                    break;
                case 2:
                    [self hitLightAttackLeft];
                    break;
                case 3:
                    [self hitLightAttackRightB];
                    break;
                case 4:
                    [self hitLightAttackLeftB];
                    break;
                case 5:
                    [self hitLightAttackRightC];
                    break;
                case 6:
                    [self hitLightAttackLeftC];
                    break;
            }
            nextHit = 0;
        }
    }
}

-(void) checkAnimation{
    if (lastanimation !=self.animation){
        [self stopAnimations];
        
        switch (self.animation){
            case RUN_RIGHT:
                [self animateRunRight];
                break;
            case RUN_LEFT:
                [self animateRunLeft];
                break;
            case IDLE_RIGHT:
                [self animateIdleRight];
                break;
            case IDLE_LEFT:
                [self animateIdleLeft];
                break;
            case JUMP_RIGHT:
                [self animateSingleJumpRight];
                break;
            case JUMP_LEFT:
                [self animateSingleJumpLeft];
                break;
            case CROUCH_RUN_RIGHT:
                [self animateCrouchRunRight];
                break;
            case CROUCH_RUN_LEFT:
                [self animateCrouchRunLeft];
                break;
            case CROUCH_IDLE_RIGHT:
                [self animateCrouchIdleRight];
                break;
            case CROUCH_IDLE_LEFT:
                [self animateCrouchIdleLeft];
                break;
            case ATTACK_A_RIGHT:
                [self animateLightAttackRight];
                break;
            case ATTACK_A_LEFT:
                [self animateLightAttackLeft];
                break;
            case ATTACK_B_RIGHT:
                [self animateLightAttackRightB];
                break;
            case ATTACK_B_LEFT:
                [self animateLightAttackLeftB];
                break;
            case ATTACK_C_RIGHT:
                [self animateLightAttackRightC];
                break;
            case ATTACK_C_LEFT:
                [self animateLightAttackLeftC];
                break;
            case BLOCK_RIGHT:
                [self animateBlockRight];
                break;
            case BLOCK_LEFT:
                [self animateBlockLeft];
                break;
        }
    }
}

-(void) setXPosition:(float)Xcoord withYPosition:(float)Ycoord{
    xPosition = Xcoord;
    yPosition = Ycoord;
}

-(void) moveNinja:(float)Xval withYdistance:(float)Yval{
    //What do these variables even mean anymore?
    xPosition += Xval;
    yPosition += Yval;
    
    gameLayerInstance.overallPosition += Xval;
    [self.ninja moveSprite:Xval withY:Yval];
    //[ninja finalMove];
}


-(void) animateRunRight{
    [self.ninja runAction:[self.ninja makeContinuousAction:@"ninjarunningright" withNumFrames:20 andFrameDuration:.038f]];
}

-(void) animateRunLeft{
    [self.ninja runAction:[self.ninja makeContinuousAction:@"ninjarunningleft" withNumFrames:20 andFrameDuration:.038f]];
}

-(void) animateCrouchRunRight{
    [self.ninja runAction:[self.ninja makeContinuousAction:@"NinjaCrouchRunRight" withNumFrames:14 andFrameDuration:.055f]];
}

-(void) animateCrouchRunLeft{
    [self.ninja runAction:[self.ninja makeContinuousAction:@"NinjaCrouchRunLeft" withNumFrames:14 andFrameDuration:.055f]];
}

-(void) animateIdleRight{
    [self.ninja runAction:[self.ninja makeIdleAction:@"ninjaidleright.png"]];
}

-(void) animateIdleLeft{
    [self.ninja runAction:[self.ninja makeIdleAction:@"ninjaidleleft.png"]];
}

-(void) animateBlockRight{
    [self.ninja runAction:[self.ninja makeIdleAction:@"NinjaBlockRight.png"]];
}

-(void) animateBlockLeft{
    [self.ninja runAction:[self.ninja makeIdleAction:@"NinjaBlockLeft.png"]];
}

-(void) animateCrouchIdleRight{
    [self.ninja runAction:[self.ninja makeIdleAction:@"ninjacrouchingright.png"]];
}

-(void) animateCrouchIdleLeft{
    [self.ninja runAction:[self.ninja makeIdleAction:@"ninjarunningcrouchingleft.png"]];
}

-(void) animateSingleJumpLeft{
    [self.ninja runAction:[self.ninja makeFiniteAction:@"ninjajumpleft" withNumFrames:19 andFrameDuration:.019f]];
}

-(void) animateSingleJumpRight{
    [self.ninja runAction:[self.ninja makeFiniteAction:@"ninjajumpright" withNumFrames:19 andFrameDuration:.019f]];
}

-(void) animateLightAttackRight{
    self.inFiniteAnimation = YES;
    actionTimer = 0.4;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackRight" withNumFrames:4 andFrameDuration:.04f]];
    nextHit = 1;
    [hitTimer activateTimer:.08f];
    [swingTimer activateTimer:.24];
    [comboTimer activateTimer:[swingTimer timeRemaining] + .30];
    self.ninja.xVelocity = 400;
    self.nextCombo = 2;
    
}

-(void) animateLightAttackLeft{
    self.inFiniteAnimation = YES;
    actionTimer = 0.4;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackLeft" withNumFrames:4 andFrameDuration:.04f]];
    nextHit = 2;
    [hitTimer activateTimer:.08f];
    [swingTimer activateTimer:.24];
    [comboTimer activateTimer:[swingTimer timeRemaining] + .30];
    self.ninja.xVelocity = -400;
    self.nextCombo = 2;

}

-(void) animateLightAttackRightB{
    self.inFiniteAnimation = YES;
    actionTimer = .4;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackRightB" withNumFrames:4 andFrameDuration:.04f]];
    nextHit = 3;
    [hitTimer activateTimer:.08f];
    [swingTimer activateTimer:.24];
    [comboTimer activateTimer:[swingTimer timeRemaining] + .30];
    self.ninja.xVelocity = 400;
    self.nextCombo = 3;
}

-(void) animateLightAttackLeftB{
    self.inFiniteAnimation = YES;
    actionTimer = .4;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackLeftB" withNumFrames:4 andFrameDuration:.04f]];
    nextHit = 4;
    [hitTimer activateTimer:.08f];
    [swingTimer activateTimer:.24];
    [comboTimer activateTimer:[swingTimer timeRemaining] + .30];
    self.ninja.xVelocity = -400;
    self.nextCombo = 3;
}

-(void) animateLightAttackRightC{
    self.inFiniteAnimation = true;
    actionTimer = .6;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackRightC" withNumFrames:9 andFrameDuration:.03f]];
    nextHit = 5;
    [hitTimer activateTimer:.21];
    [swingTimer activateTimer:.40];
    [comboTimer deactivateTimer];
    self.ninja.xVelocity = 400;
    self.nextCombo = 1;
}

-(void) animateLightAttackLeftC{
    self.inFiniteAnimation = true;
    actionTimer = .6;
    [self.ninja runAction:[self.ninja makeFiniteAction:@"NinjaLightAttackLeftC" withNumFrames:9 andFrameDuration:.03f]];
    nextHit = 6;
    [hitTimer activateTimer:.21f];
    [swingTimer activateTimer:.40];
    [comboTimer deactivateTimer];
    self.ninja.xVelocity = -400;
    self.nextCombo = 1;
}

-(void) stopAnimations{
    [self.ninja stopAllActions];
}

-(float) xPos{
    return xPosition;
}

-(float) yPos{
    return yPosition;
}


-(void) setDirectionFacing:(char)directionChar{
    directionFacing = directionChar;
}

-(char) getDirectionFacing{
    return directionFacing;
}


-(void) updateRectSize{
    if (self.animation != lastanimation){
        [self updateRectInt];
    }
    

}

-(void) updateRectInt{
    //DONT REALLY NEED THIS ANYMORE
    /*
    switch (self.animation){
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            currentBoundBox = 0;
            //bottom is 71 pixels below center
            [self.ninja setRectHeight:122 withWidth:40 withXOffset:0 andYOffset:-10];
            break;
        case 9:
            currentBoundBox = 1;
            [self.ninja setRectHeight:90 withWidth:43 withXOffset:-5 andYOffset:-26];
            break;
        case 10:
            currentBoundBox = 1;
            [self.ninja setRectHeight:90 withWidth:43 withXOffset:5 andYOffset:-26];
            break;
    }*/
}

-(void) drawAllRects{
    [self.ninja drawRect];
}

-(void) slowDuringAttack:(ccTime)dt{
    if (ninjaLayerInstance.ninja.xVelocity > 0){
        ninjaLayerInstance.ninja.xVelocity -= 2500*dt;
        if (ninjaLayerInstance.ninja.xVelocity <=0){
            ninjaLayerInstance.ninja.xVelocity = 0;
        }
    }
    if (ninjaLayerInstance.ninja.xVelocity < 0){
        ninjaLayerInstance.ninja.xVelocity += 2500*dt;
        if (ninjaLayerInstance.ninja.xVelocity >=0){
            ninjaLayerInstance.ninja.xVelocity = 0;
        }
    }
}

-(void) startJump{
    if (self.inAir == NO){
        self.ninja.yVelocity = 620;
        lastanimation = NO_ANIMATION; //so a new jump animation is started
        self.inAir = YES;
    }
    
}

-(void) setBlockingAnimation{
    if (joystickVars->direction == 'R'){
        self.animation = BLOCK_RIGHT;
    }
    else if (joystickVars->direction == 'L'){
        self.animation = BLOCK_LEFT;
    }
    else if (self.getDirectionFacing == 'R'){
        self.animation = BLOCK_RIGHT;
    }
    else{
        self.animation = BLOCK_LEFT;
    }
}

-(void) takeHitWithDamage:(int) damage andKnockback:(int) knockback{
    if (!self.invisible){
        if (!(self.isBlocking && ((knockback > 0 && self.animation == BLOCK_LEFT) || (knockback < 0 && self.animation == BLOCK_RIGHT)))){
            nextHit = 0;
            self.healthLeft -= damage;
            gameLayerInstance.damageTaken += damage;
            [gameLayerInstance addDamageDisplay:damage color:'r' sizeMultiple:1 position:self.ninja.position];
            self.isDisabled = true;
            self.inFiniteAnimation = true;
            actionTimer = .4f;
            self.ninja.xVelocity = knockback * 30;
            self.ninja.yVelocity = abs(knockback) * 45;
            self.ninja.color = ccc3(255,180,0);
            if (knockback >= 0){
                self.animation = IDLE_LEFT;
                [self setDirectionFacing:'L'];
            }
            else{
                self.animation = IDLE_RIGHT;
                [self setDirectionFacing:'R'];
            }
            self.isBlocking = false;
        }
        else{
            [gameLayerInstance addBlockDamageDisplay:self.ninja.position];
            self.isDisabled = true;
            self.inFiniteAnimation = true;
            actionTimer = .2f;
            self.ninja.xVelocity = knockback *15;
            self.ninja.yVelocity = abs(knockback) * 22;
            if (knockback >= 0){
                self.animation = BLOCK_LEFT;
                [self setDirectionFacing:'L'];
            }
            else{
                self.animation = BLOCK_RIGHT;
                [self setDirectionFacing:'R'];
            }
        }
    }
}


-(void) hitLightAttackRight{
    CGRect rect = CGRectMake(self.ninja.position.x, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:[self generateRandomDamage] withKnockback:4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
    
}

-(void) hitLightAttackLeft{
    CGRect rect = CGRectMake(self.ninja.position.x-75, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:[self generateRandomDamage] withKnockback:-4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
}

-(void) hitLightAttackRightB{
    CGRect rect = CGRectMake(self.ninja.position.x, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:[self generateRandomDamage] withKnockback:4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
}

-(void) hitLightAttackLeftB{
    CGRect rect = CGRectMake(self.ninja.position.x-75, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:[self generateRandomDamage] withKnockback:-4 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
}

-(void) hitLightAttackRightC{
    CGRect rect = CGRectMake(self.ninja.position.x, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:([self generateRandomDamage] * 2) withKnockback:8 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
}

-(void) hitLightAttackLeftC{
    CGRect rect = CGRectMake(self.ninja.position.x-75, self.ninja.position.y-40, 75, 100);
    HitBox *attack = [[HitBox alloc] initWithRect:rect];
    [attack setHitBoxDamage:([self generateRandomDamage] * 2) withKnockback:-8 andRectDuration:.3f];
    [gameLayerInstance.hitDetectorInstance.ninjaHitBoxList addObject:attack];
    [attack release];
}


-(void) startLightAttack{
    //determine what kind of light attack needs to start
    //will be called regardless of finite action timer
    if (![swingTimer stillRunning]){
        if (![comboTimer stillRunning]){
            if ([self getDirectionFacing] == 'R'){
                [self setAnimation:ATTACK_A_RIGHT];
                self.inFiniteAnimation = YES;
            }
            if ([self getDirectionFacing] == 'L'){
                [self setAnimation:ATTACK_A_LEFT];
                self.inFiniteAnimation = YES;
            }
        }
        if ([comboTimer stillRunning]){
            if (self.nextCombo == 2){
                if ([self getDirectionFacing] == 'R'){
                    [self setAnimation:ATTACK_B_RIGHT];
                    self.inFiniteAnimation = YES;
                }
                if ([self getDirectionFacing] == 'L'){
                    [self setAnimation:ATTACK_B_LEFT];
                    self.inFiniteAnimation = YES;
                }
            }
            if (self.nextCombo == 3) {
                if ([self getDirectionFacing] == 'R'){
                    [self setAnimation:ATTACK_C_RIGHT];
                    self.inFiniteAnimation = YES;
                }
                if ([self getDirectionFacing] == 'L'){
                    [self setAnimation:ATTACK_C_LEFT];
                    self.inFiniteAnimation = YES;
                }
            }
        }
    }
    else{
        //swingtimer is still running, meaning attack button was pressed too early so combo resets
        self.nextCombo = 1;
        [comboTimer deactivateTimer];
    }
}

-(void) startBlock{
    self.blockPressed = true;
}

-(void) endBlock{
    self.blockPressed = false;
}

-(int) generateRandomDamage{
    int min = 4 + gameLayerInstance.damageLevel*2.2;
    int max = 6 + gameLayerInstance.damageLevel*3;
    int damage = min + arc4random()%(max-min);
    if (self.overdrive){
        damage *= 2;
    }
    return damage;
}

-(void) activateOverdrive{
    self.overdrive = true;
    self.ninja.color = ccc3(255, 0, 0);
    [overdriveTimer activateTimer:10.0];
}

-(void) activateInvisibility{
    self.ninja.opacity = 130;
    self.invisible = true;
    [invisibilityTimer activateTimer:10];
}

-(void) dealloc{
    [hitTimer release];
    [swingTimer release];
    [comboTimer release];
    [overdriveTimer release];
    [invisibilityTimer release];
    [super dealloc];
}

@end
