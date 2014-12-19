//
//  GenericEnemyLayer.m
//  NinjaGame
//
//  Created by Joey on 3/13/13.
//
//

#import "EnemyLayer.h"
#import "EnemySprite.h"
#import "NinjaEnemy.h"
#import "GameLayer.h"
#import "WolfEnemy.h"
#import "BanditEnemy.h"

@implementation EnemyLayer

@synthesize enemyBatch = _enemyBatch;
@synthesize wolfBatch = _wolfBatch;




-(id)init{
    if ( (self = [super init]) ){
        
        if (gameLayerInstance.gameLevel == 1){
            [self setupLevel1EnemyLayer];
        }
        if (gameLayerInstance.gameLevel == 2){
            [self setupLevel2EnemyLayer];
        }
        if (gameLayerInstance.gameLevel == 3){
            [self setupLevel3EnemyLayer];
        }
        if (gameLayerInstance.gameLevel == 4){
            [self setupLevel4EnemyLayer];
        }
        if (gameLayerInstance.gameLevel == 5){
            [self setupLevel5EnemyLayer];
        }
        if (gameLayerInstance.gameLevel == 6){
            [self setupLevel6EnemyLayer];
        }
        
    }
    return self;
}

-(void) addStillNinjaEnemy:(CGPoint)position withType:(char)type andDirection:(char)direction{
    NinjaEnemy * enemy;
    if (direction == 'l'){
        enemy = [NinjaEnemy spriteWithSpriteFrameName:@"ninjaidleleft.png"];
        enemy.directionLooking = 'l';
        enemy.animation = 1;
        enemy.previousAnimation = 1;
    }
    else{
        enemy = [NinjaEnemy spriteWithSpriteFrameName:@"ninjaidleright.png"];
        enemy.directionLooking = 'r';
        enemy.animation = 0;
        enemy.previousAnimation = 0;
    }
    enemy.position = ccp(position.x+enemy.boundingBox.size.width/2, position.y+enemy.boundingBox.size.height/2);
    enemy.mode = STILL_ENEMY;
    enemy.originalMode = STILL_ENEMY;
    [self.enemyBatch addChild:enemy];
    enemy.colorType = type;
    if (type == 'r'){
        enemy.color = ccc3(255, 0, 0);
    }
    if (type == 'g'){
        enemy.color = ccc3(0, 255, 0);
    }
    if (type == 'b'){
        enemy.color = ccc3(140, 140, 255);
    }
    [enemy startAI];
}

-(void) addStillBanditEnemy:(CGPoint)position withType:(char)type andDirection:(char)direction{
    BanditEnemy * enemy;
    if (direction == 'l'){
        enemy = [BanditEnemy spriteWithSpriteFrameName:@"BanditIdleLeft.png"];
        enemy.directionLooking = 'l';
        enemy.animation = 1;
        enemy.previousAnimation = 1;
    }
    else{
        enemy = [NinjaEnemy spriteWithSpriteFrameName:@"BanditIdleRight.png"];
        enemy.directionLooking = 'r';
        enemy.animation = 0;
        enemy.previousAnimation = 0;
    }
    enemy.position = ccp(position.x+enemy.boundingBox.size.width/2, position.y+enemy.boundingBox.size.height/2);
    enemy.mode = STILL_ENEMY;
    enemy.originalMode = STILL_ENEMY;
    [self.enemyBatch addChild:enemy];
    enemy.colorType = type;
    if (type == 'r'){
        enemy.color = ccc3(255, 0, 0);
    }
    if (type == 'g'){
        enemy.color = ccc3(0, 255, 0);
    }
    if (type == 'b'){
        enemy.color = ccc3(140, 140, 255);
    }
    [enemy startAI];
}

-(void) addPatrolingNinjaEnemy:(CGPoint)position type:(char)type direction:(char)direction patrolRange:(int)patrolRange{
    NinjaEnemy *enemy;
    if (direction == 'l'){
        enemy = [NinjaEnemy spriteWithSpriteFrameName:@"ninjaidleleft.png"];
        enemy.directionLooking = 'l';
        enemy.animation = 1;
        enemy.previousAnimation = 1;
    }
    else{
        enemy = [NinjaEnemy spriteWithSpriteFrameName:@"ninjaidleright.png"];
        enemy.directionLooking = 'r';
        enemy.animation = 0;
        enemy.previousAnimation = 0;
    }
    enemy.position = ccp(position.x, position.y);
    enemy.mode = PATROL_ENEMY;
    enemy.originalMode = PATROL_ENEMY;
    
    enemy.patrolRange = patrolRange;
    
    [self.enemyBatch addChild:enemy];
    enemy.colorType = type;
    if (type == 'r'){
        enemy.color = ccc3(255, 0, 0);
    }
    if (type == 'g'){
        enemy.color = ccc3(0, 255, 0);
    }
    if (type == 'b'){
        enemy.color = ccc3(140, 140, 255);
    }
    [enemy startAI];
}

