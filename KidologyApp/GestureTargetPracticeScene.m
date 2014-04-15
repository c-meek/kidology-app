//
//  GestureTargetPracticeScene.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/14/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "GestureTargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "MainMenuScene.h"
#import "math.h"
#import "LogEntry.h"
#import "SetupViewController.h"

@implementation GestureTargetPracticeScene
//
//  TargetPracticeScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//




NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size numberOfTargets:(int)numberOfTargets;
{
    if (self = [super initWithSize:size])
    {
    }
    return self;
}
@end
//        // initialize variables
//        _numOfRotations = 0;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults synchronize];
//        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
//        self.delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
//        _affectedHand = [defaults objectForKey:@"affectedHand"];
//        NSLog(@"total targets is %d", self.totalTargets);
//        NSLog(@"delay between is %d", self.delayBetweenTargets);
//        
//        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
//        self.correctTouches = 0;
//        // initialize the anchor to "not being touched" state
//        self.anchored = NOT_TOUCHING;
//        self.time = 0;
//        
//        // add images
//        [self addBackground];
//        [self addTargetImage];
//        [self addQuitButton];
//        
//        //initialize anchor
//        [self initializeAnchor];
//        
//        // STUFF FOR GESTURES
//        
//        _isGestureDone = true;
//        _gestureMoveDone =[SKAction removeFromParent];
//        //swipe right gesture…
//        swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeRight:)];
//        [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
//        
//        //swipe left gesture…
//        swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeLeft:)];
//        [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
//        
//        //swipe up gesture…
//        swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeUp:)];
//        [swipeUpGesture setDirection: UISwipeGestureRecognizerDirectionUp];
//        
//        
//        //swipe down gesture…
//        swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeDown:)];
//        [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
//        
//        
//        //And the rotation gesture will detect a two finger rotation
//        rotationGR = [[ UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
//        
//        [self displayActionTarget];
//    }
//    return self;
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    /* Called when a touch begins */
//
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//        //test whether the target has been touched
//    for (UITouch *touch in [touches allObjects])
//    {
//        // see if quit button or anchor button touch began
//        CGPoint positionInScene = [touch locationInNode:self];
//        SKNode *node = [self nodeAtPoint:location];
//        if ([node.name isEqualToString:@"quitButton"] ||
//            [node.name isEqualToString:@"quitButtonPressed"])
//        {
//            _quitButton.hidden = true;
//            _quitButtonPressed.hidden = false;
//        }
//        if ([self isAnchorTouch:positionInScene])
//        {
//            // If it is on the anchor,
//            _anchored = TOUCHING; // make note of that.
//            _anchor.hidden = TRUE;
//            _pressedAnchor.hidden = FALSE;
//        }
////        else if (_gameMode != GESTURE)
////        {
////            // If the touch isn't on the anchor
////            [self targetTouch:positionInScene]; // log it inside the targetTouch function and evaluate accordingly.
////        }
//    }
//    
////    
////    if (_gameMode == GESTURE && _isActionDone == true)
////    {
////        NSLog(@"touches began! \n");
////        [self displayActionTarget];
////        [_tapSreenLabel runAction:_actionMoveDone];
////        _isActionDone = false;
////        if (_currentAction == SWIPE)
////        {
////            [self addChild:_arrow];
////        }
////        else if (_currentAction == ROTATE)
////        {
////            [self addChild:_rotateTarget];
////        }
////    }
//
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    /* Called when a touch ends */
//    for (UITouch *touch in [touches allObjects]) {
//        CGPoint positionInScene = [touch locationInNode:self];
//        
//        SKNode *node = [self nodeAtPoint:positionInScene];
//        if ([node.name isEqualToString:@"quitButton"] ||
//            [node.name isEqualToString:@"quitButtonPressed"])
//        {
//            _quitButton.hidden = false;
//            _quitButtonPressed.hidden = true;
//            [self endGame:self.correctTouches totalTargets:self.totalTargets];
//        }
//        if ([self isAnchorTouch:positionInScene])
//        {
//            _anchored = NOT_TOUCHING; // make note of that.
//            _anchor.hidden = FALSE;
//            _pressedAnchor.hidden = TRUE;
//        }
//        // else, it's a non-anchor touch and nothing needs done
//    }
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    /* Called when a touch moves/slides */
//    for (UITouch *touch in [touches allObjects]) {
//    	CGPoint currentLocation  = [touch locationInNode:self];
//        CGPoint previousLocation = [touch previousLocationInNode:self];
//        SKNode *currentNode = [self nodeAtPoint:currentLocation];
//        SKNode *previousNode = [self nodeAtPoint:previousLocation];
//        
//        // If a touch was off the back button but has moved onto it
//        if (!([_quitButton isEqual:previousNode] || [_quitButtonPressed isEqual:previousNode]) &&
//            ([_quitButton isEqual:currentNode] || [_quitButtonPressed isEqual:currentNode]))
//        {
//            _quitButtonPressed.hidden = false;
//            _quitButton.hidden = true;
//        }
//        else if (([_quitButton isEqual:previousNode] || [_quitButtonPressed isEqual:previousNode]) &&
//                 !([_quitButton isEqual:currentNode] || [_quitButtonPressed isEqual:currentNode]))
//        {
//            // touch was on quit button but moved off
//            _quitButtonPressed.hidden = true;
//            _quitButton.hidden = false;
//        }
//        
//        // If a touch was on the anchor but has moved off
//        if ([self isAnchorTouch:previousLocation] &&
//            ![self isAnchorTouch:currentLocation])
//        {
//            _anchored = NOT_TOUCHING;       // update _achored
//            _anchor.hidden = FALSE;         // display red anchor image
//            _pressedAnchor.hidden = TRUE;   // hide green anchor image
//        }
//        else if (![self isAnchorTouch:previousLocation] &&
//                 [self isAnchorTouch:currentLocation])
//        {
//            // it wasn't an anchor touch but now it has moved onto the anchor
//            _anchored = TOUCHING;           // update _anchored
//            _anchor.hidden = TRUE;          // hide red anchor image
//            _pressedAnchor.hidden = FALSE;  // display green anchor image
//        }
//        // else, it's a non-anchor touch and nothing needs done
//    }
//    
//    
//}
//
//-(Boolean)isAnchorTouch:(CGPoint)touchLocation
//{
//    Boolean result;
//    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
//    SKNode *node = [self nodeAtPoint:touchLocation];
//    
//    if ([node.name isEqualToString:@"pressedAnchor"] || [node.name isEqualToString:@"anchor"])
//    {
//        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Panel" time:self.time touchLocation:CGPointMake(touchLocation.x, touchLocation.y) targetLocation:CGPointMake(self.target.position.x, self.target.position.y) targetRadius:(self.target.size.width / 2)];
//        //{PANEL, self.time, CGPointMake(touchLocation.x, touchLocation.y), CGPointMake(self.target.position.x, self.target.position.y), self.target.size.width / 2};
//        [touchLog addObject:currentTouch];
//        result = true;
//    }
//    else
//    {
//        result = false;
//    }
//    return result;
//}
//
//-(bool)isTargetTouched:(CGPoint)touchLocation
//{
//    bool isInLocation = false;
//    double xDifference = touchLocation.x - self.target.position.x;
//    double yDifference = touchLocation.y - self.target.position.y;
//    double radius = self.target.size.width / 2;
//    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
//    double rightHandSide = pow(radius, 2);
//    
//    if (leftHandSide <= rightHandSide) {
//        isInLocation = true;
//    }
//    return isInLocation;
//}
//
//-(void)rightAction
//{
//    if(self.totalTargets <= self.correctTouches)
//    {
//        //NSLog(@"Correct Touches: %d\n", self.correctTouches);
//        SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:self.correctTouches
//                                                                  totalTargets:self.totalTargets ];
//        // pass the game type and touch log to "game over" scene
//        NSString *mode = @"gesture";
//        [gameOverScene.userData setObject:mode forKey:@"gameMode"];
//        [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
//        [self.view presentScene:gameOverScene transition: reveal];
//    }
//    else
//    {
//        [self displayActionTarget];
//    }
//}
//
//
//
//
//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
//    self.lastUpdateTimeInterval = currentTime;
//    [self updateWithTimeSinceLastUpdate:timeSinceLast];
//    //    NSLog(@"%@", touchLog);
//    
//}
//
//-(void)trackerLabel
//{
//    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    trackerLabel.fontSize = 20;
//    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
//    trackerLabel.text = text;
//    trackerLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
//    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
//    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
//    [self addChild:trackerLabel];
//    SKAction * actionMoveDone = [SKAction removeFromParent];
//    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
//    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
//}
//
//- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
//    
//    self.lastSpawnTimeInterval += timeSinceLast;
//    if (self.lastSpawnTimeInterval > .1) {
//        self.lastSpawnTimeInterval = 0;
//        self.time +=.1;
//    }
//    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    timeLabel.fontSize = 20;
//    timeLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
//    timeLabel.verticalAlignmentMode = 2;
//    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
//    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+265);
//    
//    //label for ratio of touched/total targets
//    [self trackerLabel];
//    
//    
//    float r_time = roundf(self.time *100)/100.0;
//    NSString *s_time = [NSString stringWithFormat: @"%.1f", r_time];
//    timeLabel.text = s_time;
//    [self addChild: timeLabel];
//    
//    //    NSLog(@"Time: %f | string: %f", r_time, CGRectGetMidX(self.frame));
//    SKAction * actionMoveDone = [SKAction removeFromParent];
//    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.0075];
//    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
//}
//
//-(void)addBackground
//{
//    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
//    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
//    bgImage.xScale = .4;
//    bgImage.yScale = .4;
//    [self addChild:bgImage];
//}
//
//-(void)addTargetImage
//{
//    //initialize target
//    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
//    
//    //add target to screen
//    [self addChild:self.target];
//}
//
//-(void)addQuitButton
//{
//    _quitButton = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button"];
//    _quitButton.position = CGPointMake(100, self.frame.size.height/2+235);
//    _quitButton.name = @"quitButton";
//    _quitButton.xScale = .5;
//    _quitButton.yScale = .5;
//    [self addChild:_quitButton];
//    
//    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
//    _quitButtonPressed.position = CGPointMake(100, self.frame.size.height/2+235);
//    _quitButtonPressed.name = @"quitButtonPressed";
//    _quitButtonPressed.hidden = true;
//    _quitButtonPressed.xScale = .5;
//    _quitButtonPressed.yScale = .5;
//    [self addChild:_quitButtonPressed];
//}
//
//-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
//{
//    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
//    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
//    // pass the game type and touch log to "game over" scene
//    NSString *mode = @"gesture";
//    NSLog(@"end game has touch log count %d", touchLog.count);
//    [gameOverScene.userData setObject:mode forKey:@"gameMode"];
//    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
//    [self.view presentScene:gameOverScene transition:reveal];
//}
//
//-(void)initializeAnchor
//{
//    
//    //initialize green anchor
//    _pressedAnchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_green_left"];
//    _pressedAnchor.xScale = .3;
//    _pressedAnchor.yScale = .3;
//    _pressedAnchor.hidden = TRUE;
//    
//    //initialize red anchor
//    _anchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_red_left"];
//    _anchor.xScale = .3;
//    _anchor.yScale = .3;
//    
//    if([_affectedHand isEqualToString:@"right"]) //if right hand affected
//    {
//        _pressedAnchor.position = CGPointMake(75, self.frame.size.height/2-150);
//        
//        _anchor.position = CGPointMake(75, self.frame.size.height/2-150);
//        
//    }
//    else    // _affectedHand == "left"
//    {
//        _pressedAnchor.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2-150);
//        
//        _anchor.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2-150);
//    }
//    _pressedAnchor.name =@"pressedAnchor";
//    [self addChild:_pressedAnchor];
//    
//    _anchor.name = @"anchor";
//    [self addChild:_anchor];
//}
//
//-(void)displayActionTarget
//{
//    
//    self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    self.target.xScale = .67;
//    self.target.yScale = .67;
//    
//    int x = arc4random_uniform(2); // REMEMBER TO CHANGE THIS TO 3 WHEN ZOOM IS COMPLETE
//                                   // NSLog(@"Action Num %d\n",x);
//    if (x == 0)
//    {
//        
//        SKAction *rotate90 = [SKAction rotateByAngle:-3.14/2 duration:0];
//        SKAction *negRotate90 = [SKAction rotateByAngle:3.14/2 duration:0];
//        _arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
//        _arrow.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        _currentGesture = SWIPE;
//        _swipedOutside = true;
//        
//        int direction = 3;//arc4random_uniform(4);
//        if ( direction == 0)
//        {
//            [self.view addGestureRecognizer: swipeUpGesture ];
//            [_arrow runAction:negRotate90];
//            _gestureDirection = UP;
//        }
//        else if ( direction == 1)
//        {
//            [self.view addGestureRecognizer: swipeDownGesture ];
//            [_arrow runAction:rotate90];
//            _gestureDirection = DOWN;
//        }
//        else if (direction == 2)
//        {
//            [self.view addGestureRecognizer: swipeLeftGesture ];
//            [_arrow runAction:negRotate90];
//            [_arrow runAction:negRotate90];
//            _gestureDirection = LEFT;
//        }
//        else if (direction == 3)
//        {
//            [self.view addGestureRecognizer: swipeRightGesture ];
//            _gestureDirection = RIGHT;
//        }
//    }
//    else if ( x == 1)
//    {
//        
//        [self.view addGestureRecognizer:rotationGR];
//        
//        _rotateTarget = [SKSpriteNode spriteNodeWithImageNamed:@"rotate_green_target"];
//        _rotateTarget.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        _rotateTarget.xScale = .67;
//        _rotateTarget.yScale = .67;
//        
//        _currentGesture = ROTATE;
//        _hasRotated = 0;
//        int direction = arc4random_uniform(2);
//        if (direction == 0)
//        {
//            _gestureDirection = CLOCKWISE;
//        }
//        else if (direction == 1)
//        {
//            _gestureDirection = COUNTER_CLOCKWISE;
//        }
//    }
//    else if ( x == 2)
//    {
//        _currentGesture = ZOOM;
//        int direction = arc4random_uniform(2);
//        if (direction == 0)
//        {
//            _gestureDirection = IN;
//        }
//        else if (direction == 1)
//        {
//            _gestureDirection = OUT;
//        }
//        
//    }
//}
//
//-(void) handleRotation: (UIRotationGestureRecognizer *) recognizer
//{
//    
//    LogEntry *currentTouch;
//    
//    bool allTouchedTarget =true;
//    if (true)//_anchored == TOUCHING)  // change this when proper testing can occur!
//    {
//        NSUInteger num_of_touches = [recognizer numberOfTouches];
//        
//        int x = 0;
//        while (x < num_of_touches)
//        {
//            bool isTargetTouched = [self isTargetTouched:[recognizer locationOfTouch:x  inView:nil]];
//            if (isTargetTouched)
//            {
//                
//                NSString *touch_type = [NSString stringWithFormat:@"Rotation%d Touch%d - On Target", _numOfRotations, x+1];
//                currentTouch = [[LogEntry alloc] initWithType:touch_type time:self.time touchLocation:[recognizer locationOfTouch:x inView:nil] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                x++;
//                [touchLog addObject:currentTouch];
//            }
//            else
//            {
//                NSString *touch_type = [NSString stringWithFormat:@"Rotation%d Touch%d - Off Target", _numOfRotations, x+1];
//                currentTouch = [[LogEntry alloc] initWithType:touch_type time:self.time touchLocation:[recognizer locationOfTouch:x inView:nil] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                x++;
//                allTouchedTarget = false;
//                [touchLog addObject:currentTouch];
//            }
//        }
//        
//        if (allTouchedTarget)
//        {
//            CGFloat rotation = recognizer.rotation;
//            SKAction * spinaction = [SKAction rotateByAngle:-rotation/60 duration:1/60];
//            [_rotateTarget runAction:[SKAction sequence:@[spinaction]]];
//            _hasRotated ++;
//        }
//        
//        if ( recognizer.state == UIGestureRecognizerStateEnded )
//        {
//            _numOfRotations ++;
//            if (_hasRotated > 0)      // THIS IS WHEN THE ROTATION IS CORRECT! (that means they has successfully spun the target for a little bit...
//            {
//                [_rotateTarget runAction:_gestureMoveDone];
//                NSLog(@"correct rotation!\n");
//                _correctTouches++;
//                // [self rightAction];
//                [self.view removeGestureRecognizer:rotationGR ];
//                _isGestureDone = true;
//            }
//            allTouchedTarget = true;
//            NSLog(@"rotation has actually ended");
//        }
//    }
//}
//
//-(void) handleSwipeRight:( UISwipeGestureRecognizer *) recognizer {
//    
//    LogEntry *currentTouch;
//    
//    if (true)//_anchored == TOUCHING)  // change this when proper testing can occure!
//    {
//        if ( recognizer.numberOfTouches == 2)
//        {  /* do nothing for now*/ }
//        else
//        {
//            //                             [recognizer locationOfTouch:x  inView:nil]
//            CGPoint pt = [recognizer locationOfTouch:0 inView:self.view];
//            bool isTargetTouched = [self isTargetTouched:pt];
//            NSLog(@"isTargetTouched: %d, location: (%f, %f)",isTargetTouched, pt.x, pt.y);
//            NSLog(@"Target Posistion: (%f,%f), radius: %f", _target.position.x, _target.position.y, _target.size.width/2);
//            if (isTargetTouched)
//            {
//                _swipedOutside = false;
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Right On target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//                
//                
//                SKAction * moveaction = [SKAction moveTo:CGPointMake(_target.position.x + 200 , _target.position.y) duration:1];
//                [_target runAction:moveaction];
//                
//            }
//            else
//            {
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Right Off target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//            }
//            
//            if ( recognizer.state == UIGestureRecognizerStateEnded )
//            {
//                if (_swipedOutside == false)
//                {
//                    NSLog(@"Swipe right correct! has_touch_outside: %d\n", _swipedOutside);
//                    
//                    [_arrow runAction:_gestureMoveDone];
//                    _correctTouches++;
//                    
//                    [self.view removeGestureRecognizer:swipeUpGesture ];
//                    _isGestureDone = true;
//                }
//                NSLog(@"Swipe has actually ended");
//            }
//        }
//    }    
//}
//
//-(void) handleSwipeLeft:( UISwipeGestureRecognizer *) recognizer {
//    
//    LogEntry *currentTouch;
//    
//    if (true)//_anchored == TOUCHING)  // change this when proper testing can occure!
//    {
//        if ( recognizer.numberOfTouches == 2)
//        {  /* do nothing for now*/ }
//        else
//        {
//            CGPoint pt = [recognizer locationOfTouch:0 inView:nil];
//            bool isTargetTouched = [self isTargetTouched:pt];
//            NSLog(@"isTargetTouched: %d, location: (%f, %f)",isTargetTouched, pt.x, pt.y);
//            NSLog(@"Target Posistion: (%f,%f)", _target.position.x, _target.position.y);
//            
//            if (isTargetTouched && _swipedOutside == true)
//            {
//                _swipedOutside = false;
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Left On target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//                
//                
//                SKAction * moveaction = [SKAction moveTo:CGPointMake(_target.position.x -200 , _target.position.y) duration:1];
//                [_target runAction:moveaction];
//                
//            }
//            else
//            {
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Down Off target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//            }
//            
//            if ( recognizer.state == UIGestureRecognizerStateEnded )
//            {
//                if (_swipedOutside == false)
//                {
//                    NSLog(@"Swipe left correct! has_touch_outside: %d\n", _swipedOutside);
//                    
//                    [_arrow runAction:_gestureMoveDone];
//                    _correctTouches++;
//                    
//                    //[self rightAction];
//                    [self.view removeGestureRecognizer:swipeUpGesture ];
//                    _isGestureDone = true;
//                }
//                NSLog(@"Swipe has actually ended");
//            }
//        }
//    }
//}
//
//
//-(void) handleSwipeUp:( UISwipeGestureRecognizer *) recognizer {
//    
//    LogEntry *currentTouch;
//    
//    if (true)//_anchored == TOUCHING)  // change this when proper testing can occure!
//    {
//        if ( recognizer.numberOfTouches == 2)
//        {  /* do nothing for now*/ }
//        else
//        {
//            CGPoint pt = [recognizer locationOfTouch:0 inView:nil];
//            bool isTargetTouched = [self isTargetTouched:pt];
//            NSLog(@"isTargetTouched: %d, location: (%f, %f)",isTargetTouched, pt.x, pt.y);
//            NSLog(@"Target Posistion: (%f,%f)", _target.position.x, _target.position.y);
//            
//            if (isTargetTouched && _swipedOutside == true)
//            {
//                _swipedOutside = false;
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Up On target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//                
//                
//                SKAction * moveaction = [SKAction moveTo:CGPointMake(_target.position.x , _target.position.y +200) duration:1];
//                [_target runAction:moveaction];
//                
//            }
//            else
//            {
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Up Off target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//            }
//            
//            if ( recognizer.state == UIGestureRecognizerStateEnded )
//            {
//                if (_swipedOutside == false)
//                {
//                    NSLog(@"Swipe up correct! has_touch_outside: %d\n", _swipedOutside);
//                    
//                    [_arrow runAction:_gestureMoveDone];
//                    _correctTouches++;
//                    
//                    //[self rightAction];
//                    [self.view removeGestureRecognizer:swipeUpGesture ];
//                    _isGestureDone = true;
//                }
//                NSLog(@"Swipe has actually ended");
//            }
//        }
//    }
//}
//
//-(void) handleSwipeDown:( UISwipeGestureRecognizer *) recognizer {
//    
//    LogEntry *currentTouch;
//    
//    if (true)//_anchored == TOUCHING)  // change this when proper testing can occure!
//    {
//        if ( recognizer.numberOfTouches == 2)
//        {  /* do nothing for now*/ }
//        else
//        {
//            CGPoint pt = [recognizer locationOfTouch:0 inView:nil];
//            bool isTargetTouched = [self isTargetTouched:pt];
//            NSLog(@"isTargetTouched: %d, location: (%f, %f)",isTargetTouched, pt.x, pt.y);
//            NSLog(@"Target Posistion: (%f,%f)", _target.position.x, _target.position.y);
//            
//            if (isTargetTouched && _swipedOutside == true)
//            {
//                _swipedOutside = false;
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Down On target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//                
//                
//                SKAction * moveaction = [SKAction moveTo:CGPointMake(_target.position.x , _target.position.y -200) duration:1];
//                [_target runAction:moveaction];
//                
//            }
//            else
//            {
//                currentTouch = [[LogEntry alloc] initWithType:@"Swiping Down Off target" time:self.time touchLocation:[recognizer locationOfTouch:0 inView:self.view] targetLocation:self.target.position targetRadius:_target.size.width/2];
//                [touchLog addObject:currentTouch];
//            }
//            
//            if ( recognizer.state == UIGestureRecognizerStateEnded )
//            {
//                if (_swipedOutside == false)
//                {
//                    NSLog(@"Swipe down correct! has_touch_outside: %d\n", _swipedOutside);
//                    
//                    [_arrow runAction:_gestureMoveDone];
//                    _correctTouches++;
//                    
//                    //[self rightAction];
//                    [self.view removeGestureRecognizer:swipeUpGesture ];
//                    _isGestureDone = true;
//                }
//                NSLog(@"Swipe has actually ended");
//            }
//        }
//    }
//}
//
//@end
//
//
