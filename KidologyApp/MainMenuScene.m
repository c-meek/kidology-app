//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameMenuScene.h"
#import "TherapistMenuScene.h"


@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        // Hacky arrangement to get menu to look *kind of* how it will eventually look
        // In final project, will be single photoshop image with empty label or sprite node's
        // in same position as photoshop elements
        
//        SKSpriteNode *blueSky = [[SKSpriteNode alloc] initWithColor:[SKColor colorWithRed:(0) green:195 blue:255 alpha:1] size:CGSizeMake(2000, 2000)];
//        [self addChild:blueSky];
//        
//        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background"];
//        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:CGSizeMake(self.frame.size.width, self.frame.size.height - 50)];
//        background.position = CGPointMake(CGRectGetMidX(self.frame),
//                                          CGRectGetMidY(self.frame));
//        [self addChild:background];
        //add background
        [self addBackground];
        //add game menu button
        [self addMenuButton];
        //add therapist button
        [self addTherapistButton];
        
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
    if ([node.name isEqualToString:@"gameMenuButton"] ||
        [node.name isEqualToString:@"gameMenuLabel"])
    {
        _gameMenuButton.color = [SKColor yellowColor];
    }
    else if([node.name isEqualToString:@"therapistMenuButton"] ||
            [node.name isEqualToString:@"therapistMenuLabel"])
    {
        _therapistMenuButton.color = [SKColor yellowColor];
        NSLog(@"set therapist button color");
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"gameMenuButton"] ||
        [node.name isEqualToString:@"gameMenuLabel"])
    {
        // Create and configure the "game menu" scene.
        SKScene * gameMenu = [[GameMenuScene alloc] initWithSize:self.size];
        gameMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        NSLog(@"presenting game menu scene");
        
        // Present the scene.
        [self.view presentScene:gameMenu];
    }
    else if([node.name isEqualToString:@"therapistMenuButton"] ||
            [node.name isEqualToString:@"therapistMenuLabel"])
    {
        NSLog(@"creating therapist menu scene...");
        // Create and configure the "therapist" scene.
        SKScene * therapistMenu = [[TherapistMenuScene alloc] initWithSize:self.size];
        therapistMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        NSLog(@"presenting therapist menu scene");

        
        // Present the scene.
        [self.view presentScene:therapistMenu];
    }
//    else
//    {
//        _gameMenuButton.color = [SKColor redColor];
//    }

}

-(void)addMenuButton
{
    // gameMenu game button
    _gameMenuButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    _gameMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 150);
    _gameMenuButton.name = @"gameMenuButton";
    NSString * gameMenuLabelText = [NSString stringWithFormat:@"Game Menu"];
    SKLabelNode *gameMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameMenuLabel.name = @"gameMenuLabel";
    gameMenuLabel.text = gameMenuLabelText;
    gameMenuLabel.fontSize = 24;
    gameMenuLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-158);
    [self addChild:_gameMenuButton];
    [self addChild:gameMenuLabel];
}

-(void)addTherapistButton
{
    // therapist button
    _therapistMenuButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    _therapistMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                           CGRectGetMidY(self.frame) - 200);
    _therapistMenuButton.name = @"therapistMenuButton";
    NSString * therapistLabelText = [NSString stringWithFormat:@"Therapist"];
    SKLabelNode *therapistMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    therapistMenuLabel.name = @"therapistMenuLabel";
    therapistMenuLabel.text = therapistLabelText;
    therapistMenuLabel.fontSize = 24;
    therapistMenuLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-210);
    [self addChild:_therapistMenuButton];
    [self addChild:therapistMenuLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
}

@end
