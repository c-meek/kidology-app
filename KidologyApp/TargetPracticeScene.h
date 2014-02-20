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
    INCORRECT,
    CORRECT
} Touch_Type;

typedef struct {
    
} Log_Entry;

@interface TargetPracticeScene : SKScene
    @property (nonatomic) SKSpriteNode * anchorPanel;
    @property (nonatomic) SKSpriteNode * target;
    @property (nonatomic) SKLabelNode *targetsLabel;
    @property (nonatomic) int totalTouches;
    @property (nonatomic) int correctTouches;
    @property (nonatomic) int totalTargets;
    @property (nonatomic) float time;
    @property (nonatomic) float time_not_anchored;
    @property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
    @property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
    @property (nonatomic) Mode gameMode;
@end
