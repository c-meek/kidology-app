//
//  BabyMenuScene.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BabyMenuScene : SKScene
@property (nonatomic) SKSpriteNode *backButton;
@property (nonatomic) SKSpriteNode *pressedBackButton;
@property (nonatomic) SKLabelNode * backButtonLabel;
@property (nonatomic) BOOL enableSound;
@end
