//
//  LevelSelectLayer.m
//  NinjaGame
//
//  Created by Joey on 5/2/13.
//
//

#import "LevelSelectLayer.h"
#import "LevelSelectBackgroundLayer.h"
#import "GameScene.h"
#import "LoadingLayer.h"

@implementation LevelSelectLayer

@synthesize iconList = _iconList;
@synthesize playGameLabel = _playGameLabel;
@synthesize playGameSprite = _playGameSprite;
@synthesize backLabel = _backLabel;
@synthesize backSprite = _backSprite;
@synthesize clickTimer = _clickTimer;
@synthesize isSwiping = _isSwiping;
@synthesize positionX = _positionX;
@synthesize lastPositionX= _lastPositionX;
@synthesize touchLocation = _touchLocation;
@synthesize touchPending = _touchPending;
@synthesize swipeSpeed = _swipeSpeed;
@synthesize inPostSwipe = _inPostSwipe;

+(id) scene{
    CCScene *scene = [CCScene node];
    
    LevelSelectBackgroundLayer *levelSelectBackgroundLayerInstance = [LevelSelectBackgroundLayer node];
    [scene addChild:levelSelectBackgroundLayerInstance];
    LevelSelectLayer * levelSelectLayerInstance = [LevelSelectLayer node];
    [scene addChild:levelSelectLayerInstance];
    
    return scene;
}

-(id) init{
    if ((self = [super init])){
        [self schedule:@selector(nextFrame:)];
        self.isTouchEnabled = true;
        self.iconList = [[NSMutableArray alloc] init];
        self.buttonsActive = false;
        self.clickTimer = 0;
        self.positionX = 0;
        self.positionRange = 200;
        
        
        //create the play button
        self.playGameSprite = [CCSprite spriteWithFile:@"GreyedOutButton.png"];
        self.playGameSprite.position = ccp(380,50);
        [self addChild:self.playGameSprite];
        self.playGameLabel = [CCLabelTTF labelWithString:@"Play" fontName:@"Noteworthy-Bold" fontSize:30];
        self.playGameLabel.position = ccp(380,53);
        self.playGameLabel.color = ccc3(120,120,120);
        self.playGameLabel.zOrder = 2;
        [self addChild:self.playGameLabel];
        
        
        //create the back button
        self.backSprite = [CCSprite spriteWithFile:@"BlackButton.png"];
        self.backSprite.position = ccp(100,50);
        [self addChild:self.backSprite];
        self.backLabel = [CCLabelTTF labelWithString:@"Back" fontName:@"Noteworthy-Bold" fontSize:30];
        self.backLabel.position = ccp(100,53);
        self.backLabel.color = ccc3(255,255,255);
        self.backLabel.zOrder = 2;
        [self addChild:self.backLabel];
        
        
        
        //creating and positioning the icons
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:1 andPosition:ccp(110,240)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:2 andPosition:ccp(180,260)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:3 andPosition:ccp(240,210)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:4 andPosition:ccp(180,160)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:5 andPosition:ccp(240,120)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:6 andPosition:ccp(300,160)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:7 andPosition:ccp(370,160)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:8 andPosition:ccp(430,210)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:9 andPosition:ccp(490,250)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:10 andPosition:ccp(560,250)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:11 andPosition:ccp(600,200)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:12 andPosition:ccp(540,160)]];
        [self.iconList addObject:[[LevelIcon alloc] initWithLevelNumber:13 andPosition:ccp(600,120)]];
        for (LevelIcon *icon in self.iconList){
            [self addChild:icon.sprite];
            [self addChild:icon.highlightSprite];
            [self addChild:icon.label];
        }
        
        
    }
    return self;
}

