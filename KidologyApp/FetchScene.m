//
//  FetchGame.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/13/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
//  Sounds for this app were obtained at soundbible.com
//
//      License information for sounds in this file:
//          dog bark -- non-commercial use only (http://soundbible.com/393-Puppy-Dog-Barking.html)
//

#import "FetchScene.h"
#import "MainMenuScene.h"
#import "LogEntry.h"
#import "TargetPracticeGameOver.h"

@implementation FetchScene

NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        self.totalTargets = [[defaults objectForKey:@"numberOfTargets"] integerValue];
        self.targetsHit = 0;
        //setup scene
        [self addBackground];
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"tennis"];
        self.dog = [SKSpriteNode spriteNodeWithImageNamed:@"dog"];
        [self displayDog];
        [self addChild:self.dog];
        [self displayBall];
        [self addChild:self.ball];
        [self addInstruction];
        [self addQuitButton];
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];

        // [self addToNotificationCenter];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if([node.name isEqualToString:@"quitButton"] ||
           [node.name isEqualToString:@"pressedQuitButton"])
        {
            _quitButton.hidden = true;
            _quitButtonPressed.hidden = false;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches)
    {
        //get a specific touch
        CGPoint location = [touch locationInNode:self];
        //find the node that is touched
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        //handle the situations of which nodes are touched
        if([_quitButton isEqual:touchedNode] || [_quitButtonPressed isEqual:touchedNode])
        {
            // reset button
            _quitButtonPressed.hidden = true;
            _quitButton.hidden = false;
            
            [self endGame:self.targetsHit totalTargets:self.totalTargets];
        }
        else
        {
            double xDifference = location.x - self.ball.position.x;
            double yDifference = location.y - self.ball.position.y;
            double radius = self.ball.size.width / 2;
            double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));
            
            if([_ball isEqual:touchedNode])
            {

                self.targetsHit++;
                LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Ball"
                                                         time:self.time
                                                anchorPressed:NO
                                                   targetsHit:self.targetsHit
                                           distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                                touchLocation:CGPointMake(location.x, location.y)
                                               targetLocation:CGPointMake(self.ball.position.x, self.ball.position.y)
                                                 targetRadius:radius
                                               targetOnScreen:((self.ball.position.x == self.frame.size.width/2) &&
                                                               (self.ball.position.y == self.frame.size.height/2))];
                [touchLog addObject:currentTouch]; // log the touch
                [self displayTargetHit];
                [self ballTouch];
            }
            else if([_dog isEqual:touchedNode])
            {
                LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Dog"
                                                                   time:self.time
                                                          anchorPressed:NO
                                                             targetsHit:self.targetsHit
                                                     distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                                          touchLocation:CGPointMake(location.x, location.y)
                                                         targetLocation:CGPointMake(self.ball.position.x, self.ball.position.y)
                                                           targetRadius:radius
                                                         targetOnScreen:((self.ball.position.x == self.frame.size.width/2) &&
                                                                         (self.ball.position.y == self.frame.size.height/2))];
                [touchLog addObject:currentTouch]; // log the touch
                [self dogTouch];
            }
            else
            {
                LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Off Target"
                                                                   time:self.time
                                                          anchorPressed:NO
                                                             targetsHit:self.targetsHit
                                                     distanceFromCenter:[NSString stringWithFormat:@"%f", distanceFromCenter]
                                                          touchLocation:CGPointMake(location.x, location.y)
                                                         targetLocation:CGPointMake(self.ball.position.x, self.ball.position.y)
                                                           targetRadius:radius
                                                         targetOnScreen:((self.ball.position.x == self.frame.size.width/2) &&
                                                                         (self.ball.position.y == self.frame.size.height/2))];
                [touchLog addObject:currentTouch]; // log the touch
            }
        }
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

//-(void)willMoveFromView:(SKView *)view
//{
//    [self removeFromNotificationCenter];
//}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"fetch_background.png"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(void)displayBall
{
    self.ball.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    self.ball.xScale = .1;
    self.ball.yScale = .1;
}

-(void)displayDog
{
    self.dog.zRotation = M_PI/6.0f;
    self.dog.xScale = -.13;
    self.dog.yScale = .13;
    self.dog.position = CGPointMake(self.frame.size.width/2 - 200, self.frame.size.height/2-170);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
    if (enableSound)
    {
        [self runAction:[SKAction playSoundFileNamed:@"dog_bark.mp3" waitForCompletion:NO]];
    }
}


-(void)ballTouch
{
    // generate pseudo-random x and y positions to move towards
    int positions[2] = {0,0};
    [self getRandomMovement:positions];
    
    //move ball offscreen
    [self moveBallOffScreen:positions[0] withYPosition:positions[1]];
    //move dog offscreen
    [self moveDogOffScreen:positions[0] withYPosition:positions[1]];
    if (self.targetsHit == self.totalTargets)
        [self endGame:self.targetsHit totalTargets:self.totalTargets];
    
    //move both onscreen
    [self moveBackDogAndBall];
    
}

