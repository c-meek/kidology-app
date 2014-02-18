//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "TargetPracticeScene.h"
#import "FetchScene.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        // Hacky arrangement to get menu to look *kind of* how it will eventually look
        // In final project, will be single photoshop image with empty label or sprite node's
        // in same position as photoshop elements
        
        SKSpriteNode *blueSky = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:(0) green:195 blue:255 alpha:1] size:CGSizeMake(2000, 2000)];
        [self addChild:blueSky];
        
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:CGSizeMake(self.frame.size.width, self.frame.size.height - 50)];
        background.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame));
        [self addChild:background];

        
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
        
        // puzzle game button
        SKSpriteNode *puzzleGameButton = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(200, 40)];
        puzzleGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                    CGRectGetMidY(self.frame) - 250);
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
    if ([node.name isEqualToString:@"targetPracticeButton"] ||
        [node.name isEqualToString:@"targetPracticeButtonLabel"])
    {
        // Create and configure the "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetPractice];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
              [node.name isEqualToString:@"fetchButtonLabel"])
    {
        // Create and configure the "fetch" scene.
        SKScene * fetch = [[FetchScene alloc] initWithSize:self.size];
        fetch.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:fetch];
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
