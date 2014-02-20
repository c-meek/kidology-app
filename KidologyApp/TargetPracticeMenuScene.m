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
        instructionLabel.fontColor = [SKColor blackColor];
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)+100);
        instructionLabel.text = @"Instructions:";
        [self addChild:instructionLabel];
        
        
        
        
//        SKShapeNode *OptionButtion
        
    }
    return self;
}
@end
