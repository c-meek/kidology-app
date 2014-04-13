//
//  TargetPracticeGameOver.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TargetPracticeGameOver : SKScene
-(id)initWithSize:(CGSize)size targets:(int)targets;
@property (nonatomic) SKSpriteNode *playAgainButton;
@property (nonatomic) SKSpriteNode *playAgainButtonPressed;
@property (nonatomic) SKSpriteNode *backToTargetGameMenuButton;
@property (nonatomic) SKSpriteNode *backToTargetGameMenuButtonPressed;
@property (nonatomic) SKSpriteNode *backToMainMenuButton;
@property (nonatomic) SKSpriteNode *backToMainMenuButtonPressed;
@property (nonatomic) SKLabelNode *returnMessage;
@property (nonatomic) NSMutableArray *gameArray;
@property (nonatomic) UITableView *tbv;
@end
