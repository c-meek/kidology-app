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
#import "UtilityClass.h"

@implementation NewGestureTargetScence

NSMutableArray *touchLog;

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // initialize variables
        _numOfRotations = 0;
        self.correctTouches = 0;
        self.time = 0;
        // get user preferences from settings app
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        self.delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _affectedHand = [defaults objectForKey:@"affectedHand"];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        touchLog = [[NSMutableArray alloc] init];
        
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];
        
        // add images
        [self addBackground];
        [self addQuitButton];
        
        // STUFF FOR GESTURES
        [self setupTabTouchScreenLabel];
        _gestureMoveDone =[SKAction removeFromParent];
        
        //The rotation gesture will detect a two + finger rotation
        rotationGR = [[ UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
        //The pan gesture will detech  1+ finger pan
        panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        panGR.minimumNumberOfTouches = 1;
        //The zoom gesture will support 2 finger pinches
        pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        
//        int rand = arc4random_uniform(3);
//        if (rand == 0)
//        {
//            NSLog(@"Rotation starting!(1)");
//            _currentGesture = ROTATE;
//            int tempCounterForRotation = arc4random_uniform(2);
//            if (tempCounterForRotation == 0)
//            {
//                _gestureDirection = COUNTER_CLOCKWISE;
//            }
//            else
//            {
//                _gestureDirection = CLOCKWISE;
//            }
//        }
//        else if (rand == 1)
//        {
//            NSLog(@"Panning starting!(1)");
//            _currentGesture = DRAG;
//        }
//        else if (rand == 2)
//        {
//            _currentGesture = ZOOM;
//            int tempCounterForZoom = arc4random_uniform(2);
//            if (tempCounterForZoom == 0)
//            {
//                _gestureDirection = IN;
//            }
//            else
//            {
//                _gestureDirection = OUT;
//            }
//        }
        
        _isGestureDone = true;
        [self displayTargets];
    }
    return self;
}

