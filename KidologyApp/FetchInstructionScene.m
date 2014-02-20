//
//  fetchInstructionScene.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "FetchInstructionScene.h"
#import "FetchScene.h"

@implementation FetchInstructionScene
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.2 green:.6 blue:0.0 alpha:1.0];
        //add the two lines of instructions
        [self addInstructionLabel];
        //add the game 'play' button
        [self addGameButton];
    }
    return self;
}

-(void)addInstructionLabel
{
    //line 1
    NSString * text1 = [NSString stringWithFormat:@"Play fetch with the dog!"];
    SKLabelNode * instructionLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel1.name = @"instructionLabel1";
    instructionLabel1.text = text1;
    instructionLabel1.fontSize = 36;
    instructionLabel1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+100);
    
    //line 2
    NSString * text2 = [NSString stringWithFormat:@"Touch the ball to throw it."];
    SKLabelNode * instructionLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel2.name = @"instructionLabel2";
    instructionLabel2.text = text2;
    instructionLabel2.fontSize = 36;
    instructionLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    [self addChild:instructionLabel1];
    [self addChild:instructionLabel2];
}

-(void)addGameButton
{
    //button
    _playButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(100, 40)];
    _playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-100);
    _playButton.name = @"playButton";
    [self addChild:_playButton];
    
    //label
    NSString * text = [NSString stringWithFormat:@"Play"];
    _playLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    _playLabel.name = @"playLabel";
    _playLabel.text = text;
    _playLabel.fontSize = 27;
    _playLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-110);
    [self addChild:_playLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        CGPoint loc = [touch locationInNode:self];
        SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:loc];
        if([_playButton isEqual:touchedNode] || [_playLabel isEqual:touchedNode]) //if play button is pressed, show the fetch game
        {
            SKScene * fetchScene = [[FetchScene alloc] initWithSize:self.size];
            fetchScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:fetchScene];
        }
    }
}
@end
