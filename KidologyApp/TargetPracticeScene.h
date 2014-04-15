//
//  TargetPracticeScene.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    CENTER,
    RANDOM
} Mode;


typedef enum {
    TOUCHING,
    NOT_TOUCHING
} AnchorStatus;


@interface TargetPracticeScene : SKScene
    @property (nonatomic) SKSpriteNode * target;
    @property (nonatomic) SKLabelNode *targetsLabel;
    @property (nonatomic) SKLabelNode *tapSreenLabel;
    @property (nonatomic) SKSpriteNode *anchor;
    @property (nonatomic) SKSpriteNode *pressedAnchor;
    @property (nonatomic) SKSpriteNode *quitButton;
    @property (nonatomic) SKSpriteNode *quitButtonPressed;
    @property (nonatomic) int totalTouches;
    @property (nonatomic) int correctTouches;
    @property (nonatomic) int totalTargets;
    @property (nonatomic) int delayBetweenTargets;
    @property (nonatomic) NSString *affectedHand;
    @property (nonatomic) float targetSize;
    @property (nonatomic) float time;
    @property (nonatomic) float time_not_anchored;
    @property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
    @property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
    @property (nonatomic) Mode gameMode;
    @property (nonatomic) AnchorStatus anchored;

//.........................................................................

-(id)initWithSize:(CGSize)size game_mode:(int)game_mode;
@end
