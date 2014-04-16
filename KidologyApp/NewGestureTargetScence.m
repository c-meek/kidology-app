//
//  NewGestureTargetScence.m
//  KidologyApp
//
//  Created by ngo, tien dong on 4/15/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewGestureTargetScence.h"
#import "TargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "MainMenuScene.h"
#import "math.h"
#import "LogEntry.h"
#import "SetupViewController.h"

@implementation NewGestureTargetScence

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // initialize variables
        _numOfRotations = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        self.delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _affectedHand = [defaults objectForKey:@"affectedHand"];
        NSLog(@"total targets is %d", self.totalTargets);
        NSLog(@"delay between is %d", self.delayBetweenTargets);
        
//        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        self.correctTouches = 0;
        // initialize the anchor to "not being touched" state
        self.time = 0;
        
        // add images
        [self addBackground];
        
        // STUFF FOR GESTURES
        
        _gestureMoveDone =[SKAction removeFromParent];
        
        //And the rotation gesture will detect a two + finger rotation
        rotationGR = [[ UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
        panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        panGR.minimumNumberOfTouches = 1;
        
        int rand = arc4random_uniform(2);
        if (rand == 0)
        {
            NSLog(@"Rotation starting!(1)");
            _currentGesture = ROTATE;
        }
        else if (rand == 1)
        {
            NSLog(@"Panning starting!(1)");
            _currentGesture = DRAG;
        }
        [self displayTargets];
    }
    return self;
}

-(void)displayTargets
{
        int rand = arc4random_uniform(2);
        if (rand == 0)
        {
            NSLog(@"Rotation starting!");
            _currentGesture = ROTATE;
        }
        else if (rand == 1)
        {
            NSLog(@"Panning starting!");
            _currentGesture = DRAG;
        }
        
    
    
    NSLog(@"Target is being displayed");

    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
    _target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _target.xScale = .75;
    _target.yScale = .75;
    [self addChild:self.target];
    
    if (_currentGesture == ROTATE)
    {
        _target.hidden = true;
        self.rotateTarget = [SKSpriteNode spriteNodeWithImageNamed:@"rotate_green_target"];
        _rotateTarget.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _rotateTarget.xScale = .75;
        _rotateTarget.yScale = .75;
        [self addChild:self.rotateTarget];
    }
    
    if (_currentGesture == DRAG)
    {
        _target.hidden = true;
        _updatedTarget = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        _updatedTarget.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _updatedTarget.xScale = .25;
        _updatedTarget.yScale = .25;
        [self addChild: _updatedTarget];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched!");
 //   if (true)//_isGestureDone == true )
    {
        if (_currentGesture == ROTATE)
        {
            [self.view addGestureRecognizer:rotationGR];
        }
        else if (_currentGesture == DRAG)
        {
            [self.view.superview addGestureRecognizer:panGR];
        }
 //       [self displayTargets];
//        _isGestureDone = false;
    }
}

-(void) handlePanning: (UIPanGestureRecognizer *) recognizer
{
    NSLog(@"panning...");
    
    CGPoint changeInPosition = [recognizer translationInView:self.view];
    
    NSLog(@"MAX: %f x %f position: (%f , %f)",self.frame.size.width, self.frame.size.height, changeInPosition.x, changeInPosition.y);
//    CGPoint temp = [self.scene convertPoint:changeInPosition fromScene:nil];
    //convertPoint:(CGPoint)point fromScene:(SKScene *)scene
    CGPoint newPosition = CGPointMake(_target.position.x +(.9* changeInPosition.x),_target.position.y - (.9*changeInPosition.y));
        SKAction *moveAction = [SKAction moveTo:newPosition duration:.05];
    [_updatedTarget runAction:moveAction];
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        [self.view removeGestureRecognizer: panGR];
        [self displayTargets];
        _isGestureDone = true;
        [_updatedTarget runAction:_gestureMoveDone];
    }

}
-(void) handleRotation: (UIRotationGestureRecognizer *) recognizer
{
    NSLog(@"rotating...");
    NSUInteger num_of_touches = [recognizer numberOfTouches];

    bool allTouchedTarget =true;
    
    int x = 0;
    while (x < num_of_touches)
    {
        bool isTargetTouched = [self isTargetTouched:[recognizer locationOfTouch:x  inView:self.view]];
        if (isTargetTouched)
        {
            x++;
        }
        else
        {
            x++;
            allTouchedTarget = false;
        }
    }
    
    if (allTouchedTarget)
    {
        CGFloat rotation = recognizer.rotation;
        SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
        [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
        _hasRotated ++;
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        _numOfRotations ++;
        if (_hasRotated > 0)      // THIS IS WHEN THE ROTATION IS CORRECT! (that means they has successfully spun the target for a little bit...
        {
            [_rotateTarget runAction:_gestureMoveDone];
            NSLog(@"correct rotation!\n");
            _correctTouches++;
            // [self rightAction];
            [self.view removeGestureRecognizer:rotationGR ];
            _isGestureDone = true;
        }
        allTouchedTarget = true;
        NSLog(@"rotation has actually ended");
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        [self.view removeGestureRecognizer: rotationGR];
        [self displayTargets];
        _isGestureDone = true;
        [_rotateTarget runAction:_gestureMoveDone];
    }
}

-(bool)isTargetTouched:(CGPoint)touchLocation
{
    bool isInLocation = false;
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    if (leftHandSide <= rightHandSide) {
        isInLocation = true;
    }
    return isInLocation;
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .5;
    bgImage.yScale = .5;
    [self addChild:bgImage];
}

@end