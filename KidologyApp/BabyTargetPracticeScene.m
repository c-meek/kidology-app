//
//  BabyTargetPracticeScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
//  Sounds for this app were obtained at soundbible.com
//
//      License information for sounds in this file:
//          target "popping" noise -- Creative Commons Attribution 3.0 (http://soundbible.com/533-Pop-Cork.html )
//          dog bark -- non-commercial use only (http://soundbible.com/393-Puppy-Dog-Barking.html )
//          rooster -- Creative Commons Attribution 3.0 (http://soundbible.com/2040-Rooster-Crowing-2.html )
//          horse -- Creative Commons Attribution 3.0 (http://soundbible.com/1296-Horse-Neigh.html )
//          bubbles -- Creative Commons Attribution 3.0 (http://soundbible.com/1137-Bubbles.html )


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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        _delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        _totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        NSLog(@"target size is %f", _targetSize);
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];

        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"dingding.mp3" waitForCompletion:NO]];
        
        self.targetsHit = 0;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in [touches allObjects])
    {
        CGPoint position = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:position];
        [self targetTouch:position];
        if ([node.name isEqualToString:@"quitButton"] || [node.name isEqualToString:@"quitButtonPressed"])
        {
            _quitButton.hidden = true;
            _quitButtonPressed.hidden = false;
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
    
    if ([node.name isEqualToString:@"quitButton"] || [node.name isEqualToString:@"quitButtonPressed"])
    {
        // reset button
        _quitButtonPressed.hidden = true;
        _quitButton.hidden = false;
        
        [self endGame:self.targetsHit totalTargets:self.totalTargets];
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    //    NSLog(@"%@", touchLog);
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 20;
    timeLabel.fontColor = [SKColor yellowColor]; //  [SKColor colorWithRed:0.96 green:0.79 blue:0.39 alpha:1];
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

-(void)targetTouch:(CGPoint)touchLocation
{
    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2*.8385; //<--- The percentage of the radius that is the circle
    double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));

//    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
//    double rightHandSide = pow(radius, 2);
    
//    if(leftHandSide <= rightHandSide) // If the touch is on the target
    if (distanceFromCenter <= radius)
    {
        self.targetsHit ++;
        SKAction *deleteTarget = [SKAction runBlock:^{
            // play a popping noise as the target is dismissed
//            if (_enableSound)
//            {
//                [self runAction:[SKAction playSoundFileNamed:@"pop.mp3" waitForCompletion:NO]];
//            }
            // dismiss the target
            [self hideTarget];
        }];
        
        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Target"
                                                 time:self.time
                                        anchorPressed:NO
                                           targetsHit:self.targetsHit
                                   distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                        touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                       targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                         targetRadius:radius
                                       targetOnScreen:true];
        [touchLog addObject:currentTouch]; // log the touch
        [self displayTargetHit];
        // check to see if the total number of targets have been touched, then show the ending screen
        if(self.targetsHit == self.totalTargets)
        {
            [self endGame:self.targetsHit totalTargets:self.totalTargets];
        }
        //make a wait action
                SKAction *wait = [SKAction waitForDuration:_delayBetweenTargets];
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        BOOL enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        
//        if (enableSound)
//        {
//            [self runAction:[SKAction playSoundFileNamed:@"bubbles.mp3" waitForCompletion:NO]];
            //select a random number [0...4] to choose a random sound to play
//            int r = arc4random() % 4;
//            switch (r) {
//                case 0:
//                    [self runAction:[SKAction playSoundFileNamed:@"dog_bark.mp3" waitForCompletion:NO]];
//                    break;
//                case 1:
//                    [self runAction:[SKAction playSoundFileNamed:@"rooster.mp3" waitForCompletion:NO]];
//                    break;
//                case 2:
//                    [self runAction:[SKAction playSoundFileNamed:@"horse.mp3" waitForCompletion:NO]];
//                    break;
//                case 3:
//                    [self runAction:[SKAction playSoundFileNamed:@"bubbles.mp3" waitForCompletion:NO]];
//                    break;
//                default:
//                    [self runAction:[SKAction playSoundFileNamed:@"horse.mp3" waitForCompletion:NO]];
//                    break;
//            }
//        }
        
//        if (_totalTouches > 5) {
//            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
//            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
//            
//            // Present the scene.
//            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
//            [self.view presentScene:mainMenu transition:reveal];
//        }
    }
    else
    {
        // missed the target
        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                           time:self.time
                                                  anchorPressed:NO
                                                     targetsHit:self.targetsHit
                                             distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                                  touchLocation:CGPointMake(touchLocation.x, touchLocation.y)
                                                 targetLocation:CGPointMake(self.target.position.x, self.target.position.y)
                                                   targetRadius:radius
                                                 targetOnScreen:true];
        [touchLog addObject:currentTouch]; // log the touch
    }
}



-(void)displayTarget
{
    self.target.position = CGPointMake(self.size.width/2, self.size.height/2);
}

-(void)hideTarget
{
    self.target.position = CGPointMake(self.size.width/2*(-1), self.size.height/2*(-1));
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

-(void)addInstruction
{
    NSString * text2 = [NSString stringWithFormat:@"Hit %d Targets!", self.totalTargets];
    SKLabelNode * instructionLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel2.name = @"instructionLabel2";
    instructionLabel2.text = text2;
    instructionLabel2.fontSize = 36;
    instructionLabel2.fontColor = [SKColor yellowColor];
    instructionLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+150);
    [self addChild:instructionLabel2];
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration:4];
    [instructionLabel2 runAction:fadeAway];
}

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
    targetHitLabel.fontSize = 24;
    targetHitLabel.fontColor = [SKColor yellowColor];
    targetHitLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 100);
    [self addChild:targetHitLabel];
    CGPoint dest = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    SKAction *fadeAway = [SKAction moveTo:dest duration:1.5];
    SKAction * remove = [SKAction removeFromParent];
    [targetHitLabel runAction:[SKAction sequence:@[fadeAway, remove]]];
}

-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _targetsHit, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor yellowColor];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}


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
