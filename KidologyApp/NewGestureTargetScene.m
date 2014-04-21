//
//  NewGestureTargetScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 4/15/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this is the gesture practice scene

#import <Foundation/Foundation.h>
#import "NewGestureTargetScene.h"
#import "TargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "MainMenuScene.h"
#import "math.h"
#import "LogEntry.h"
#import "SetupViewController.h"
#import "UtilityClass.h"

@implementation NewGestureTargetScene

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
        
        // initialize the touch log array
        touchLog = [[NSMutableArray alloc] init];
        
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;

        // play a sound to start the round
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];
        
        // add images
        [self addBackground];
        [self addQuitButton];
        [self initializeAnchor];
        
        // setup stuff for gesture recognition
        [self setupTabTouchScreenLabel];
        _gestureMoveDone =[SKAction removeFromParent];
        
        //The rotation gesture will detect a two + finger rotation
        rotationGR = [[ UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
        rotationGR.delegate = self; // needed to ignore anchor touches
        //The pan gesture will detech  1+ finger pan
        panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        panGR.minimumNumberOfTouches = 1;
        panGR.delegate = self;      // needed to ignore anchor touches
        //The zoom gesture will support 2 finger pinches
        pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        pinchGR.delegate = self;    // needed to ignore anchor touches
        
        _isGestureDone = true;
        [self displayTargets];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Single Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // check if the quit button was pressed
    if ([node.name isEqualToString:@"quitButton"] ||
        [node.name isEqualToString:@"quitButtonPressed"])
    {
        _quitButton.hidden = true;
        _quitButtonPressed.hidden = false;
    }
    else if ([self isAnchorTouch:location])
    {
        _anchored = TOUCHING;
        _anchor.hidden = TRUE;
        _pressedAnchor.hidden = FALSE;
        // log when anchor is first pressed (rather than every frame where anchor is held)
//        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Press"
//                                                           time:self.time
//                                                  anchorPressed:YES
//                                                     targetsHit:self.correctTouches
//                                             distanceFromCenter:@"NA"
//                                                  touchLocation:CGPointMake(location.x,  location.y)
//                                                 targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
//                                                   targetRadius:(self.target.size.width / 2)
//                                                 targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
//         [touchLog addObject:currentTouch];
    }
    else if (_isGestureDone)
    {
        // if gesture is done, add a new gesture recognizer to screen
        // (e.g. only called when finished with a gesture and switching to new one)
        
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

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        
        // check if the quit button was pressed
        SKNode *node = [self nodeAtPoint:positionInScene];
        if ([node.name isEqualToString:@"quitButton"] ||
            [node.name isEqualToString:@"quitButtonPressed"])
        {
            // reset the button images
            _quitButton.hidden = false;
            _quitButtonPressed.hidden = true;
            // transition to the game over scene
            [self endGame:self.correctTouches totalTargets:self.totalTargets];
        }
        else if ([self isAnchorTouch:positionInScene])
        {
            // or if the touch was on the anchor
            _anchored = NOT_TOUCHING;
            _anchor.hidden = FALSE;
            _pressedAnchor.hidden = TRUE;
            // log when anchor was released
//            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Release"
//                                                               time:self.time
//                                                      anchorPressed:NO
//                                                         targetsHit:self.correctTouches
//                                                 distanceFromCenter:@"NA"
//                                                      touchLocation:CGPointMake(positionInScene.x,  positionInScene.y)
//                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
//                                                       targetRadius:(self.target.size.width / 2)
//                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
//            [touchLog addObject:currentTouch];
        }
        else if ([[event allTouches] count] == 0)
        {
            // if there are no touches, make sure anchor is off
            _anchored = NOT_TOUCHING;
            _anchor.hidden = FALSE;
            _pressedAnchor.hidden = TRUE;

        }
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        // get the current and previous locations
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
        else if ([self isAnchorTouch:previousLocation] &&
                 ![self isAnchorTouch:currentLocation])
        {
            // if a touch was on the anchor but has moved off
            _anchored = NOT_TOUCHING;       // update _achored
            _anchor.hidden = FALSE;         // display red anchor image
            _pressedAnchor.hidden = TRUE;   // hide green anchor image
        }
        else if (![self isAnchorTouch:previousLocation] &&
                 [self isAnchorTouch:currentLocation])
        {
            // it wasn't an anchor touch but now it has moved onto the anchor
            _anchored = TOUCHING;           // update _anchored
            _anchor.hidden = TRUE;          // hide red anchor image
            _pressedAnchor.hidden = FALSE;  // display green anchor image
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Gesture Recognition Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// this method is the selector for the pinch gesture recognizer
-(void) handlePinch: (UIPinchGestureRecognizer *) recognizer
{
    // first check if the anchor is being touched
    if (_anchored != TOUCHING)
        return;
        
    _isGestureDone = false;
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
    
//Checks if the the current gesture starts in the target
    if(_hasStartedInCenter > 0)
    {
        CGFloat rawChangeInScale = [recognizer scale];
        _zoomTarget.xScale = 0.65 * rawChangeInScale;
        _zoomTarget.yScale = 0.65 * rawChangeInScale;
    }
    
//End of the gestures checks
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

// this method is the selector for the pan gesture recognizer
-(void) handlePanning: (UIPanGestureRecognizer *) recognizer
{
    // first check if the anchor is being touched
    if (_anchored != TOUCHING)
        return;
    
    _isGestureDone = false;
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

//Checks if the the current gesture starts in the target
    if(_hasStartedInCenter > 0)
    {
        CGPoint changeInPosition = [recognizer translationInView:self.view];
        CGPoint newPosition = CGPointMake(_target.position.x +(.9* changeInPosition.x),_target.position.y - (.9*changeInPosition.y));
        SKAction *moveAction = [SKAction moveTo:newPosition duration:.05];
        [_updatedTarget runAction:moveAction];
    }

//End of the gestures checks
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        if( [self isInDragTarget:_updatedTarget.position] )
        {
            _correctTouches++;
            [self displayTargetHit];
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

// this method is the selector for the rotation gesture recognizer
-(void) handleRotation: (UIRotationGestureRecognizer *) recognizer
{
// first check if the anchor is being touched
    if (_anchored != TOUCHING)
        return;
    
    _isGestureDone = false;
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
    
//Checks to see if the touches is on the target (cycles through touches)
    if (allTouchedTarget)
    {
        CGFloat rotation = recognizer.rotation;
        if ( _gestureDirection == COUNTER_CLOCKWISE && rotation < 0)
        {
            SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
            [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
            _hasRotated ++;
        }
        else if (_gestureDirection == CLOCKWISE && rotation > 0)
        {
            SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
            [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
            _hasRotated ++;
        }
    }
    
    if ( recognizer.state == UIGestureRecognizerStateEnded )
    {
        if (_hasRotated > 0)
        {
            // THIS IS WHEN THE ROTATION IS CORRECT! (that means they has successfully spun the target for a little bit...
            _correctTouches++;
            [self displayTargetHit];
            _numOfRotations ++;
            [self.view removeGestureRecognizer:rotationGR ];
            [_rotateTarget runAction:_gestureMoveDone];
            _isGestureDone = true;
            if (self.correctTouches == self.totalTargets)
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            SKAction * wait = [SKAction waitForDuration:2.0];
            [self runAction:wait];
            [self displayTargets];
        }
        allTouchedTarget = true;
    }
}

// delegate for a gesture recognizer telling it to ignore anchor touches from the gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPosition = [touch locationInNode:self];
    // Disallow recognition of tap gestures in the button.
    if ([self isAnchorTouch:touchPosition]) {
        return NO;
    }
    return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Simple Utility Methods
//-------------------------------------------------------------------------------------------------------------------------------------

// determines if a touch was on the anchor button
-(Boolean)isAnchorTouch:(CGPoint)touchLocation
{
    Boolean result;
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"pressedAnchor"] || [node.name isEqualToString:@"anchor"])
    {
        result = true;
    }
    else
    {
        result = false;
    }
    return result;
}

// this method determines whether a touch is on the target
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

// this method determines if the target has been dragged to the drag destination
-(bool)isInDragTarget: (CGPoint)touchLocation
{
    bool isInLocation = false;
    double xDifference = touchLocation.x - _dragTarget.position.x;
    double yDifference = touchLocation.y - _dragTarget.position.y;
    double radius = _dragTarget.size.width / 2;
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    if (leftHandSide <= rightHandSide) {
        isInLocation = true;
    }
    
    return isInLocation;
}

// this method transitions to the game over scene
-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:CGSizeMake(768,1024)
                                                                targetsHit:targetsHit
                                                              totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    [gameOverScene.userData setObject:@"gesture" forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

// this method displays one of several kinds of targets depending on which gesture is randomly chosen
-(void)displayTargets
{
    
// This is used to randomize the next target
    int rand = arc4random_uniform(3);
    if (rand == 0)
    {
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
    
//added the normal target for reference
    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
    _target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _target.xScale = .75;
    _target.yScale = .75;
    [self addChild:_target];
    
//handles the initialization of rotate gesture
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
    
//handles the intialization of drag gesture
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
        // move the target right if it's behind the quit button
        if (x_pos < _quitButton.position.x + _quitButton.size.width*0.5 + _updatedTarget.size.width*0.5)
        {
            x_pos = _quitButton.position.x + _quitButton.size.width*0.5 + _updatedTarget.size.width*0.5;
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
        // move the target down if it's behind the quit button
        if (y_pos > _quitButton.position.x - _quitButton.size.height*0.5 - _updatedTarget.size.height*0.5)
        {
            y_pos = _quitButton.position.x - _quitButton.size.height*0.5 - _updatedTarget.size.height*0.5;
        }
        _dragTarget.position = CGPointMake(x_pos, y_pos);
        [self addChild: _dragTarget];
        [self addChild: _updatedTarget];
    }
    
//handles the initialization of the zoom gesture
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
        //used the target as the baseline
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

// add the background image
-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .5;
    bgImage.yScale = .5;
    [self addChild:bgImage];
}

// add the quit button image
-(void)addQuitButton
{
    // unpressedquit button
    _quitButton = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button"];
    _quitButton.position = CGPointMake(120, self.frame.size.height-80);
    _quitButton.name = @"quitButton";
    _quitButton.xScale = .7;
    _quitButton.yScale = .7;
    [self addChild:_quitButton];
    
    // pressed quit button
    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
    _quitButtonPressed.position = CGPointMake(120, self.frame.size.height-80);
    _quitButtonPressed.name = @"quitButtonPressed";
    _quitButtonPressed.hidden = true;
    _quitButtonPressed.xScale = .7;
    _quitButtonPressed.yScale = .7;
    [self addChild:_quitButtonPressed];
}

// this method displays the text label instructing the user to tap the screen to begin the action
-(void)setupTabTouchScreenLabel
{
    _tapScreenLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];

    _tapScreenLabel.fontSize = 20;
    NSString * labelText = @"Tap screen to begin action!";
    _tapScreenLabel.text = labelText;
    _tapScreenLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _tapScreenLabel.fontColor = [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
}

// this method updates the time counter
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    //    NSLog(@"%@", touchLog);
    
}

// this method displays the number of hits in the top right corner
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

// this method displays the elapsed time in the top right corner
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 28;
    timeLabel.fontColor =  [SKColor yellowColor];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height-80);
    
    //label for ratio of touched/total targets
    [self trackerLabel];
    
    float r_time = roundf(self.time *100)/100.0;
    NSString *s_time = [NSString stringWithFormat: @"%.1f", r_time];
    timeLabel.text = s_time;
    [self addChild: timeLabel];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.0075];
    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// this method displays a message saying "Target Hit!" and plays a sound
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

-(void)initializeAnchor
{
    //initialize green anchor
    _pressedAnchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_green_left"];
    _pressedAnchor.xScale = .4;
    _pressedAnchor.yScale = .4;
    _pressedAnchor.hidden = TRUE;
    
    //initialize red anchor
    _anchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_red_left"];
    _anchor.xScale = .4;
    _anchor.yScale = .4;
    
    if([_affectedHand isEqualToString:@"right"]) //if right hand affected
    {
        _pressedAnchor.position = CGPointMake(75, self.frame.size.height/2-150);
        
        _anchor.position = CGPointMake(75, self.frame.size.height/2-150);
        
    }
    else    // _affectedHand == "left"
    {
        _pressedAnchor.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2-150);
        
        _anchor.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2-150);
    }
    _pressedAnchor.name =@"pressedAnchor";
    [self addChild:_pressedAnchor];
    
    _anchor.name = @"anchor";
    [self addChild:_anchor];
}

@end