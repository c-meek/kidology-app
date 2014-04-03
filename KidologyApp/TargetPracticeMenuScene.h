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
@property (nonatomic) SKLabelNode *backButtonLabel;
@property (nonatomic) SKSpriteNode *centerModeButton;
@property (nonatomic) SKLabelNode *centerModeButtonLabel;
@property (nonatomic) SKSpriteNode *randomModeButton;
@property (nonatomic) SKLabelNode *randomModeButtonLabel;
@property (nonatomic) SKSpriteNode *actionModeButton;
@property (nonatomic) SKLabelNode *actionModeButtonLabel;
@property (nonatomic) SKSpriteNode * target;
@property (nonatomic) SKSpriteNode * hand;
@property (nonatomic) SKSpriteNode *customModeButton;
@property (nonatomic) SKLabelNode *customModeLabel;
@property NSMutableArray *gameArray;
@property UITableView *tbv;

@end
