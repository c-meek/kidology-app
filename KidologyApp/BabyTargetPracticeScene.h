//
//  BabyTargetPracticeScene.h
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BabyTargetPracticeScene : SKScene
@property (nonatomic) SKSpriteNode * target;
@property (nonatomic) int totalTouches;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) float time;
@property (nonatomic) SKSpriteNode *quitButton;
@property (nonatomic) SKSpriteNode *quitButtonPressed;
@property (nonatomic) int targetsHit;
-(id)initWithSize:(CGSize)size color:(NSString *)color;
@end
