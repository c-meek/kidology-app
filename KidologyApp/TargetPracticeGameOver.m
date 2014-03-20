//
//  TargetPracticeGameOver.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeGameOver.h"
#import "TargetPracticeScene.h"
#import "MainMenuScene.h"

@implementation TargetPracticeGameOver

-(id)initWithSize:(CGSize)size targets:(int)targets
{
    if (self = [super initWithSize:size])
    {
        [self addBackground];
        self.userData = [NSMutableDictionary dictionary];
        self.backgroundColor = [SKColor grayColor];
        NSString * messageText = [NSString stringWithFormat:@"Complete! You touched %d targets.", targets];
        SKLabelNode * message = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        message.text = messageText;
        message.fontSize = 30;
        message.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
        message.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:message];
        
        _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
        _backButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
        _backButton.name = @"backButton";
        [self addChild:_backButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"backButton"])
    {
        _backButton.color = [SKColor yellowColor];
    }
    NSMutableArray *log;
    SKScene *scene = [self.view scene];
    log = [scene.userData objectForKey:@"touchLog"];
    NSLog(@"This is where the XML conversion would happen:");
    for (id entry in log)
    {
        NSLog(@"%@", entry);
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"backButton"])
    {
        // Create and configure the "main menu" scene.
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:mainMenu];
    }
    else
    {
        _backButton.color = [SKColor redColor];
    }
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .7;
    [self addChild:bgImage];
}
@end
