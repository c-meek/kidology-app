//
//  TargetPracticeScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeScene.h"
#import "MainMenuScene.h"
@interface TargetPracticeScene()
@property (nonatomic) SKSpriteNode * target;
@property (nonatomic) int totalTouches;
@property (nonatomic) int correctTouches;
@end

@implementation TargetPracticeScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        [self displayTarget];
        [self addChild:self.target];
    }
    return self;
}

-(void)displayTarget
{
    self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.target.xScale = .42;
    self.target.yScale = .42;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
    //    for (UITouch *touch in touches)
    //    {
    //        CGPoint location = [touch locationInNode:self];
    //
    
    
    //        [sprite runAction:[SKAction repeatActionForever:action]];
    
    //        [self addChild:sprite];
    //    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    _totalTouches++;
    if([_target isEqual:touchedNode])
    {
        _correctTouches++;
        SKAction *deleteTarget = [SKAction runBlock:^{
            self.target.position = CGPointMake(-100,-100);
        }];
        SKAction *wait = [SKAction waitForDuration:3];
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];
        
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        //        [self runAction:[SKAction repeatAction:deleteTarget count:1]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
    }
    NSLog(@"Correct touches: %d | Total touches: %d", _correctTouches, _totalTouches);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

// ---- previous code from Chris ----------------------


//    -(id)initWithSize:(CGSize)size {
//        if (self = [super initWithSize:size]) {
//            /* Setup your scene here */
//            
//            self.backgroundColor = [SKColor blackColor];
//            
//            SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//            
//            myLabel.text = @"Hello, World!";
//            myLabel.fontSize = 30;
//            myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                           CGRectGetMidY(self.frame));
//            
//            [self addChild:myLabel];
//            
//        }
//        return self;
//    }
//
//    -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//        /* Called when a touch begins */
//        // Create and configure the scene.
//        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
//        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
//        
//        // Present the scene.
//        [self.view presentScene:mainMenu];
//    }
//
//    -(void)update:(CFTimeInterval)currentTime {
//        /* Called before each frame is rendered */
//    }



@end
