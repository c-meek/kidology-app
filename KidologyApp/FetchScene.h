//
//  FetchGame.h
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/13/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FetchScene: SKScene
@property (nonatomic) SKSpriteNode * ball;
@property (nonatomic) SKSpriteNode * dog;
@property (nonatomic) int totalTargets;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) SKSpriteNode *backButton;
@property (nonatomic) SKSpriteNode *pressedBackButton;
@property (nonatomic) SKLabelNode * backButtonLabel;
@end
