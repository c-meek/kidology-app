//
//  BabyTargetPracticeScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "BabyTargetPracticeScene.h"
#import "MainMenuScene.h"

@implementation BabyTargetPracticeScene

-(id)initWithSize:(CGSize)size color:(NSString *)color
{
if (self = [super initWithSize:size])
    {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Huge_Checkered_Background_[4096x3072]"];
        [self addChild:bgImage];
        
        _target = [SKSpriteNode spriteNodeWithImageNamed:color];
        _target.xScale = .70;
        _target.yScale = .70;
        _target.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_target];
        
    }
    return self;
}

-(void)displayTarget
{
    self.target.position = CGPointMake(self.size.width/2, self.size.height/2);
}

-(void)hideTarget
{
    self.target.position = CGPointMake(self.size.width/2*(-1), self.size.height/2*(-1));
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    [self targetTouch:position];
}

-(void)targetTouch:(CGPoint)touchLocation
{
    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2*.8385; //<--- The percentage of the radius that is the circle
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    if(leftHandSide <= rightHandSide) // If the touch is on the target
    {
        SKAction *deleteTarget = [SKAction runBlock:^{
            [self hideTarget];
        }];
        //make a wait action
        SKAction *wait = [SKAction waitForDuration:1];
        //make a "add" target action
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];

        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        _totalTouches++;
        
        if (_totalTouches > 5) {
            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:mainMenu transition:reveal];
        }
    }
}

@end
