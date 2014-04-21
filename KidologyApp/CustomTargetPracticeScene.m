//
//  CustomTargetPracticeScene.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 3/19/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this class reads in from a custom game file and generates a target practice scene

#import "CustomTargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "TargetPracticeMenuScene.h"
#import "LogEntry.h"
#import "SetupViewController.h"
#import "UtilityClass.h"

extern NSString *gameName;
extern NSUserDefaults *defaults;
@implementation CustomTargetPracticeScene
NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        // initialize variables and read in from game file
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        [self readInput];
        //assign total number of targets
        _totalTargets = [_commandArray count] - 1;
        //initialize targetIterator to start reading from the correct part of array
        _targetIterator = 1;
        _time = 0;
        
        [self addBackground];
        //initialize and display target with image
        _target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        [self displayTarget];
        [self addChild:_target];
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;
        [self initializeAnchor];
        [self addQuitButton];
        
        // play a sound to start the round
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];

    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        //test whether the target has been touched
        // if the touch isn't on the anchor
        if (![self isAnchorTouch:positionInScene])
        {
            // log it inside the targetTouch function and evaluate accordingly
            [self targetTouch:positionInScene];
        }
        else
        {
            // if it is on the anchor
            _anchored = TOUCHING; // make note of that.
            _anchor.hidden = TRUE;
            _pressedAnchor.hidden = FALSE;
            // log when anchor is first pressed (rather than every frame where anchor is held)
            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Press"
                                                               time:self.time
                                                      anchorPressed:YES
                                                         targetsHit:self.correctTouches
                                                 distanceFromCenter:@"NA"
                                                      touchLocation:CGPointMake(positionInScene.x, positionInScene.y)
                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                       targetRadius:(self.target.size.width/2)
                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];
        }
    }
}

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:positionInScene];
        // check if the quit button was pressed and released
        if ([node.name isEqualToString:@"quitButton"] ||
            [node.name isEqualToString:@"quitButtonPressed"])
        {
            // reset the button
            _quitButton.hidden = false;
            _quitButtonPressed.hidden = true;
            
            // transition to the game over scene
            [self endGame:self.correctTouches totalTargets:self.totalTargets];
        }
        else if ([self isAnchorTouch:positionInScene] == true)
        {
            // if a touch on the anchor is ending
            _anchored = NOT_TOUCHING; // make note of that.
            _anchor.hidden = FALSE;
            _pressedAnchor.hidden = TRUE;
            
            // log when anchor was released
            LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Anchor Release"
                                                               time:self.time
                                                      anchorPressed:YES
                                                         targetsHit:self.correctTouches
                                                 distanceFromCenter:@"NA"
                                                      touchLocation:CGPointMake(positionInScene.x, positionInScene.y)
                                                     targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                       targetRadius:(self.target.size.width/2)
                                                     targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];
        }
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Target and Anchor Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// this method handles touches that are not on the anchor
// (e.g. both target hits and misses) and logs accordingly
-(void)targetTouch:(CGPoint)touchLocation
{
    _totalTouches++;
    // do some math to see if the touch was on the target
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));
    
    LogEntry * currentTouch;
    
    // if the touch was on the target
    if (distanceFromCenter <= radius)
    {
        // the anchor is currently being touched
        if (_anchored == TOUCHING)
        {
            // this is a target hit
            _correctTouches++;
            // add this touch to the logs
            currentTouch = [[LogEntry alloc] initWithType:@"On Target"
                                                     time:self.time
                                            anchorPressed:YES
                                               targetsHit:self.correctTouches
                                       distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                            touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                           targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                             targetRadius:radius
                                           targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
            [touchLog addObject:currentTouch];
            
            // display a "Target Hit!" message and play a sound
            [self displayTargetHit];
            
            // create a transition sequence to remove the target and display a new one
            SKAction *deleteTarget = [SKAction runBlock:^{
                self.target.position = CGPointMake(-100,-100);
            }];
            SKAction *wait = [SKAction waitForDuration:_delayDuration];
            SKAction *addTarget = [SKAction runBlock:^{
                [self displayTarget];
            }];
            SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
            
            //check to see if the total number of targets have been touched
            if(self.totalTargets <= self.correctTouches)
            {
                // transition to the game over scene
                [self endGame:self.correctTouches totalTargets:self.totalTargets];
            }
            
            //increment the targetIterator
            _targetIterator = _targetIterator + 1;
            //run the actions in sequential order
            [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
            
        }
        else
        {
            // the touch was on the target but the anchor was not being pressed
            currentTouch = [[LogEntry alloc] initWithType:@"On Target"
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
        // the touch was not on the target
        currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                 time:self.time
                                        anchorPressed:(_anchored == TOUCHING)
                                           targetsHit:self.correctTouches
                                   distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                        touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                       targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                         targetRadius:(self.target.size.width / 2)
                                       targetOnScreen:!(_target.position.x == -100 && _target.position.y == -100)];
        [touchLog addObject:currentTouch];
    }
}

// this method determines if the touch was on the anchor
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

// this method determines where and how to display the target depending on the values in the command array
-(void)displayTarget
{
    //get the target information
    NSString *targetInfoString = _commandArray[_targetIterator];
    //array of size 3 where [0] = X position [1] = Y position [2] = scale of target
    NSArray *targetInfoArray = [targetInfoString componentsSeparatedByString:@","];
    //set position based and scale on the values
    _target.xScale = [targetInfoArray[2] floatValue];
    _target.yScale = [targetInfoArray[2] floatValue];
    _target.position = CGPointMake([targetInfoArray[0] floatValue], [targetInfoArray[1] floatValue]);
    if(!([targetInfoArray[3] isEqualToString:@""]))
    {
        _delayDuration = [targetInfoArray[3] floatValue];
    }
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
    _quitButton.position = CGPointMake(120, self.frame.size.height - 80);
    _quitButton.name = @"quitButton";
    _quitButton.xScale = .5;
    _quitButton.yScale = .5;
    [self addChild:_quitButton];
    
    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
    _quitButtonPressed.position = CGPointMake(120, self.frame.size.height - 80);
    _quitButtonPressed.name = @"quitButtonPressed";
    _quitButtonPressed.hidden = true;
    _quitButtonPressed.xScale = .5;
    _quitButtonPressed.yScale = .5;
    [self addChild:_quitButtonPressed];
}

// called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {
    // update the time counter
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// adds a label to the top right corner indicating correct touches and total touches
-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 28;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 89);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// adds a label to the top right corner indicatin time elapsed
-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 28;
    timeLabel.fontColor = [SKColor yellowColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 30);
    
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

// reads in where to display the anchor from the user settings
-(void)initializeAnchor
{
    //get handedness from the user defaults
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *affectedHand = [defaults objectForKey:@"affectedHand"];
    _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];

    //initialize green anchor
    _pressedAnchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_green_left"];
    _pressedAnchor.xScale = .4;
    _pressedAnchor.yScale = .4;
    _pressedAnchor.hidden = TRUE;
    
    //initialize red anchor
    _anchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_red_left"];
    _anchor.xScale = .4;
    _anchor.yScale = .4;
    
    if([affectedHand isEqualToString:@"right"]) //if right hand affected
    {
        _pressedAnchor.position = CGPointMake(100, self.frame.size.height/2-175);
        _anchor.position = CGPointMake(100, self.frame.size.height/2-175);
    }
    else    //if right hand not affected
    {
        _pressedAnchor.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2-175);
        _anchor.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2-175);
    }
    _pressedAnchor.name =@"pressedAnchor";
    [self addChild:_pressedAnchor];
    
    _anchor.name = @"anchor";
    [self addChild:_anchor];
}

// displays a message saying "Target Hit!" and plays a sound
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

// this method reads in from the custom game file and adds to the command array (stores the various target info)
-(void)readInput
{
    NSString *shortenedGameName = [gameName substringToIndex:[gameName length] - 4];
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
    NSString *filePath = [folderPath stringByAppendingString:@"/"];
    filePath = [filePath stringByAppendingString:shortenedGameName];// add the filename
    filePath = [filePath stringByAppendingString:@".csv"]; // add the .csv extension
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if(error)
    {
        NSLog(@"error %@", error.localizedDescription);
    }
    
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"\n" withString:@";"];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"\r" withString:@";"];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@";;" withString:@";"];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@";;;" withString:@";"];
    _commandArray = [fileContents componentsSeparatedByString:@";"];
}

// this method transitions to the game over scene
-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    NSString *mode = @"custom";
    [gameOverScene.userData setObject:mode forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}
@end
