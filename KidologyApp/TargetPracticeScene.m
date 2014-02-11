//
//  TargetPracticeScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "MainMenuScene.h"
#import "math.h"


@implementation TargetPracticeScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //initialize target
        self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        //set the total number of targets for this session
        self.totalTargets = 3;
        //set properties of target
        [self displayTarget];
        //add target to screen
        [self addChild:self.target];
    }
    return self;
}

-(void)displayTarget
{

    //set target to middle of screen
    self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.target.xScale = .67;
    self.target.yScale = .67;
    NSLog(@"x is %f", self.target.position.x);
    NSLog(@"y is %f", self.target.position.y);



}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    //test whether the target has been touched
    [self targetTouch:positionInScene];
    //    for (UITouch *touch in touches)
    //    {
    //        CGPoint location = [touch locationInNode:self];
    //
    
    
    //        [sprite runAction:[SKAction repeatActionForever:action]];
    
    //        [self addChild:sprite];
    //    }
}

-(void)targetTouch:(CGPoint)touchLocation
{
    _totalTouches++;
//    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    if(leftHandSide <= rightHandSide)
    {
        _correctTouches++;
        //make a "delete" target action
        SKAction *deleteTarget = [SKAction runBlock:^{
            self.target.position = CGPointMake(-100,-100);
        }];
        //make a wait action
        SKAction *wait = [SKAction waitForDuration:3];
        //make a "add" target action
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];
        //check to see if the total number of targets have been touched, then show the ending screen
        if(self.totalTargets <= self.correctTouches)
        {
            //SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size];
            gameOverScene.userData = [ NSMutableDictionary dictionary];
            //NSString * totalTargetsString = [NSString stringWithFormat:@"%d", self.totalTargets];
            //[gameOverScene.userData setObject:totalTargetsString forKey:@"numberTouched"];
            [self.view presentScene:gameOverScene];
        }
        //combine all the actions into a sequence
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        //run the actions in sequential order
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