-(void) addPatrolingBanditEnemy:(CGPoint)position type:(char)type direction:(char)direction patrolRange:(int)patrolRange{
    BanditEnemy *enemy;
    if (direction == 'l'){
        enemy = [BanditEnemy spriteWithSpriteFrameName:@"BanditIdleLeft.png"];
        enemy.directionLooking = 'l';
        enemy.animation = 1;
        enemy.previousAnimation = 1;
    }
    else{
        enemy = [BanditEnemy spriteWithSpriteFrameName:@"BanditIdleRight.png"];
        enemy.directionLooking = 'r';
        enemy.animation = 0;
        enemy.previousAnimation = 0;
    }
    enemy.position = ccp(position.x, position.y);
    enemy.mode = PATROL_ENEMY;
    enemy.originalMode = PATROL_ENEMY;
    
    enemy.patrolRange = patrolRange;
    
    [self.enemyBatch addChild:enemy];
    enemy.colorType = type;
    if (type == 'r'){
        enemy.color = ccc3(255, 0, 0);
    }
    if (type == 'g'){
        enemy.color = ccc3(0, 255, 0);
    }
    if (type == 'b'){
        enemy.color = ccc3(140, 140, 255);
    }
    [enemy startAI];
}

-(void) addPatrolingWolf:(CGPoint)position diretion:(char)direction range:(int)range{
    WolfEnemy *wolf;
    if (direction == 'r'){
        wolf = [WolfEnemy spriteWithSpriteFrameName:@"WolfWalkRight0001.png"];
        wolf.animation = 0;
        wolf.previousAnimation = 0;
        [wolf animateWalkRight];
    }
    else{
        wolf = [WolfEnemy spriteWithSpriteFrameName:@"WolfWalkLeft0001.png"];
        wolf.animation = 1;
        wolf.previousAnimation = 1;
        [wolf animateWalkLeft];
    }
    wolf.position = position;
    wolf.originalPosition = position;
    wolf.mode = 'p';
    wolf.originalMode = 'p';
    wolf.directionLooking = direction;
    wolf.range = range;
    [self.wolfBatch addChild:wolf];
    if (direction == 'r'){
        wolf.animation = 0;
        wolf.previousAnimation = 0;
    }
    else{
        wolf.animation = 1;
        wolf.previousAnimation = 1;
    }
    
    [wolf startAI];
}


-(void) startWolfBatch{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"WolfSpriteSheet.plist"];
    self.wolfBatch = [CCSpriteBatchNode batchNodeWithFile:@"WolfSpriteSheet.png"];
    [self addChild:self.wolfBatch];
}

-(void) setupLevel3EnemyLayer{
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjaspritesheet.png"];
    [self addChild:self.enemyBatch];
    
    [self addStillNinjaEnemy:ccp(800,300) withType:'r' andDirection:'l'];
    [self addStillNinjaEnemy:ccp(1100,120) withType:'g' andDirection:'l'];
    [self addStillNinjaEnemy:ccp(1300,290) withType:'b' andDirection:'r'];
    [self addStillNinjaEnemy:ccp(1450,290) withType:'g' andDirection:'r'];
    [self addStillNinjaEnemy:ccp(2000,500) withType:'b' andDirection:'r'];
    [self addStillNinjaEnemy:ccp(2050,500) withType:'r' andDirection:'r'];
    [self addStillNinjaEnemy:ccp(2300,500) withType:'b' andDirection:'l'];
    [self addStillNinjaEnemy:ccp(2700,500) withType:'g' andDirection:'r'];
}

-(void) setupLevel2EnemyLayer{
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjaspritesheet.png"];
    [self addChild:self.enemyBatch];
    
    //[self addStillNinjaEnemy:ccp(900,140) withType:'b' andDirection:'r'];
    [self addPatrolingNinjaEnemy:ccp(500, 140) type:'r' direction:'r' patrolRange:300];
}

