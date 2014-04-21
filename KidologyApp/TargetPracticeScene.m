//
//  TargetPracticeScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this is the target practice scene for the center and random game modes


#import "TargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "MainMenuScene.h"
#import "math.h"
#import "LogEntry.h"
#import "SetupViewController.h"
#import "UtilityClass.h"

@implementation TargetPracticeScene

NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size game_mode:(int)game_mode
{
    if (self = [super initWithSize:size])
    {
        // initialize class variables
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        self.delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _affectedHand = [defaults objectForKey:@"affectedHand"];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        self.correctTouches = 0;
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;
        self.time = 0;
        
        // play a sound to start the round
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];

        // add images and buttons
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // get the current touch
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
    for (UITouch *touch in [touches allObjects])
    {
        CGPoint positionInScene = [touch locationInNode:self];
        // see if this touch is on the anchor
        if ([self isAnchorTouch:positionInScene])
        {
            _anchored = TOUCHING;
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
            [touchLog addObject:currentTouch];
        }
        else
        {
            // If the touch isn't on the anchor
            [self targetTouch:positionInScene]; // log it inside the targetTouch function and evaluate accordingly.
        }
    }
}

// called when a touch end
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:positionInScene];
        
        // if quit button was pressed
        if ([node.name isEqualToString:@"quitButton"] ||
            [node.name isEqualToString:@"quitButtonPressed"])
        {
            // reset the button
            _quitButton.hidden = false;
            _quitButtonPressed.hidden = true;
            
            // transition to game over scene
            [self endGame:self.correctTouches totalTargets:self.totalTargets];
        }
        else if ([self isAnchorTouch:positionInScene])
        {
            // or if the touch was on the anchor
            _anchored = NOT_TOUCHING;
            _anchor.hidden = FALSE;         
            _pressedAnchor.hidden = TRUE;
            // log when anchor was released
            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Release"
                                                               time:self.time
                                                      anchorPressed:NO
                                                         targetsHit:self.correctTouches
                                                 distanceFromCenter:@"NA"
                                                      touchLocation:CGPointMake(positionInScene.x,  positionInScene.y)
                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                       targetRadius:(self.target.size.width / 2)
                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];

        }
        // else, it's a non-anchor touch and nothing needs done
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        // get the current and previous touch locations
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        SKNode *currentNode = [self nodeAtPoint:currentLocation];
        SKNode *previousNode = [self nodeAtPoint:previousLocation];
        
        // if a touch was off the back button but has moved onto it
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
        // else, it's a non-anchor touch and nothing needs done
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Target and Anchor Logic
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

// check whether the target was touched and log it (either hit and miss)
-(void)targetTouch:(CGPoint)touchLocation
{
    // increment the total number of touches thus far
    _totalTouches++;
    
    // do some math to see if this touch was on the target
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));

    LogEntry *currentTouch;
    
    // see if this touch was on the target
    if (distanceFromCenter <= radius)
    {
        // see if the anchor is currently being held down
        if (_anchored == TOUCHING)
        {
            // if it is, then this is a correct touch
            _correctTouches++;
            
            // add it to the log
            currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                     time:self.time
                                            anchorPressed:YES
                                               targetsHit:self.correctTouches
                                       distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                            touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                           targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                             targetRadius:radius
                                           targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];
            
            // display "Target Hit!" and play a sound
            [self displayTargetHit];
            
            // create an animation sequence to remove the target from the scene and display a new one
            SKAction *deleteTarget = [SKAction runBlock:^{
                self.target.position = CGPointMake(-100,-100);
            }];
            SKAction *wait = [SKAction waitForDuration:self.delayBetweenTargets];
            SKAction *addTarget = [SKAction runBlock:^{
                [self displayTarget];
            }];
            SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
            
            // check to see if the total number of targets have been touched
            if(self.totalTargets == self.correctTouches)
            {
                // transition to the game over scene
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            }
            
            // run the animation sequence
            [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        }
        else // the target was hit but the anchor is not currently being touched
        {
            // add this unanchored touch to the logs
            currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                     time:self.time
                                            anchorPressed:NO
                                               targetsHit:self.correctTouches
                                       distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                            touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                           targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                             targetRadius:radius
                                           targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];
        }
    }
    else
    {
        // the target was not hit, add the touch to the logs
        currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                 time:self.time
                                        anchorPressed:(_anchored == TOUCHING)
                                           targetsHit:self.correctTouches
                                   distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                        touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                       targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                         targetRadius:radius
                                       targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
        [touchLog addObject:currentTouch];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

// called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {
    // update the time tracker to display in the top right corner
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// add the time and number of hits tracker label to the top right corner
-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor yellowColor];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// display the number of hits and elapsed time in the top right corner
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 20;
    timeLabel.fontColor =  [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+265);

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
    self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
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


