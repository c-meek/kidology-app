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
#import "UtilityClass.h"

@implementation BabyMenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {        
        [self addBackground];
        _enableSound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"] boolValue];

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
        [self addLabel];

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
    if (!([_backButton isEqual:node] || [_pressedBackButton isEqual:node]) && node.name.length != 0)
    {
        // Create and configure the "target practice" scene.
        SKScene *game = [[BabyTargetPracticeScene alloc] initWithSize:self.size color:node.name];
        game.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:game transition:reveal];
    }
    else if([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"pressedBackButton"])
    {
        _backButton.hidden = true;
        _pressedBackButton.hidden = false;
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
        if([_backButton isEqual:touchedNode] || [_pressedBackButton isEqual:touchedNode])
        {
            // reset button
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
            
            // check required settings fields
            if ([UtilityClass checkSettings])
                return;
            
            //go back to main menu
            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
            
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            [self.view presentScene:mainMenu transition:reveal];
        }
        else
        {
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
        }
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

-(void)addLabel
{
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    title.position = CGPointMake(self.frame.size.width/2, 5.25*(self.frame.size.height/8));
    title.text = @"Pick a color!";
    title.fontSize = 50;
    title.fontColor = [SKColor whiteColor];
    [self addChild:title];
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