-(void) setupLevel1EnemyLayer{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"BanditSpriteSheet.plist"];
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"BanditSpriteSheet.png"];
    [self addChild:self.enemyBatch];
    
    [self addPatrolingBanditEnemy:ccp(1000,80) type:'0' direction:'r' patrolRange:200];
    [self addPatrolingBanditEnemy:ccp(1700,80) type:'0' direction:'l' patrolRange:180];
    [self addPatrolingBanditEnemy:ccp(2800,500) type:'0' direction:'r' patrolRange:230];
    [self addPatrolingBanditEnemy:ccp(3500,500) type:'0' direction:'r' patrolRange:230];
    [self addStillBanditEnemy:ccp(3800,500) withType:'0' andDirection:'l'];
    [self addPatrolingBanditEnemy:ccp(4300,500) type:'0' direction:'l' patrolRange:200];
    [self addPatrolingBanditEnemy:ccp(4750,600) type:'0' direction:'l' patrolRange:220];
    [self addPatrolingBanditEnemy:ccp(5100,5000) type:'0' direction:'r' patrolRange:180];
    [self addPatrolingBanditEnemy:ccp(5600,80) type:'0' direction:'r' patrolRange:150];
    [self addPatrolingBanditEnemy:ccp(6300,80) type:'0' direction:'l' patrolRange:300];
    [self addStillBanditEnemy:ccp(6600,80) withType:'0' andDirection:'l'];
    [self addPatrolingBanditEnemy:ccp(7300,300) type:'0' direction:'r' patrolRange:240];
    [self addPatrolingBanditEnemy:ccp(8100,300) type:'0' direction:'r' patrolRange:200];
    [self addPatrolingBanditEnemy:ccp(8500,300) type:'0' direction:'r' patrolRange:220];
    [self addPatrolingBanditEnemy:ccp(9200,300) type:'0' direction:'r' patrolRange:200];

}

-(void) setupLevel4EnemyLayer{
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjaspritesheet.png"];
    [self addChild:self.enemyBatch];
    
    [self startWolfBatch];
    
    [self addStillNinjaEnemy:ccp(900,140) withType:'b' andDirection:'r'];
    
    [self addPatrolingWolf:ccp(600,100) diretion:'r' range:400];
}

-(void) setupLevel5EnemyLayer{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"BanditSpriteSheet.plist"];
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"BanditSpriteSheet.png"];
    [self addChild:self.enemyBatch];
    
    [self addPatrolingBanditEnemy:ccp(600,140) type:'0' direction:'r' patrolRange:300];
    [self addPatrolingBanditEnemy:ccp(720,140) type:'0' direction:'l' patrolRange:200];
    [self addPatrolingBanditEnemy:ccp(800,140) type:'0' direction:'r' patrolRange:250];
    [self addPatrolingBanditEnemy:ccp(900,140) type:'0' direction:'l' patrolRange:100];
    [self addPatrolingBanditEnemy:ccp(1100,140) type:'0' direction:'r' patrolRange:300];

}

-(void) setupLevel6EnemyLayer{
    self.enemyBatch = [CCSpriteBatchNode batchNodeWithFile:@"ninjaspritesheet.png"];
    [self addChild:self.enemyBatch];
    
    [self addPatrolingNinjaEnemy:ccp(600,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(800,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(900,140) type:'g' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(950,140) type:'b' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1100,140) type:'r' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1400,140) type:'b' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1500,140) type:'b' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1700,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1900,140) type:'g' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(2200,140) type:'r' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(2500,140) type:'g' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(1900,140) type:'b' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3000,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3100,140) type:'g' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3200,140) type:'g' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3300,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3700,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3750,140) type:'b' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3800,140) type:'b' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(3900,140) type:'r' direction:'l' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(4200,140) type:'g' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(4400,140) type:'r' direction:'r' patrolRange:300];
    [self addPatrolingNinjaEnemy:ccp(4500,140) type:'b' direction:'l' patrolRange:300];


}

-(void) poisonEnemiesOnScreen{
    for (EnemySprite *enemy in enemyLayerInstance.enemyBatch.children){
        if (enemy.position.x >= 0 && enemy.position.x <= [[CCDirector sharedDirector] winSize].width && enemy.position.y >= 0 && enemy.position.y <= [[CCDirector sharedDirector] winSize].height){
            [enemy poisonSelf];
        }
    }
}

-(void) freezeEnemiesOnScreen{
    for (EnemySprite *enemy in enemyLayerInstance.enemyBatch.children){
        if (enemy.position.x >= 0 && enemy.position.x <= [[CCDirector sharedDirector] winSize].width && enemy.position.y >= 0 && enemy.position.y <= [[CCDirector sharedDirector] winSize].height){
            [enemy freezeSelf];
        }
    }
}

-(void) drawAllRects{
    for (PhysicsSprite *sprite in self.enemyBatch.children){
        [sprite drawRect];
    }
    for (PhysicsSprite *sprite in self.wolfBatch.children){
        [sprite drawRect];
    }
}

@end
