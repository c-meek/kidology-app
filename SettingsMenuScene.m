//
//  SettingsMenuScene.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/11/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "SettingsMenuScene.h"
#import "MainMenuScene.h"

@implementation SettingsMenuScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
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
    // if one of the buttons is pressed, change its color
    if ([node.name isEqualToString:@"backButton"] ||
        [node.name isEqualToString:@"pressedBackButton"])
    {
        _backButton.hidden = true;
        _pressedBackButton.hidden = false;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"backButton"] ||
             [node.name isEqualToString:@"backButtonLabel"])
    {
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
//        [_textField removeFromSuperview];
        [self.view presentScene:mainMenu transition:reveal];
    }
    else
    {
        _pressedBackButton.hidden = true;
        _backButton.hidden = false;
    }
}


-(void)addBackButton
{
    //Back Button!
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    //Pressed Back Button!
    _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _pressedBackButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
    _pressedBackButton.name = @"backButton";
    _pressedBackButton.hidden = true;
    _pressedBackButton.xScale = .5;
    _pressedBackButton.yScale = .5;
    [self addChild:_pressedBackButton];
}

@end