-(void) nextFrame:(ccTime)dt{
    self.clickTimer -= dt;
    if (self.touchPending && (self.clickTimer <= 0)){
        [self respondToTouch:self.touchLocation];
        self.touchPending = false;
    }
    
    
    if (self.inPostSwipe){
        NSLog(@"%f,%f",self.swipeSpeed,self.positionX);
        if ((self.swipeSpeed >= 0) && ((self.positionX >= (-self.positionRange-5)) && (self.positionX <= (-self.positionRange+5)))){
            //if its moving right and is very close to left edge(like its at the end of its post-swipe adjustment)
            self.swipeSpeed = 0;
            for (LevelIcon *icon in self.iconList){
                [icon moveIcon:-self.positionRange-self.positionX];
            }
            self.positionX = -self.positionRange;
            self.inPostSwipe = false;
            
            
        }
        if ((self.swipeSpeed <= 0) && ((self.positionX >= -5) && (self.positionX <= 5))){
            self.swipeSpeed = 0;
            for (LevelIcon *icon in self.iconList){
                [icon moveIcon:-self.positionX];
            }
            self.positionX = 0;
            self.inPostSwipe = false;
        }
        else if ((self.positionX > 0)){
            self.swipeSpeed = -self.positionX * 5;
            if (self.swipeSpeed > -400){
                self.swipeSpeed = -400 + (200 - self.positionX*2);
            }
        }
        else if (self.positionX < -self.positionRange){
            //needs to be moved right
            self.swipeSpeed = -(self.positionX + self.positionRange) * 5;
            if (self.swipeSpeed < 400){
                self.swipeSpeed = 400 - (200 + (self.positionX + self.positionRange)*2);//should always be over 200 to make smooth stop
            }
        }
        else{
            if (self.swipeSpeed > 0){
                self.swipeSpeed -=10;
                if ((self.swipeSpeed <= 0) && (self.positionX >= -self.positionRange) && (self.positionX <= 0)){
                    self.swipeSpeed = 0;
                    self.inPostSwipe = false;
                }
            }
            if (self.swipeSpeed < 0){
                self.swipeSpeed += 10;
                if ((self.swipeSpeed >= 0) && (self.positionX >= -self.positionRange) && (self.positionX <= 0)){
                    self.swipeSpeed = 0;
                    self.inPostSwipe = false;
                }
            }
        }
        
        for (LevelIcon *icon in self.iconList){
            [icon moveIcon:self.swipeSpeed * dt];
        }
        self.positionX += self.swipeSpeed*dt;
        
        
    }
    
    self.swipeSpeed = (self.positionX - self.lastPositionX)/dt;
    self.lastPositionX = self.positionX;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (location.y <= 75){
        [self respondToTouch:location]; //touch is below swiping area
    }
    
    else{
        self.clickTimer = .15f;
        self.touchLocation = location;
        self.touchPending = true;
    }
    return true;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];

    if (self.touchPending){
        self.touchPending = false;
        self.isSwiping = true;
    }
    if (self.isSwiping){
        for (LevelIcon *icon in self.iconList){
            [icon moveIcon:(location.x - self.touchLocation.x)/2];
        }
        
        self.positionX += (location.x - self.touchLocation.x)/2;

        self.touchLocation = location;
    }
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if ((self.touchPending == true) && (self.isSwiping == false)){
        [self respondToTouch:self.touchLocation];
        self.touchPending = false;
    }
    if (self.isSwiping){
        self.isSwiping = false;
        self.inPostSwipe = true;
    }
}

