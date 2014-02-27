//
//  GameMenuScene.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "GameMenuScene.h"
#import "FetchInstructionScene.h"
#import "TargetPracticeMenuScene.h"
#import "BabyTargetPracticeScene.h"

@implementation GameMenuScene
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        //add background
        //add target practice button and label
        [self addTargetPracticeButton];
        //add fetch button and label
        [self addFetchButton];
        //add puzzle button and label
        [self addPuzzleButton];
        //add babygame button and label
        [self addBabyGameButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"targetPracticeButton"] ||
        [node.name isEqualToString:@"targetPracticeButtonLabel"])
    {
        SKScene * targetPracticeMenu = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetPracticeMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetPracticeMenu];
        
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchButtonLabel"])
    {
        // Create and configure the "fetch" scene.
        SKScene * fetch = [[FetchInstructionScene alloc] initWithSize:self.size];
        //transition
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        fetch.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:fetch transition:reveal];
    }
    else if ([node.name isEqualToString:@"puzzleGameButton"])
    {
        // Create and configure the "puzzle" scene.
        // Present the scene.
    }
    else if ([node.name isEqualToString:@"babyGameButton"] || [node.name isEqualToString:@"babyButtonLabel"])
    {
        // Create and configure the "fetch" scene.
        SKScene * baby = [[BabyTargetPracticeScene alloc] initWithSize:self.size];
        //transition
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        baby.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:baby transition:reveal];
    }
}

-(void)addTargetPracticeButton
{
    // target practice button
    SKSpriteNode *targetPracticeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    targetPracticeButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                CGRectGetMidY(self.frame) - 150);
    targetPracticeButton.name = @"targetPracticeButton";
    [self addChild:targetPracticeButton];
    
    NSString * labelText = [NSString stringWithFormat:@"Target Game"];
    SKLabelNode *targetPracticeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    targetPracticeButtonLabel.name = @"targetPracticeButtonLabel";
    targetPracticeButtonLabel.text = labelText;
    targetPracticeButtonLabel.fontSize = 24;
    targetPracticeButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                     CGRectGetMidY(self.frame) - 158);
    [self addChild:targetPracticeButtonLabel];
}

-(void)addFetchButton
{
    // fetch game button
    SKSpriteNode *fetchGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 200);
    fetchGameButton.name = @"fetchGameButton";
    NSString * fetchLabel = [NSString stringWithFormat:@"Fetch Game"];
    SKLabelNode *fetchButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    fetchButtonLabel.name = @"fetchButtonLabel";
    fetchButtonLabel.text = fetchLabel;
    fetchButtonLabel.fontSize = 24;
    fetchButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-210);
    [self addChild:fetchGameButton];
    [self addChild:fetchButtonLabel];
}

-(void)addPuzzleButton
{
    // puzzle game button
    SKSpriteNode *puzzleGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(200, 40)];
    puzzleGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,CGRectGetMidY(self.frame) - 250);
    puzzleGameButton.name = @"puzzleGameButton";
    NSString *puzzleLabel = [NSString stringWithFormat:@"Puzzle Game"];
    SKLabelNode *puzzleButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    puzzleButtonLabel.name = @"puzzleButtonLabel";
    puzzleButtonLabel.text = puzzleLabel;
    puzzleButtonLabel.fontSize = 24;
    puzzleButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame) - 260);
    [self addChild:puzzleGameButton];
    [self addChild:puzzleButtonLabel];
}

-(void)addBabyGameButton
{
    // baby game button
    SKSpriteNode *babyGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    babyGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 100);
    babyGameButton.name = @"babyGameButton";
    NSString * babyLabel = [NSString stringWithFormat:@"Baby Game"];
    SKLabelNode *babyButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    babyButtonLabel.name = @"babyButtonLabel";
    babyButtonLabel.text = babyLabel;
    babyButtonLabel.fontSize = 24;
    babyButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-108);
    [self addChild:babyGameButton];
    [self addChild:babyButtonLabel];
}
@end