-(void)displayTargets
{
    int rand = arc4random_uniform(3);
    if (rand == 0)
    {
        NSLog(@"Rotation starting!");
        _currentGesture = ROTATE;
        int tempCounterForRotation = arc4random_uniform(2);
        if (tempCounterForRotation == 0)
        {
            _gestureDirection = COUNTER_CLOCKWISE;
        }
        else
        {
            _gestureDirection = CLOCKWISE;
        }
    }
    else if (rand == 1)
    {
        NSLog(@"Panning starting!");
        _currentGesture = DRAG;
    }
    else if (rand == 2)
    {
        _currentGesture = ZOOM;
        int tempCounterForZoom = arc4random_uniform(2);
        if (tempCounterForZoom == 0)
        {
            _gestureDirection = IN;
        }
        else
        {
            _gestureDirection = OUT;
        }
    }

    
    NSLog(@"Target is being displayed");
    
    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
    _target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _target.xScale = .75;
    _target.yScale = .75;
//    SKAction * showTarget = [SKAction runBlock:^{ [self addChild:self.target]; }];
//
//    [self runAction:[SKAction sequence:@[wait, showTarget]]];
    [self addChild:_target];
    
    if (_currentGesture == ROTATE)
    {
         _hasRotated = 0;
        _target.hidden = true;
        _target.xScale = .75;
        _target.yScale = .75;
        if (_gestureDirection == COUNTER_CLOCKWISE)
        {
            self.rotateTarget = [SKSpriteNode spriteNodeWithImageNamed:@"rotate_green_target_counterclockwise"];
        }
        else
        {
            self.rotateTarget = [SKSpriteNode spriteNodeWithImageNamed:@"rotate_green_target_clockwise"];
        }
        _rotateTarget.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _rotateTarget.xScale = .75;
        _rotateTarget.yScale = .75;
        [self addChild: _rotateTarget];
    }
    
    if (_currentGesture == DRAG)
    {
        _hasStartedInCenter = 0;
        _target.hidden = true;
        _updatedTarget = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        _updatedTarget.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _updatedTarget.xScale = .25;
        _updatedTarget.yScale = .25;
        
        _dragTarget = [SKSpriteNode spriteNodeWithImageNamed:@"dragTarget"];
        _dragTarget.xScale = .4;
        _dragTarget.yScale = .4;
        int x_pos = (.4 * (arc4random_uniform((int)self.frame.size.width)/2)) + _dragTarget.size.width/2 + 15;
        int pos_neg = arc4random_uniform(2);
        if (pos_neg == 0)
        {
            x_pos = self.frame.size.width/2 + x_pos;
        }
        else
        {
            x_pos = self.frame.size.width/2 - x_pos;
        }
        int y_pos = (.4 * (arc4random_uniform((int)self.frame.size.height)/2)) +_dragTarget.size.height/2 + 15;
        pos_neg = arc4random_uniform(2);
        if (pos_neg == 0)
        {
            y_pos = self.frame.size.height/2 + y_pos;
        }
        else
        {
            y_pos = self.frame.size.height/2 - y_pos;
        }
        _dragTarget.position = CGPointMake(x_pos, y_pos);
        [self addChild: _dragTarget];
        [self addChild: _updatedTarget];
    }
    
    if (_currentGesture == ZOOM)
    {
        if(_gestureDirection == OUT)
        {
            _zoomTarget = [SKSpriteNode spriteNodeWithImageNamed:@"green_target_w_outward_arrows"];
        }
        else if ( _gestureDirection == IN)
        {
            _zoomTarget = [SKSpriteNode spriteNodeWithImageNamed:@"green_target_w_inward_arrows"];
        }
        
        _hasStartedInCenter = 0;
        _zoomTarget.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        _target.hidden = true;
        _target.xScale = .65;
        _target.yScale = .65;
        _zoomTarget.xScale = .65;
        _zoomTarget.yScale = .65;
        _outline = [SKSpriteNode spriteNodeWithImageNamed:@"outline"];
        _outline.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _outline.xScale = .65;
        _outline.yScale = .65;
        [self addChild:_zoomTarget];
        [self addChild:_outline];
    }
    
    if(_correctTouches < 0)
    {
        _isGestureDone = false;
    }
    [self setupTabTouchScreenLabel];
    [self addChild:_tapScreenLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched!");
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"quitButton"] ||
        [node.name isEqualToString:@"quitButtonPressed"])
    {
        _quitButton.hidden = true;
        _quitButtonPressed.hidden = false;
    }
    else if (_isGestureDone == true)
    {
        [_tapScreenLabel runAction:_gestureMoveDone];

        if (_currentGesture == ROTATE)
        {
            [self.view addGestureRecognizer:rotationGR];
        }
        else if (_currentGesture == DRAG)
        {
            [self.view addGestureRecognizer:panGR];
        }
        else if (_currentGesture == ZOOM)
        {
            [self.view addGestureRecognizer:pinchGR];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        
        SKNode *node = [self nodeAtPoint:positionInScene];
        if ([node.name isEqualToString:@"quitButton"] ||
            [node.name isEqualToString:@"quitButtonPressed"])
        {
            _quitButton.hidden = false;
            _quitButtonPressed.hidden = true;
            [self endGame:self.correctTouches totalTargets:self.totalTargets];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch moves/slides */
    for (UITouch *touch in [touches allObjects]) {
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        SKNode *currentNode = [self nodeAtPoint:currentLocation];
        SKNode *previousNode = [self nodeAtPoint:previousLocation];
        
        // If a touch was off the back button but has moved onto it
        if (!([_quitButton isEqual:previousNode] || [_quitButtonPressed isEqual:previousNode]) &&
            ([_quitButton isEqual:currentNode] || [_quitButtonPressed isEqual:currentNode]))
        {
            _quitButtonPressed.hidden = false;
            _quitButton.hidden = true;
        }
        else if (([_quitButton isEqual:previousNode] || [_quitButtonPressed isEqual:previousNode]) &&
                 !([_quitButton isEqual:currentNode] || [_quitButtonPressed isEqual:currentNode]))
        {
            // touch was on quit button but moved off
            _quitButtonPressed.hidden = true;
            _quitButton.hidden = false;
        }
    }
}


-(void) handlePinch: (UIPinchGestureRecognizer *) recognizer
{
    _isGestureDone = false;
    NSLog(@"Zooming...");
    
    NSUInteger numOfTouches = [recognizer numberOfTouches];
    int x = 0; // <-just a counter!
    while ( x < numOfTouches && _hasStartedInCenter == 0)
    {
        bool hasTouched = [self isTargetTouched:[recognizer locationOfTouch:x inView:self.view]];
        if (hasTouched)
        {
            _hasStartedInCenter++;
        }
        x++;
    }
    
    if(_hasStartedInCenter > 0)
    {
        CGFloat rawChangeInScale = [recognizer scale];
        _zoomTarget.xScale = rawChangeInScale;
        _zoomTarget.yScale = rawChangeInScale;
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        if (_gestureDirection == IN)
        {
            if (_zoomTarget.xScale < _target.xScale)
            {
                _correctTouches++;
                [self displayTargetHit];
                NSLog(@"zoom was correct!");
                [self.view removeGestureRecognizer: pinchGR];
                [_zoomTarget runAction:_gestureMoveDone];
                [_outline runAction:_gestureMoveDone];
                _isGestureDone = true;
                if (self.correctTouches == self.totalTargets)
                    [self endGame:self.correctTouches totalTargets:self.totalTargets];
                SKAction * wait = [SKAction waitForDuration:2.0];
                [self runAction:wait];
                [self displayTargets];
            }
        }
        else if (_gestureDirection == OUT)
        {
            if(_zoomTarget.xScale > _target.xScale)
            {
                _correctTouches++;
                [self displayTargetHit];
                NSLog(@"zoom was correct!");
                [self.view removeGestureRecognizer: pinchGR];
                [_zoomTarget runAction:_gestureMoveDone];
                [_outline runAction:_gestureMoveDone];
                _isGestureDone = true;
                if (self.correctTouches == self.totalTargets)
                    [self endGame:self.correctTouches totalTargets:self.totalTargets];
                SKAction * wait = [SKAction waitForDuration:2.0];
                [self runAction:wait];
                [self displayTargets];
            }
        }
    }
}

-(void) handlePanning: (UIPanGestureRecognizer *) recognizer
{

    _isGestureDone = false;
    NSLog(@"panning... gamemode: %d", _currentGesture);
    
    NSUInteger numOfTouches = [recognizer numberOfTouches];
    int x = 0; // <-just a counter!
    while ( x < numOfTouches && _hasStartedInCenter == 0)
    {
        bool hasTouched = [self isTargetTouched:[recognizer locationOfTouch:x inView:self.view]];
        if (hasTouched)
        {
            _hasStartedInCenter++;
        }
        x++;
    }
    
    if(_hasStartedInCenter > 0)
    {
        CGPoint changeInPosition = [recognizer translationInView:self.view];
        CGPoint newPosition = CGPointMake(_target.position.x +(.9* changeInPosition.x),_target.position.y - (.9*changeInPosition.y));
        SKAction *moveAction = [SKAction moveTo:newPosition duration:.05];
        [_updatedTarget runAction:moveAction];
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        NSLog(@"panning ended!");
        if( [self isInDragTarget:_updatedTarget.position] )
        {
            _correctTouches++;
            [self displayTargetHit];
            NSLog(@"pan was correct!");
            [self.view removeGestureRecognizer: panGR];
            [_updatedTarget runAction:_gestureMoveDone];
            [_dragTarget runAction: _gestureMoveDone];
            _isGestureDone = true;
            if (self.correctTouches == self.totalTargets)
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            SKAction * wait = [SKAction waitForDuration:2.0];
            [self runAction:wait];
            [self displayTargets];
        }
        else
        {
            SKAction *moveAction2 = [SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) duration:.05];
            [_updatedTarget runAction:moveAction2];
        }
    }

}
-(void) handleRotation: (UIRotationGestureRecognizer *) recognizer
{
    _isGestureDone = false;
    NSLog(@"rotating... gamemode: %d", _currentGesture);
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
        if ( _gestureDirection == COUNTER_CLOCKWISE && rotation < 0)
        {
            NSLog(@"COUNTER_CLOCKWISE");
        SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
        [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
        _hasRotated ++;
        }
        else if (_gestureDirection == CLOCKWISE && rotation > 0)
        {
            NSLog(@"CLOCKWISE");
            SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
            [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
            _hasRotated ++;
        }
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        if (_hasRotated > 0)      // THIS IS WHEN THE ROTATION IS CORRECT! (that means they has successfully spun the target for a little bit...
        {
            _correctTouches++;
            [self displayTargetHit];
            _numOfRotations ++;
            [self.view removeGestureRecognizer:rotationGR ];
            [_rotateTarget runAction:_gestureMoveDone];
            NSLog(@"correct rotation!\n");
            _isGestureDone = true;
            if (self.correctTouches == self.totalTargets)
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            SKAction * wait = [SKAction waitForDuration:2.0];
            [self runAction:wait];
            [self displayTargets];
        }
        allTouchedTarget = true;
        NSLog(@"rotation has actually ended");
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

-(bool)isInDragTarget: (CGPoint)touchLocation
{
    bool isInLocation = false;
    double xDifference = touchLocation.x - _dragTarget.position.x;
    double yDifference = touchLocation.y - _dragTarget.position.y;
    double radius = _dragTarget.size.width / 2;
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    NSLog(@"touch location: (%f,%f), target position: (%f,%f)", touchLocation.x, touchLocation.y, _dragTarget.position.x, _dragTarget.position.y);
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

-(void)addQuitButton
{
    _quitButton = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button"];
    _quitButton.position = CGPointMake(120, self.frame.size.height-80);
    _quitButton.name = @"quitButton";
    _quitButton.xScale = .7;
    _quitButton.yScale = .7;
    [self addChild:_quitButton];
    
    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
    _quitButtonPressed.position = CGPointMake(120, self.frame.size.height-80);
    _quitButtonPressed.name = @"quitButtonPressed";
    _quitButtonPressed.hidden = true;
    _quitButtonPressed.xScale = .7;
    _quitButtonPressed.yScale = .7;
    [self addChild:_quitButtonPressed];
}

-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:CGSizeMake(768,1024)
                                                                targetsHit:targetsHit
                                                              totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    NSLog(@"end game has touch log count %d", touchLog.count);
    [gameOverScene.userData setObject:@"gesture" forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

-(void)setupTabTouchScreenLabel
{
    _tapScreenLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];

    _tapScreenLabel.fontSize = 20;
    NSString * labelText = @"Tap screen to begin action!";
    _tapScreenLabel.text = labelText;
    _tapScreenLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _tapScreenLabel.fontColor = [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    //    NSLog(@"%@", touchLog);
    
}

-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 28;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height-80);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 28;
    timeLabel.fontColor =  [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height-80);
    
    //label for ratio of touched/total targets
    [self trackerLabel];
    
    
    float r_time = roundf(self.time *100)/100.0;
    NSString *s_time = [NSString stringWithFormat: @"%.1f", r_time];
    timeLabel.text = s_time;
    [self addChild: timeLabel];
    
    //    NSLog(@"Time: %f | string: %f", r_time, CGRectGetMidX(self.frame));
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.0075];
    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

-(void)displayTargetHit
{
    if (_enableSound)
    {
        NSString *soundFile = [UtilityClass getSoundFile];
        [self runAction:[SKAction playSoundFileNamed:soundFile waitForCompletion:NO]];
    }
    NSString * text2 = [NSString stringWithFormat:@"Gesture Complete! %d More!", self.totalTargets - self.correctTouches];
    SKLabelNode * targetHitLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    targetHitLabel.name = @"instructionLabel2";
    targetHitLabel.text = text2;
    targetHitLabel.fontSize = 24;
    targetHitLabel.fontColor = [SKColor yellowColor];
    targetHitLabel.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2 + 220);
    [self addChild:targetHitLabel];
    CGPoint dest = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    SKAction *fadeAway = [SKAction moveTo:dest duration:1.5];
    SKAction * remove = [SKAction removeFromParent];
    [targetHitLabel runAction:[SKAction sequence:@[fadeAway, remove]]];
}

@end