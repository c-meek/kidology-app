//
//  CustomTargetPracticeScene.h
//  KidologyApp
//
//  Created by klimczak, andrew edward on 3/19/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TargetPracticeScene.h"

@interface CustomTargetPracticeScene : SKScene
@property (nonatomic) NSArray *commandArray;
@property (nonatomic) SKSpriteNode *target;
@property (nonatomic) SKLabelNode *targetsLabel;
@property (nonatomic) SKSpriteNode *quitButton;
@property (nonatomic) SKSpriteNode *quitButtonPressed;
@property (nonatomic) int totalTouches;
@property (nonatomic) int correctTouches;
@property (nonatomic) int totalTargets;
@property (nonatomic) BOOL enableSound;
@property (nonatomic) float delayDuration;
@property (nonatomic) int targetIterator;
@property (nonatomic) float time;
@property (nonatomic) float time_not_anchored;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) AnchorStatus anchored;
@property (nonatomic) SKSpriteNode *anchor;
@property (nonatomic) SKSpriteNode *pressedAnchor;
@end
