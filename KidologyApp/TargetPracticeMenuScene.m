//
//  TargetPracticeMenuScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeMenuScene.h"
#import "TargetPracticeScene.h"
#import "MainMenuScene.h"

@implementation TargetPracticeMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKLabelNode *instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        instructionLabel.fontSize = 40;
        instructionLabel.fontColor = [SKColor grayColor];
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+150);
        instructionLabel.text = @"Instructions:";
        [self addChild:instructionLabel];
        
        SKLabelNode *instructionContentLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        instructionContentLabel.fontSize = 20;
        instructionContentLabel.fontColor = [SKColor grayColor];
        instructionContentLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+110);
        instructionContentLabel.horizontalAlignmentMode = 1;
        instructionContentLabel.text = @"Click on the center of the target when they appears.";
        [self addChild:instructionContentLabel];
        
        
        _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _backButton.position = CGPointMake(self.frame.size.width - 55, self.frame.size.height/2+250);
        _backButton.name = @"backButton";
        [self addChild:_backButton];
        
        _backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _backButtonLabel.fontSize = 35;
        _backButtonLabel.fontColor = [SKColor whiteColor];
        _backButtonLabel.position = CGPointMake(self.frame.size.width - 62, self.frame.size.height/2 + 235);
        _backButtonLabel.name = @"backLabel";
        _backButtonLabel.text = @"Back";
        [self addChild:_backButtonLabel];
        
        SKLabelNode *selectModeLabel= [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        selectModeLabel.fontSize = 35;
        selectModeLabel.fontColor = [SKColor grayColor];
        selectModeLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 210);
        selectModeLabel.text = @"Select Your Game Mode:";
        [self addChild:selectModeLabel];
        
//READ ->     //adds target and touch animation?
        _target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        _target.position = (CGPointMake(self.frame.size.width/2-50, self.frame.size.height/2-22));
        _target.xScale = .4;
        _target.yScale = .4;
        [self addChild:_target];
        
        _centerModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _centerModeButton.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
        _centerModeButton.name = @"centerButton";
        [self addChild:_centerModeButton];
        
        _centerModeButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _centerModeButtonLabel.fontSize = 35;
        _centerModeButtonLabel.fontColor = [SKColor whiteColor];
        _centerModeButtonLabel.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
        _centerModeButtonLabel.name = @"centerLabel";
        _centerModeButtonLabel.text = @"Center";
        _centerModeButtonLabel.verticalAlignmentMode =1;
        [self addChild:_centerModeButtonLabel];
        
        _randomModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _randomModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
        _randomModeButton.name = @"randomButton";
        [self addChild:_randomModeButton];
        
        _randomModeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _randomModeButtonLabel.fontSize = 35;
        _randomModeButtonLabel.fontColor = [SKColor whiteColor];
        _randomModeButtonLabel.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
        _randomModeButtonLabel.name = @"randomLabel";
        _randomModeButtonLabel.text = @"Random";
        _randomModeButtonLabel.verticalAlignmentMode = 1;
        [self addChild:_randomModeButtonLabel];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
//    __weak typeof(self) weakSelf = self;
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backLabel"])
        {
            SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
            backToMain.scaleMode = SKSceneScaleModeAspectFill;
            
            [self.view presentScene:backToMain];
        }
    
    if ([node.name isEqualToString:@"targetPracticeButton"] ||
        [node.name isEqualToString:@"targetPracticeButtonLabel"])
    {
        // Create and configure the "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:targetPractice];
    }

}

@end
