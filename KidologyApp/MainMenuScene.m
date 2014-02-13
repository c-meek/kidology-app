//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "TargetPracticeScene.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // target practice button
        SKSpriteNode *targetPracticeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
        targetPracticeButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
        targetPracticeButton.name = @"targetPracticeButton";
        
        [self addChild:targetPracticeButton];
        // fetch game button
        SKSpriteNode *fetchGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(200, 40)];
        fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        fetchGameButton.name = @"fetchGameButton";
        
        [self addChild:fetchGameButton];
        // puzzle game button
        SKSpriteNode *puzzleGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(200, 40)];
        puzzleGameButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
        puzzleGameButton.name = @"puzzleGameButton";
        
        [self addChild:puzzleGameButton];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"targetPracticeButton"])
    {
        // Create and configure the "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetPractice];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"])
    {
        // Create and configure the "fetch" scene.
        // Present the scene.
    }
    else if ([node.name isEqualToString:@"puzzleGameButton"])
    {
        // Create and configure the "puzzle" scene.
        // Present the scene.
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
