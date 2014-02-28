//
//  BabyMenuScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "BabyMenuScene.h"
#import "BabyTargetPracticeScene.h"

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

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if (node.name.length != 0)
    {
  
        // Create and configure the "target practice" scene.
        SKScene * game = [[BabyTargetPracticeScene alloc] initWithSize:self.size color:node.name];
        game.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:game];
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
