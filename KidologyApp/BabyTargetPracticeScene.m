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
        [self addBackButton];
        
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
    for(UITouch *touch in [touches allObjects])
    {
        CGPoint position = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:position];
        [self targetTouch:position];
        if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonPressed"])
        {
            _backButton.hidden = true;
            _backButtonPressed.hidden = false;
        }

    }
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
        SKAction *wait = [SKAction waitForDuration:3];
        //make a "add" target action
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];

        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        _totalTouches++;
        
//        if (_totalTouches > 5) {
//            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
//            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
//            
//            // Present the scene.
//            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
//            [self.view presentScene:mainMenu transition:reveal];
//        }
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
        if (!([_backButton isEqual:previousNode] || [_backButtonPressed isEqual:previousNode]) &&
            ([_backButton isEqual:currentNode] || [_backButtonPressed isEqual:currentNode]))
        {
            _backButtonPressed.hidden = false;
            _backButton.hidden = true;
        }
        else if (([_backButton isEqual:previousNode] || [_backButtonPressed isEqual:previousNode]) &&
                 !([_backButton isEqual:currentNode] || [_backButtonPressed isEqual:currentNode]))
        {
            _backButtonPressed.hidden = true;
            _backButton.hidden = false;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonPressed"])
    {
        SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
        backToMain.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:backToMain transition:reveal];
    }
}

-(void)addBackButton
{
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    _backButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _backButtonPressed.position = CGPointMake(100, self.frame.size.height/2+235);
    _backButtonPressed.name = @"backButtonPressed";
    _backButtonPressed.hidden = true;
    _backButtonPressed.xScale = .5;
    _backButtonPressed.yScale = .5;
    [self addChild:_backButtonPressed];
}

@end
