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
        [self addBackground];
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
        // reset button
        _pressedBackButton.hidden = true;
        _backButton.hidden = false;
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:mainMenu transition:reveal];
        [_textField removeFromSuperview];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch moves/slides */
    for (UITouch *touch in [touches allObjects]) {
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        SKSpriteNode * currentNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
        SKSpriteNode * previousNode = (SKSpriteNode *)[self nodeAtPoint:previousLocation];
        
        // If a touch was off the back button but has moved onto it
        if (!([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
            ([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
        {
            _pressedBackButton.hidden = false;
            _backButton.hidden = true;
        }
        else if (([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
                 !([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
        {
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
        }
    }
}

-(void)updateSettingsInfo
{
    //get user's first and last name and therapist's email address from the app settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"3" forKey:@"numberOfTargets"];
    [defaults synchronize];
    NSLog(@"updating settings");
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(void)addBackButton
{
    //Back Button!
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    //Pressed Back Button!
    _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _pressedBackButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _pressedBackButton.name = @"backButton";
    _pressedBackButton.hidden = true;
    _pressedBackButton.xScale = .5;
    _pressedBackButton.yScale = .5;
    [self addChild:_pressedBackButton];
}

-(void)didMoveToView:(SKView *)view
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2, self.size.height/2+20, 200, 40)];
    _textField.center = self.view.center;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:17.0];
    _textField.placeholder = @"Enter your name here";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.autocorrectionType = UITextAutocorrectionTypeYes;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //textField.delegate = self.delegate;
    [self.view addSubview:_textField];
}

@end
