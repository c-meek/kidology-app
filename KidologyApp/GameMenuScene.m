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
#import "BabyMenuScene.h"
#import "MainMenuScene.h"
#import "FetchScene.h"


@implementation GameMenuScene
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        //add background
        //add target practice button and label
        [self addPressedTargetButton];
        [self addTargetPracticeButton];
        //add fetch button and label
        [self addFetchButton];
        //add puzzle button and label
        [self addPuzzleButton];
        //add babygame button and label
        [self addBabyGameButton];
        //add backbutton
        [self addBackButton];
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
        _targetPracticeButton.hidden = TRUE;
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchButtonLabel"])
    {
        _fetchGameButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"puzzleGameButton"])
    {
        // Create and configure the "puzzle" scene.
        // Present the scene.
    }
    else if ([node.name isEqualToString:@"babyGameButton"] || [node.name isEqualToString:@"babyButtonLabel"])
    {
         _babyGameButton.color = [SKColor yellowColor];
    }
    else if([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonLabel"])

    {
        _backButton.color = [SKColor yellowColor];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //transition
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    // Check which button was pressed
    if ([node.name isEqualToString:@"targetPracticeButton"] ||
        [node.name isEqualToString:@"targetPracticeButtonLabel"])
    {
        SKScene * targetPracticeMenu = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetPracticeMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetPracticeMenu transition:reveal];
        
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchButtonLabel"])
    {
        // Create and configure the "fetch" scene.
        SKScene * fetch = [[FetchInstructionScene alloc] initWithSize:self.size];
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
        SKScene * baby = [[BabyMenuScene alloc] initWithSize:self.size];
        baby.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:baby transition:reveal];
    }
    else if([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonLabel"]) //go back to main menu
    {
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:mainMenu transition:reveal];
    }
    else
    {
        _fetchGameButton.color = [SKColor redColor];
        _targetPracticeButton.hidden = FALSE;
//        _puzzleGameButton.color = [SKColor redColor];
        _babyGameButton.color = [SKColor redColor];
        _backButton.color = [SKColor redColor];
    }
}

-(void)addPressedTargetButton
{
    // target practice button
    SKSpriteNode *targetPracticeButtonPressed = [SKSpriteNode spriteNodeWithImageNamed:@"target_menu_pressed"];
    targetPracticeButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame),
                                                 CGRectGetMidY(self.frame) + 150);
    targetPracticeButtonPressed.name = @"targetPracticeButtonPressed";
    targetPracticeButtonPressed.xScale = .3;
    targetPracticeButtonPressed.yScale = .3;
    [self addChild:targetPracticeButtonPressed];
}

-(void)addTargetPracticeButton
{
    // target practice button
    _targetPracticeButton = [SKSpriteNode spriteNodeWithImageNamed:@"target_menu"];
    _targetPracticeButton.position = CGPointMake(CGRectGetMidX(self.frame),
                                                CGRectGetMidY(self.frame) + 150);
    _targetPracticeButton.name = @"targetPracticeButton";
    _targetPracticeButton.xScale = .3;
    _targetPracticeButton.yScale = .3;
    [self addChild:_targetPracticeButton];
}

-(void)addFetchButton
{
    // fetch game button
    _fetchGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    _fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 200);
    _fetchGameButton.name = @"fetchGameButton";
    NSString * fetchLabel = [NSString stringWithFormat:@"Fetch Game"];
    SKLabelNode *fetchButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    fetchButtonLabel.name = @"fetchButtonLabel";
    fetchButtonLabel.text = fetchLabel;
    fetchButtonLabel.fontSize = 24;
    fetchButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-210);
    [self addChild:_fetchGameButton];
    [self addChild:fetchButtonLabel];
}


-(void)addPuzzleButton
{
    // puzzle game button
    _puzzleGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(200, 40)];
    _puzzleGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,CGRectGetMidY(self.frame) - 250);
    _puzzleGameButton.name = @"puzzleGameButton";
    NSString *puzzleLabel = [NSString stringWithFormat:@"Puzzle Game"];
    SKLabelNode *puzzleButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    puzzleButtonLabel.name = @"puzzleButtonLabel";
    puzzleButtonLabel.text = puzzleLabel;
    puzzleButtonLabel.fontSize = 24;
    puzzleButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame) - 260);
    [self addChild:_puzzleGameButton];
    [self addChild:puzzleButtonLabel];
}

-(void)addBabyGameButton
{
    // baby game button
    _babyGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    _babyGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 100);
    _babyGameButton.name = @"babyGameButton";
    NSString * babyLabel = [NSString stringWithFormat:@"Baby Game"];
    SKLabelNode *babyButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    babyButtonLabel.name = @"babyButtonLabel";
    babyButtonLabel.text = babyLabel;
    babyButtonLabel.fontSize = 24;
    babyButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-108);
    [self addChild:_babyGameButton];
    [self addChild:babyButtonLabel];
}
-(void)addBackButton
{
    //add button with attributes
    _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(100, 40)];
    _backButton.position = CGPointMake(self.frame.size.width - 55, self.frame.size.height/2+250);
    _backButton.name = @"backButton";
    [self addChild:_backButton];
    //add label with attributes
    NSString * labelText = [NSString stringWithFormat:@"Back"];
    SKLabelNode *backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backButtonLabel.name = @"backButtonLabel";
    backButtonLabel.text = labelText;
    backButtonLabel.fontSize = 24;
    backButtonLabel.position = CGPointMake(self.frame.size.width-55, self.frame.size.height/2 + 240);
    [self addChild:backButtonLabel];
}
@end