// adds the target to the scene depending on what the game mode is (center or random)
-(void)displayTarget
{
    if (_gameMode == CENTER)
    {
        // set target to appear in middle of screen
        self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.target.xScale = _targetSize;
        self.target.yScale = _targetSize;
    }
    else if (_gameMode == RANDOM)
    {
        // set the target to appear at random locations and in random sizes
        int min = 7;
        int max = 50;
        float randomScale = ((min + arc4random() % (max-min))) * .01;
        _target.xScale = randomScale;
        _target.yScale = randomScale;
        int x_pos = (.75 * (arc4random_uniform((int)self.size.width)/2) )-(_target.size.width/2);
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
        if (x_pos < _quitButton.position.x + _quitButton.size.width*0.5 + _target.size.width*0.5)
        {
            x_pos = _quitButton.position.x + _quitButton.size.width*0.5 + _target.size.width*0.5;
        }
        int y_pos = (.75 * (arc4random_uniform((int)self.size.height)/2) )-(_target.size.height/2);
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
        if (y_pos > _quitButton.position.x - _quitButton.size.height*0.5 - _target.size.height*0.5)
        {
            y_pos = _quitButton.position.x - _quitButton.size.height*0.5 - _target.size.height*0.5;
        }
        self.target.position = CGPointMake(x_pos, y_pos);
    }
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
        _pressedAnchor.position = CGPointMake(100, self.frame.size.height/2-175);
        
        _anchor.position = CGPointMake(100, self.frame.size.height/2-175);
        
    }
    else    // _affectedHand == "left"
    {
        _pressedAnchor.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2-175);
        
        _anchor.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2-175);
    }
    _pressedAnchor.name =@"pressedAnchor";
    [self addChild:_pressedAnchor];
    
    _anchor.name = @"anchor";
    [self addChild:_anchor];
}

-(void)displayTargetHit
{
    if (_enableSound)
    {
        NSString *soundFile = [UtilityClass getSoundFile];
        [self runAction:[SKAction playSoundFileNamed:soundFile waitForCompletion:NO]];
    }
    NSString * text2 = [NSString stringWithFormat:@"Target Hit! %d More!", self.totalTargets - self.correctTouches];
    SKLabelNode * targetHitLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    targetHitLabel.name = @"instructionLabel2";
    targetHitLabel.text = text2;
    targetHitLabel.fontSize = 24;
    targetHitLabel.fontColor = [SKColor yellowColor];
    targetHitLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 100);
    [self addChild:targetHitLabel];
    CGPoint dest = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    SKAction *fadeAway = [SKAction moveTo:dest duration:1.5];
    SKAction * remove = [SKAction removeFromParent];
    [targetHitLabel runAction:[SKAction sequence:@[fadeAway, remove]]];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Simple Utility Methods
//-------------------------------------------------------------------------------------------------------------------------------------

// convert the int game_mode into a string
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

// transition to the game over scene
-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    NSString *mode = [self getGameMode:_gameMode];
    [gameOverScene.userData setObject:mode forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

@end
