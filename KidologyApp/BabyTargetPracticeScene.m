//
//  BabyTargetPracticeScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
//  Sounds for this app were obtained at soundbible.com


// this scene is the baby game scene, where a large, brightly-colored target is displayed center screen
// against a checkerboard background

#import "BabyTargetPracticeScene.h"
#import "MainMenuScene.h"
#import "LogEntry.h"
#import "TargetPracticeGameOver.h"
#import "UtilityClass.h"

@implementation BabyTargetPracticeScene

NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size color:(NSString *)color
{
    if (self = [super initWithSize:size])
    {
        // read in user defaults from the settings app
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        _delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        _totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];

        // play a sound to start the round
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];
        
        // initialize the touchLog array and the number of targets hit counter
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        self.targetsHit = 0;
        
        // add the background, target, instruction label and quit button
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Huge_Checkered_Background_[4096x3072]"];
        [self addChild:bgImage];
        _target = [SKSpriteNode spriteNodeWithImageNamed:color];
        _target.xScale = _targetSize;
        _target.yScale = _targetSize;
        _target.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_target];
        [self addInstruction];
        [self addQuitButton];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in [touches allObjects])
    {
        // get the current touch and see if it is on the quit button
        CGPoint position = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:position];
        if ([node.name isEqualToString:@"quitButton"] ||
            [node.name isEqualToString:@"quitButtonPressed"])
        {
            // update the quit button image
            _quitButton.hidden = true;
            _quitButtonPressed.hidden = false;
        }
        else
        {
            [self targetTouch:position];
        }
    }
}

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // see if the quit button was pressed and then released
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    if ([node.name isEqualToString:@"quitButton"] ||
        [node.name isEqualToString:@"quitButtonPressed"])
    {
        // reset button
        _quitButtonPressed.hidden = true;
        _quitButton.hidden = false;
        
        // move to the game over scene
        [self endGame:self.targetsHit totalTargets:self.totalTargets];
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        // get the current and previous position of the touch
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        
        // see what nodes(if any) were at those positions
        SKSpriteNode * currentNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
        SKSpriteNode * previousNode = (SKSpriteNode *)[self nodeAtPoint:previousLocation];
        
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

// this method is called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {
    // update the scene's time counter (displayed in top right corner)
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// this method is called by update and displays the time counter in the top right corner
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    // update the time counter
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    
    // initialize the text label showing the time
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 28;
    timeLabel.fontColor = [SKColor yellowColor]; //  [SKColor colorWithRed:0.96 green:0.79 blue:0.39 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height-30);
    
    //label for ratio of touched/total targets
    [self trackerLabel];
 
    float r_time = roundf(self.time *100)/100.0;
    NSString *s_time = [NSString stringWithFormat: @"%.1f", r_time];
    timeLabel.text = s_time;
    [self addChild: timeLabel];
    
    // sequence together the transitions to remove the current time label and add the updated one
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.0075];
    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// called when a touch begins to see if it was on the target
-(void)targetTouch:(CGPoint)touchLocation
{
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2*.8385; //<--- The percentage of the radius that is the circle
    double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));

    // check if the touch is on the target
    if (distanceFromCenter <= radius)
    {
        self.targetsHit ++;
        SKAction *deleteTarget = [SKAction runBlock:^{
            // dismiss the target
            [self hideTarget];
        }];
        
        // add this target hit touch to the logs
        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                 time:self.time
                                        anchorPressed:NO
                                           targetsHit:self.targetsHit
                                   distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                        touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                       targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                         targetRadius:radius
                                       targetOnScreen:true];
        [touchLog addObject:currentTouch];
        
        // display "Target Hit!" and play a sound
        [self displayTargetHit];
        
        // check to see if the total number of targets have been touched
        if(self.targetsHit == self.totalTargets)
        {
            // show the game over screen
            [self endGame:self.targetsHit totalTargets:self.totalTargets];
        }
        
        // create a transition to display another target
        SKAction *wait = [SKAction waitForDuration:_delayBetweenTargets];
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
    }
    else
    {
        // log that a touch missed the target
        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                           time:self.time
                                                  anchorPressed:NO
                                                     targetsHit:self.targetsHit
                                             distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                                  touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                                 targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                   targetRadius:radius
                                                 targetOnScreen:true];
        [touchLog addObject:currentTouch];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

// move the target button to the middle of the screen
-(void)displayTarget
{
    self.target.position = CGPointMake(self.size.width/2, self.size.height/2);
}

// move the target button off the screen
-(void)hideTarget
{
    self.target.position = CGPointMake(self.size.width/2*(-1), self.size.height/2*(-1));
}

// add the quit button to the top left corner
-(void)addQuitButton
{
    _quitButton = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button"];
    _quitButton.position = CGPointMake(100, self.frame.size.height-65);
    _quitButton.name = @"quitButton";
    _quitButton.xScale = .5;
    _quitButton.yScale = .5;
    [self addChild:_quitButton];
    
    _quitButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Quit_Button_Pressed"];
    _quitButtonPressed.position = CGPointMake(100, self.frame.size.height-65);
    _quitButtonPressed.name = @"quitButtonPressed";
    _quitButtonPressed.hidden = true;
    _quitButtonPressed.xScale = .5;
    _quitButtonPressed.yScale = .5;
    [self addChild:_quitButtonPressed];
}

// add an instruction label that appears for a short while at the beginning of the game
-(void)addInstruction
{
    NSString * text2 = [NSString stringWithFormat:@"Hit %d Targets!", self.totalTargets];
    SKLabelNode * instructionLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel2.name = @"instructionLabel2";
    instructionLabel2.text = text2;
    instructionLabel2.fontSize = 36;
    instructionLabel2.fontColor = [SKColor yellowColor];
    instructionLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-120);
    [self addChild:instructionLabel2];
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration:4];
    [instructionLabel2 runAction:fadeAway];
}

// display a label saying "Target Hit!" and play a sound after a target is hit
-(void)displayTargetHit
{
    if (_enableSound)
    {
        NSString *soundFile = [UtilityClass getSoundFile];
        [self runAction:[SKAction playSoundFileNamed:soundFile waitForCompletion:NO]];
    }
    NSString * text2 = [NSString stringWithFormat:@"Target Hit! %d More!", self.totalTargets - self.targetsHit];
    SKLabelNode * targetHitLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    targetHitLabel.name = @"instructionLabel2";
    targetHitLabel.text = text2;
    targetHitLabel.fontSize = 28;
    targetHitLabel.fontColor = [SKColor yellowColor];
    targetHitLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 150);
    [self addChild:targetHitLabel];
    CGPoint dest = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 90);
    SKAction *fadeAway = [SKAction moveTo:dest duration:1.5];
    SKAction * remove = [SKAction removeFromParent];
    [targetHitLabel runAction:[SKAction sequence:@[fadeAway, remove]]];
}

// create the label tracking the number of target hits and how many total
-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 28;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _targetsHit, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor yellowColor];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height-90);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// called when ready to transition to the game over scene
-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    NSLog(@"end game has touch log count %d", touchLog.count);
    [gameOverScene.userData setObject:@"baby" forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

@end