// generate random direction to move the dog and ball along
-(void) getRandomMovement: (int *)positions
{
    // (0 = left, 1 = up, 2 = right, 3 = down, 4 = upper-left
    //  5 = upper-right, 6 = lower-right, 7 = lower-left)
    // NOTE: will edit this to be a bit more dynamic e.g. can move in all 360 degrees
    int direction = rand() % 8;
    
    int x_pos;
    int y_pos;
    switch (direction)
    {
        case 0:
            x_pos = -5000;
            y_pos = self.frame.size.height/2;
            break;
        case 1:
            x_pos = self.frame.size.width/2;
            y_pos = 5000;
            break;
        case 2:
            x_pos = 5000;
            y_pos = self.frame.size.height/2;
            break;
        case 3:
            x_pos = self.frame.size.width/2;
            y_pos = -5000;
            break;
        case 4:
            x_pos = -5000;
            y_pos = 5000;
            break;
        case 5:
            x_pos = 5000;
            y_pos = 5000;
            break;
        case 6:
            x_pos = 5000;
            y_pos = -5000;
            break;
        default: // case 7:
            x_pos = -5000;
            y_pos = -5000;
            break;
    }
    positions[0] = x_pos;
    positions[1] = y_pos;
}

-(void)dogTouch
{
    
}

-(void)moveBallOffScreen: (CGFloat)x_pos withYPosition:(CGFloat) y_pos
{
    //TODO play ball sound
    //scale ball to smaller size
    SKAction * scale = [SKAction scaleBy:.005 duration:1.25];
    //move ball offscreen
    //SKAction * actionMove = [SKAction moveTo:CGPointMake(-200, self.frame.size.height/2+100) duration:1];
    SKAction * actionMove = [SKAction moveTo:CGPointMake(x_pos, y_pos) duration:1];
    
    SKAction * moveSequence = [SKAction sequence:@[actionMove]];
    [_ball runAction:scale];
    [_ball runAction:moveSequence];
}

-(void)moveDogOffScreen: (CGFloat)x_pos withYPosition:(CGFloat) y_pos
{
    
    //wait for ball to move offscreen
    SKAction *wait = [SKAction waitForDuration:1.0];
    
    //the dog barks as it chases the ball
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
    
    SKAction * bark = [SKAction playSoundFileNamed:@"dog_bark.mp3" waitForCompletion:NO];
    SKAction * barkSeq = [SKAction sequence:@[wait, bark]];
    
    if (enableSound)
    {
        [self runAction:barkSeq];
    }
    
    //TODO play dog sound
    //move dog offscreen
    // SKAction *move = [SKAction moveTo:CGPointMake(-500, _dog.size.height) duration:.5];
     SKAction *move = [SKAction moveTo:CGPointMake(x_pos, y_pos) duration:1.5];
    
    SKAction * seq = [SKAction sequence:@[wait, move]];
    [_dog runAction:seq];
    


}

-(void)moveBackDogAndBall
{
    
    //bring back dog
    //wait a bit
    SKAction * wait = [SKAction waitForDuration:2.0];
    SKAction * wait2 = [SKAction waitForDuration:1.0];
    //move back dog
    SKAction * moveDog = [SKAction moveTo:CGPointMake(self.frame.size.width/2 - 200, self.frame.size.height/2-170) duration:1];
    //replace ball
    SKAction * ballReappear = [SKAction runBlock:^{ [self displayBall]; }];
    SKAction *sequ = [SKAction sequence:@[wait, moveDog, wait2, ballReappear]];
    [_dog runAction:sequ];
}

-(void)goToMainScreen
{
    //weak self to deallocate the scene
    __weak typeof(self) weakSelf = self;
    //create the scene
    SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:weakSelf.size];
    //transition
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    mainMenu.scaleMode = SKSceneScaleModeAspectFill;
    //present the scene
    [weakSelf.view presentScene:mainMenu transition:reveal];
}

-(void)addInstruction
{
    NSString * text2 = [NSString stringWithFormat:@"Touch the ball to throw it!"];
    SKLabelNode * instructionLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel2.name = @"instructionLabel2";
    instructionLabel2.text = text2;
    instructionLabel2.fontSize = 36;
    instructionLabel2.fontColor = [SKColor whiteColor];
    instructionLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+150);
    [self addChild:instructionLabel2];
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration:4];
    [instructionLabel2 runAction:fadeAway];
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
    timeLabel.fontColor = [SKColor whiteColor]; //[SKColor colorWithRed:0.96 green:0.79 blue:0.39 alpha:1];
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

-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _targetsHit, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor =  [SKColor whiteColor]; //[SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
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
    [gameOverScene.userData setObject:@"fetch" forKey:@"gameMode"];
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

-(void)displayTargetHit
{
    NSString * text2 = [NSString stringWithFormat:@"Hit! %d More!", self.totalTargets - self.targetsHit];
    SKLabelNode * targetHitLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    targetHitLabel.name = @"instructionLabel2";
    targetHitLabel.text = text2;
    targetHitLabel.fontSize = 24;
    targetHitLabel.fontColor = [SKColor whiteColor];
    targetHitLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 100);
    [self addChild:targetHitLabel];
    CGPoint dest = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    SKAction *fadeAway = [SKAction moveTo:dest duration:1.5];
    SKAction * remove = [SKAction removeFromParent];
    [targetHitLabel runAction:[SKAction sequence:@[fadeAway, remove]]];
}

//-(void)addToNotificationCenter
//{
//    NSLog(@"adding fetch scene to notification center");
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appMovedBackground:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//}
//
//-(void)removeFromNotificationCenter
//{
//    NSLog(@"removing fetch scene from notification center");
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIApplicationDidEnterBackgroundNotification
//                                                  object:nil];
//}
//
//-(void)appMovedBackground:(NSNotification *)notification
//{
//    [self goToMainScreen];
//}

@end
