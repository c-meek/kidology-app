//
//  BabyMenuScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "BabyMenuScene.h"
#import "BabyTargetPracticeScene.h"
#import "MainMenuScene.h"

@implementation BabyMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        float width = self.frame.size.width;
        float column = width / 5;
        float height = self.frame.size.height;
        float row1 = 2.5*(height/8);
        float row2 = 3.5*(height/8);
        float row3 = 4.5*(height/8);
        
        //add the buttons
        [self addButton:@"Orange" withPosition: CGPointMake(1*column, row1)];
        [self addButton:@"Pink" withPosition: CGPointMake(2*column, row1)];
        [self addButton:@"Purple" withPosition: CGPointMake(3*column, row1)];
        [self addButton:@"Red" withPosition: CGPointMake(4*column,row1)];
        [self addButton:@"White" withPosition: CGPointMake(1*column, row2)];
        [self addButton:@"Yellow" withPosition: CGPointMake(2*column, row2)];
        [self addButton:@"Blue" withPosition:CGPointMake(3*column, row2)];
        [self addButton:@"Brown" withPosition:CGPointMake(4*column, row2)];
        [self addButton:@"Cyan" withPosition: CGPointMake(1*column, row3)];
        [self addButton:@"Green" withPosition:CGPointMake(2*column, row3)];
        [self addButton:@"Lime" withPosition:CGPointMake(3*column, row3)];
        [self addButton:@"Magenta" withPosition:CGPointMake(4*column, row3)];
        
        //add the label
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        title.position = CGPointMake(width/2, 5.5*(height/8));
        title.text = @"Pick a color!";
        title.fontSize = 50;
        title.fontColor = [SKColor whiteColor];
        [self addChild:title];
        //add back button to main menu
        [self addBackButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if (!([_backButton isEqual:node] || [_backButtonLabel isEqual:node]) && node.name.length != 0)
    {
  
        // Create and configure the "target practice" scene.
        SKScene * game = [[BabyTargetPracticeScene alloc] initWithSize:self.size color:node.name];
        game.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:game];
    }
    else if([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonLabel"])
    {
        _backButton.color = [SKColor yellowColor];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInNode:self];
        SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:loc];
        //transition
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        if([_backButton isEqual:touchedNode] || [_backButtonLabel isEqual:touchedNode]) //go back to main menu
        {
            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:mainMenu transition:reveal];
        }
        else
        {
            _backButton.color = [SKColor redColor];
        }
    }
}

-(void)addButton:(NSString *)color withPosition:(CGPoint)pos
{
    // gameMenu game button
    SKSpriteNode *button = [[SKSpriteNode alloc] initWithImageNamed:color];
    button.position = pos;
    button.name = color;
    button.scale = 0.17;
    [self addChild:button];
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
    _backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _backButtonLabel.name = @"backButtonLabel";
    _backButtonLabel.text = labelText;
    _backButtonLabel.fontSize = 24;
    _backButtonLabel.position = CGPointMake(self.frame.size.width-55, self.frame.size.height/2 + 240);
    [self addChild:_backButtonLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
