//
//  TargetPracticeMenuScene.h
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TargetPracticeMenuScene : SKScene
@property (nonatomic) SKSpriteNode *backButton;
@property (nonatomic) SKSpriteNode *backButtonPressed;
@property (nonatomic) SKSpriteNode *centerModeButton;
@property (nonatomic) SKSpriteNode *centerModeButtonPressed;
@property (nonatomic) SKSpriteNode *randomModeButton;
@property (nonatomic) SKSpriteNode *randomModeButtonPressed;
@property (nonatomic) SKSpriteNode *gestureModeButton;
@property (nonatomic) SKSpriteNode *gestureModeButtonPressed;
@property (nonatomic) SKSpriteNode * target;
@property (nonatomic) SKSpriteNode * hand;
@property (nonatomic) SKSpriteNode *customModeButton;
@property (nonatomic) SKSpriteNode *customModeButtonPressed;
@property (nonatomic) NSMutableArray *gameArray;
@property (nonatomic) UITableView *tbv;
@property (nonatomic) BOOL enableSound;
@end
