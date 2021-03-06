//
//  BabyMenuScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this scene displays the menu of colors to choose from for the baby target game

#import "BabyMenuScene.h"
#import "BabyTargetPracticeScene.h"
#import "MainMenuScene.h"
#import "UtilityClass.h"

@implementation BabyMenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        // get whether or not to play sounds
        [self addBackground];
        _enableSound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"] boolValue];

        // set up the rows and columns for the color palette grid
        float width = self.frame.size.width;
        float column = width / 5;
        float height = self.frame.size.height;
        float row1 = 1*(height/8) + 25;
        float row2 = 3*(height/8) + 25;
        float row3 = 5*(height/8) + 25;
        
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // get the touch
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check which button was pressed (if any)
    if (!([_backButton isEqual:node] ||
          [_pressedBackButton isEqual:node]) &&
        node.name.length != 0)
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

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        // get the touch location and see if it was on the back button (only button in scene)
        CGPoint loc = [touch locationInNode:self];
        SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:loc];
        if([_backButton isEqual:touchedNode] ||
           [_pressedBackButton isEqual:touchedNode])
        {
            // reset button
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
            
            // check required settings fields
            if ([UtilityClass checkSettings])
                return;
            
            // create and configure the fetch game menu scene
            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
            
            // play a transition sound
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            
            // present the scene
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:mainMenu transition:reveal];
        }
        else
        {
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
        }
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        // get the location of the current and previous touch
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        
        // see which nodes (if any) were at those points
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
            // touch was on the back button but moved off
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

// adds a color button to the screen (called for each color)
-(void)addButton:(NSString *)color withPosition:(CGPoint)pos
{
    // gameMenu game button
    SKSpriteNode *button = [[SKSpriteNode alloc] initWithImageNamed:color];
    button.position = pos;
    button.name = color;
    button.scale = 0.25;
    [self addChild:button];
}

// add the back button to the top left corner
-(void)addBackButton
{
    // unpressed back button
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(100, self.frame.size.height-65);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    // pressed back button
    _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _pressedBackButton.position = CGPointMake(100, self.frame.size.height-65);
    _pressedBackButton.name = @"backButton";
    _pressedBackButton.hidden = true;
    _pressedBackButton.xScale = .5;
    _pressedBackButton.yScale = .5;
    [self addChild:_pressedBackButton];
}

// add an intstruction label
-(void)addLabel
{
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    title.position = CGPointMake(self.frame.size.width/2, 7*(self.frame.size.height/8));
    title.text = @"Pick a color!";
    title.fontSize = 50;
    title.fontColor = [SKColor whiteColor];
    [self addChild:title];
}

// add the background image
-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .5;
    bgImage.yScale = .5;
    [self addChild:bgImage];
}

@end
