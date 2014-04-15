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
#import "LogEntry.h"
#import "SetupViewController.h"

@implementation TargetPracticeScene

NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size game_mode:(int)game_mode
{
    if (self = [super initWithSize:size])
    {
        // initialize variables
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        self.delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _affectedHand = [defaults objectForKey:@"affectedHand"];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        NSLog(@"target size is %f", _targetSize);

        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        self.correctTouches = 0;
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;
        self.time = 0;

        // add images
        [self addBackground];
        [self addTargetImage];
        
        [self addQuitButton];

        //initialize anchor
        [self initializeAnchor];
        if (game_mode == 0) {
            _gameMode = CENTER;
        }
        else if (game_mode == 1) {
            _gameMode = RANDOM;
        }

        [self displayTarget];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"quitButton"] ||
        [node.name isEqualToString:@"quitButtonPressed"])
    {
        _quitButton.hidden = true;
        _quitButtonPressed.hidden = false;
    }
    /* Called when a touch begins */
    //test whether the target has been touched
    for (UITouch *touch in [touches allObjects])
    {
        /* Called when a touch begins */
        CGPoint positionInScene = [touch locationInNode:self];
        //test whether the target has been touched
        
        if ([self isAnchorTouch:positionInScene])
        {
            // If it is on the anchor,
            _anchored = TOUCHING; // make note of that.
            _anchor.hidden = TRUE;
            _pressedAnchor.hidden = FALSE;
            // log when anchor is first pressed (rather than every frame where anchor is held)
            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Press"
                                                            time:self.time
                                                      anchorPressed:YES
                                                         targetsHit:self.correctTouches
                                                 distanceFromCenter:@"NA"
                                                      touchLocation:CGPointMake(positionInScene.x,  positionInScene.y)
                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                       targetRadius:(self.target.size.width / 2)
                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            //{PANEL, self.time, CGPointMake(touchLocation.x, touchLocation.y), CGPointMake(self.target.position.x, self.target.position.y), self.target.size.width / 2};
            [touchLog addObject:currentTouch];
        }
        else
        {
            // If the touch isn't on the anchor
            [self targetTouch:positionInScene]; // log it inside the targetTouch function and evaluate accordingly.
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
        if ([self isAnchorTouch:positionInScene])
        {
            _anchored = NOT_TOUCHING; // make note of that.
            _anchor.hidden = FALSE;         
            _pressedAnchor.hidden = TRUE;
            // log when anchor is first pressed (rather than every frame where anchor is held)
            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Release"
                                                               time:self.time
                                                      anchorPressed:NO
                                                         targetsHit:self.correctTouches
                                                 distanceFromCenter:@"NA"
                                                      touchLocation:CGPointMake(positionInScene.x,  positionInScene.y)
                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                       targetRadius:(self.target.size.width / 2)
                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            //{PANEL, self.time, CGPointMake(touchLocation.x, touchLocation.y), CGPointMake(self.target.position.x, self.target.position.y), self.target.size.width / 2};
            [touchLog addObject:currentTouch];

        }
        // else, it's a non-anchor touch and nothing needs done
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
        
        // If a touch was on the anchor but has moved off
        if ([self isAnchorTouch:previousLocation] &&
            ![self isAnchorTouch:currentLocation])
        {
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
        // else, it's a non-anchor touch and nothing needs done
    }
}

-(Boolean)isAnchorTouch:(CGPoint)touchLocation
{
    Boolean result;
    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
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

-(void)displayTarget
{
    if (_gameMode == CENTER)
    {
        //set target to middle of screen
        self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.target.xScale = _targetSize;
        self.target.yScale = _targetSize;
        NSLog(@"Radius : %f", _target.size.width/2);
        NSLog(@"Position: (%f , %f", _target.position.x, _target.position.y);
    }
    else if (_gameMode == RANDOM)
    {
        //      set the target to appear at random locations
        //      int x_pos = (rand() % (int)self.size.width)*.8;
        //      randomize size of target
        int min = 30;
        int max = 67;
        float randomScale = ((min + arc4random() % (max-min))) * .01;
        _target.xScale = randomScale;
        _target.yScale = randomScale;
        int x_pos = .75 * ((arc4random_uniform((int)self.size.width)/2)-(_target.size.width/2));
        int pos_neg = (rand() % 1);
        if (pos_neg == 0)
        {
            x_pos = self.frame.size.width/2 + x_pos;
        }
        else
        {
            x_pos = self.frame.size.width/2 - x_pos;
        }
        int y_pos = .75 * ((arc4random_uniform((int)self.size.height)/2)-(_target.size.height/2));
        pos_neg = arc4random_uniform(2);
        if (pos_neg == 0)
        {
            y_pos = self.frame.size.height/2 + y_pos;
        }
        else
        {
            y_pos = self.frame.size.height/2 - y_pos;
        }
        self.target.position = CGPointMake(x_pos, y_pos);
    }
    
}

-(void)targetTouch:(CGPoint)touchLocation
{
    _totalTouches++;
//    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));

//    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
//    double rightHandSide = pow(radius, 2);
    LogEntry *currentTouch;
    
//    if(leftHandSide <= rightHandSide) // If the touch is on the target
    NSLog(@"distance from center is %f   radius is %f", distanceFromCenter, radius);
    if (distanceFromCenter <= radius)
    {
        
        //currentTouch.time = self.time;
        //currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        //currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        //currentTouch.targetRadius = radius;
        if (_anchored == TOUCHING) // the anchor is currently being touched
        {
            _correctTouches++;
            NSLog(@"adding anchored touch to log");

            currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                     time:self.time
                                            anchorPressed:YES
                                               targetsHit:self.correctTouches
                                       distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                            touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                           targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                             targetRadius:radius
                                           targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch]; // log the touch
            //currentTouch.type = TARGET;
            //make a "delete" target action
            SKAction *deleteTarget = [SKAction runBlock:^{
                self.target.position = CGPointMake(-100,-100);
            }];
  
            SKAction *wait = [SKAction waitForDuration:self.delayBetweenTargets];
            //make a "add" target action
            SKAction *addTarget = [SKAction runBlock:^{
                [self displayTarget];
            }];
            
            // check to see if the total number of targets have been touched, then show the ending screen
            if(self.totalTargets == self.correctTouches)
            {
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            }
            //combine all the actions into a sequence
            SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
            //run the actions in sequential order
            [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        }
        else // the anchor is not currently being touched
        {
            NSLog(@"adding unanchored touch to log");
            currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                     time:self.time
                                            anchorPressed:NO
                                               targetsHit:self.correctTouches
                                       distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                            touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                           targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                             targetRadius:radius
                                           targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            //currentTouch.type = UNANCHORED_TARGET;
            [touchLog addObject:currentTouch]; // log the touch
        }
    }
    else
    {
        currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                 time:self.time
                                        anchorPressed:(_anchored == TOUCHING)
                                           targetsHit:self.correctTouches
                                   distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                        touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                       targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                         targetRadius:radius
                                       targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
        //currentTouch.type = WHITESPACE;
        //currentTouch.time = self.time;
        //currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        //currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        //currentTouch.targetRadius = self.target.size.width / 2;
        //NSLog(@"%i", currentTouch.type);
        [touchLog addObject:currentTouch];
    }
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
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
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
    timeLabel.fontSize = 20;
    timeLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+265);

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

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(void)addTargetImage
{
    //initialize target
    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
    
    //add target to screen
    [self addChild:self.target];
}

-(void)addQuitButton
{
    _quitButton = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button"];
    _quitButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _quitButton.name = @"quitButton";
    _quitButton.xScale = .5;
    _quitButton.yScale = .5;
    [self addChild:_quitButton];
    
    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
    _quitButtonPressed.position = CGPointMake(100, self.frame.size.height/2+235);
    _quitButtonPressed.name = @"quitButtonPressed";
    _quitButtonPressed.hidden = true;
    _quitButtonPressed.xScale = .5;
    _quitButtonPressed.yScale = .5;
    [self addChild:_quitButtonPressed];
}

-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    NSString *mode = [self getGameMode:_gameMode];
    NSLog(@"end game has touch log count %d", touchLog.count);
    [gameOverScene.userData setObject:mode forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

-(void)initializeAnchor
{
    //initialize green anchor
    _pressedAnchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_green_left"];
    _pressedAnchor.xScale = .3;
    _pressedAnchor.yScale = .3;
    _pressedAnchor.hidden = TRUE;
    
    //initialize red anchor
    _anchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_red_left"];
    _anchor.xScale = .3;
    _anchor.yScale = .3;

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

-(NSString *)getGameMode:(int)game_mode
{
    NSString *gameMode;
    if (game_mode == CENTER)
    {
        gameMode = @"center";
    }
    else if (game_mode == RANDOM)
    {
        gameMode = @"random";
    }
    return gameMode;
}

@end