-(void) respondToTouch:(CGPoint)location{
    for (LevelIcon *icon in self.iconList){
        if (CGRectContainsPoint(icon.sprite.boundingBox, location)){
            if (self.buttonsActive == false){
                [self activateButtons];
                self.buttonsActive = true;
            }
            icon.isSelected = true;
            icon.highlightSprite.visible = true;
            icon.label.color = ccc3(230,0,0);
            int levelNum = icon.levelNumber;
            for (LevelIcon *testIcon in self.iconList){
                //named testIcon to stop confusion with other icon
                if (testIcon.levelNumber != levelNum){
                    testIcon.isSelected = false;
                    testIcon.highlightSprite.visible = false;
                    testIcon.label.color = ccc3(255,255,255);
                }
            }
        }
    }
    if (CGRectContainsPoint(self.backSprite.boundingBox, location)){
        CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlueButton.png"];
        tempSprite.position = self.backSprite.position;
        [self removeChild:self.backSprite cleanup:true];
        self.backSprite = tempSprite;
        [self addChild:self.backSprite];
        
        [LoadingLayer startMainMenu];
    }
    
    
    if (self.buttonsActive){
        if (CGRectContainsPoint(self.playGameSprite.boundingBox, location)){
            int level = 0;
            
            //change color to blue
            CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlueButton.png"];
            tempSprite.position = self.playGameSprite.position;
            [self removeChild:self.playGameSprite cleanup:true];
            self.playGameSprite = tempSprite;
            [self addChild:self.playGameSprite];
            
            for (LevelIcon *icon in self.iconList){
                if (icon.isSelected == true){
                    level = icon.levelNumber;
                }
            }
            if (level == 1){
                [LoadingLayer startLevel:1];
            }
            if (level == 2){
                [LoadingLayer startLevel:2];
            }
            if (level == 3){
                [LoadingLayer startLevel:3];
            }
            if (level == 4){
                [LoadingLayer startLevel:4];
            }
            if (level == 5){
                [LoadingLayer startLevel:5];
            }
            if (level == 6){
                [LoadingLayer startLevel:6];
            }
        }
    }
}

-(void) activateButtons{
    CCSprite *tempSprite = [CCSprite spriteWithFile:@"BlackButton.png"];
    tempSprite.position = self.playGameSprite.position;
    [self removeChild:self.playGameSprite cleanup:true];
    self.playGameSprite = tempSprite;
    [self addChild:self.playGameSprite];
    
    self.playGameLabel.color = ccc3(255,255,255);
}

-(void) draw{
    glLineWidth(5.0f);
    ccDrawColor4B(0, 0, 0, 255);
    for (int i = 0; i < 12; i++){
        LevelIcon *icon1 = [self.iconList objectAtIndex:i];
        LevelIcon *icon2 = [self.iconList objectAtIndex:i+1];
        ccDrawLine(icon1.sprite.position, icon2.sprite.position);
    }
    [super draw];
}

-(void) dealloc{
    [self.iconList release];
    [super dealloc];
}

@end

@implementation LevelIcon

@synthesize label = _label;
@synthesize sprite = _sprite;
@synthesize isSelected = _isSelected;
@synthesize levelNumber = _levelNumber;
@synthesize highlightSprite = _highlightSprite;

-(id) initWithLevelNumber:(int)num andPosition:(CGPoint)position{
    if ((self = [super init])){
        self.levelNumber = num;
        NSString *string = [NSString stringWithFormat:@"%d", num];
        self.label = [CCLabelTTF labelWithString: string fontName:@"Noteworthy-Bold" fontSize:20];
        self.label.position = position;
        self.label.color = ccc3(255, 255, 255);
        
        self.sprite = [CCSprite spriteWithFile:@"LevelSelectIcon.png"];
        self.sprite.position = position;
        
        self.highlightSprite = [CCSprite spriteWithFile:@"SelectedIconBackgroundType2.png"];
        self.highlightSprite.position = position;
        self.highlightSprite.visible = false;
        self.highlightSprite.zOrder = -1;
    }
    return self;
}

-(void) moveIcon:(float)xDistance{
    self.label.position = ccp(self.label.position.x + xDistance, self.label.position.y);
    self.sprite.position = ccp(self.sprite.position.x + xDistance, self.sprite.position.y);
    self.highlightSprite.position = ccp(self.highlightSprite.position.x + xDistance, self.highlightSprite.position.y);
}


@end
