//
//  TargetPracticeMenuScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeMenuScene.h"
#import "TargetPracticeScene.h"

@implementation TargetPracticeMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKLabelNode *instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        instructionLabel.fontSize = 40;
        instructionLabel.fontColor = [SKColor grayColor];
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+100);
        instructionLabel.text = @"Instructions:";
        [self addChild:instructionLabel];
        
        SKLabelNode *instructionContentLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        instructionContentLabel.fontSize = 20;
        instructionContentLabel.fontColor = [SKColor grayColor];
        instructionContentLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+60);
        instructionContentLabel.horizontalAlignmentMode = 1;
        instructionContentLabel.text = @"Click on the center of the target when they appears.";
        [self addChild:instructionContentLabel];
        
        
        _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _backButton.position = CGPointMake(self.frame.size.width - 55, self.frame.size.height/2+250);
        _backButton.name = @"backButton";
        [self addChild:_backButton];
        
        _backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _backButtonLabel.fontSize = 35;
        _backButtonLabel.fontColor = [SKColor grayColor];
        _backButtonLabel.position = CGPointMake(self.frame.size.width-62, self.frame.size.height/2 + 235);
        _backButtonLabel.text = @"Back";
        [self addChild:_backButtonLabel];
        
        _centerModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _centerModeButton.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-200);
        _centerModeButton.name = @"centerButton";
        [self addChild:_centerModeButton];
        
        _randomModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _randomModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-200);
        _randomModeButton.name = @"randomButton";
        [self addChild:_randomModeButton];
        
    }
    return self;
}
@end
