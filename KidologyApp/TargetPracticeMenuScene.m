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
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)+100);
        instructionLabel.text = @"Instructions:";
        [self addChild:instructionLabel];
        
        SKLabelNode *instructionContentLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        instructionContentLabel.fontSize = 20;
        instructionContentLabel.fontColor = [SKColor grayColor];
        instructionContentLabel.position = CGPointMake(CGRectGetMidX(self.frame)-250, CGRectGetMidY(self.frame)+60);
        instructionLabel.text = @"Click on the center of the target when they appears.";
        [self addChild:instructionContentLabel];
        
        
        SKSpriteNode *backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(150, 40)];
        backButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                CGRectGetMidY(self.frame) + 250);

        backButton.name = @"backButton";
        [self addChild:backButton];
        
        SKLabelNode *backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        backButtonLabel.fontSize = 35;
        backButtonLabel.fontColor = [SKColor grayColor];
        backButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame)+255, CGRectGetMidY(self.frame)+250);
        backButtonLabel.text = @"Back";
        backButtonLabel.verticalAlignmentMode = 1;
        backButtonLabel.horizontalAlignmentMode = 2;
        [self addChild:backButtonLabel];
        
        
        
//        SKShapeNode *OptionButtion
        
    }
    return self;
}
@end
