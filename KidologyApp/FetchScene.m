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

// this class is the scene for playing the dog fetch game

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

    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        // if the quit button was pressed
        if([node.name isEqualToString:@"quitButton"] ||
           [node.name isEqualToString:@"pressedQuitButton"])
        {
            // update its image
            _quitButton.hidden = true;
            _quitButtonPressed.hidden = false;
        }
    }
}

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        //find the node that is touched
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        // determine which button was pressed (if any)
        if([_quitButton isEqual:touchedNode] || [_quitButtonPressed isEqual:touchedNode])
        {
            // reset button
            _quitButtonPressed.hidden = true;
            _quitButton.hidden = false;
            
            // transition to game over scene
            [self endGame:self.targetsHit totalTargets:self.totalTargets];
        }
        else
        {
            // might have been a "hit" (tap on the baseball)
            double xDifference = location.x - self.ball.position.x;
            double yDifference = location.y - self.ball.position.y;
            double radius = self.ball.size.width / 2;
            double distanceFromCenter = sqrt(pow(xDifference, 2) + pow(yDifference, 2));
            
            if([_ball isEqual:touchedNode])
            {
                // it is a "hit"
                self.targetsHit++;
                // add it to the log
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
                [touchLog addObject:currentTouch];
                // animate the ball and dog moving off screen and then back again
                [self displayTargetHit];
                [self ballTouch];
            }
            else if([_dog isEqual:touchedNode])
            {
                // touch was on the dog, make a log of it (maybe the kid just likes tapping the dog... idk?)
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
                [touchLog addObject:currentTouch];
                [self dogTouch];
            }
            else
            {
                // touch was neither on the ball nor on the dog
                // log the miss
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
                [touchLog addObject:currentTouch];
            }
        }
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Dog and Ball Animations
//-------------------------------------------------------------------------------------------------------------------------------------

// move the ball to a random position and have the dog follow
-(void)ballTouch
{
    // generate pseudo-random x and y positions to move towards
    int positions[2] = {0,0};
    [self getRandomMovement:positions];
    
    // move ball offscreen
    [self moveBallOffScreen:positions[0] withYPosition:positions[1]];
    // move dog offscreen
    [self moveDogOffScreen:positions[0] withYPosition:positions[1]];
    // if they have hit all the required targets, transition to game over scene
    if (self.targetsHit == self.totalTargets)
        [self endGame:self.targetsHit totalTargets:self.totalTargets];
    
    // move both onscreen
    [self moveBackDogAndBall];
}

// generate random direction to move the dog and ball along
-(void) getRandomMovement: (int *)positions
{
    // (0 = left, 1 = up, 2 = right, 3 = down, 4 = upper-left
    //  5 = upper-right, 6 = lower-right, 7 = lower-left)
    int direction = arc4random_uniform(8);
    
    int x_pos;
    int y_pos;
    switch (direction)
    {
        case 0: // left
            x_pos = -5000;
            y_pos = self.frame.size.height/2;
            break;
        case 1: // up
            x_pos = self.frame.size.width/2;
            y_pos = 5000;
            break;
        case 2: // right
            x_pos = 5000;
            y_pos = self.frame.size.height/2;
            break;
        case 3: // down
            x_pos = self.frame.size.width/2;
            y_pos = -5000;
            break;
        case 4: // upper-left
            x_pos = -5000;
            y_pos = 5000;
            break;
        case 5: // upper-right
            x_pos = 5000;
            y_pos = 5000;
            break;
        case 6: // lower-right
            x_pos = 5000;
            y_pos = -5000;
            break;
        default: // case 7: lower-left
            x_pos = -5000;
            y_pos = -5000;
            break;
    }
    positions[0] = x_pos;
    positions[1] = y_pos;
}

-(void)dogTouch
{
    // for later: maybe make new noise when dog is tapped, has the potential for extreme noise-making by children
}

// move the ball off the screen to the given coordinates
-(void)moveBallOffScreen: (CGFloat)x_pos withYPosition:(CGFloat) y_pos
{
    //scale ball to smaller size
    SKAction * scale = [SKAction scaleBy:.005 duration:1.25];
    //move ball offscreen
    SKAction * actionMove = [SKAction moveTo:CGPointMake(x_pos, y_pos) duration:1];
    SKAction * moveSequence = [SKAction sequence:@[actionMove]];
    [_ball runAction:scale];
    [_ball runAction:moveSequence];
}

// move the dog offscreen to the given coordinates
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
        // play the barking sound
        [self runAction:barkSeq];
    }
    
    //move dog offscreen
     SKAction *move = [SKAction moveTo:CGPointMake(x_pos, y_pos) duration:1.5];
    SKAction * seq = [SKAction sequence:@[wait, move]];
    [_dog runAction:seq];
}

// move the dog and ball back onto the screen
-(void)moveBackDogAndBall
{
    // create some wait sequences to intersperse between the dog and ball movements
    SKAction * wait = [SKAction waitForDuration:2.0];
    SKAction * wait2 = [SKAction waitForDuration:1.0];
    //move back dog
    SKAction * moveDog = [SKAction moveTo:CGPointMake(self.frame.size.width/2 - 200, self.frame.size.height/2-170) duration:1];
    //replace ball
    SKAction * ballReappear = [SKAction runBlock:^{ [self displayBall]; }];
    SKAction *sequ = [SKAction sequence:@[wait, moveDog, wait2, ballReappear]];
    [_dog runAction:sequ];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

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

// called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// add a label to the top right corner saying how much time has elapsed
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .1) {
        self.lastSpawnTimeInterval = 0;
        self.time +=.1;
    }
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timeLabel.fontSize = 20;
    timeLabel.fontColor = [SKColor whiteColor];
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

// add a label to the top right corner saying how many correct hits and how many total targets to hit
-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _targetsHit, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor =  [SKColor whiteColor];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+220);
    [self addChild:trackerLabel];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:trackerLabel.position duration:.0075];
    [trackerLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
}

// display a message saying "Target Hit!" and play a sound
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

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Simple Utility Methods
//-------------------------------------------------------------------------------------------------------------------------------------

// transition to the game over scene
-(void)endGame:(int)targetsHit totalTargets:(int)totalTargets
{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targetsHit:targetsHit totalTargets:totalTargets];
    // pass the game type and touch log to "game over" scene
    [gameOverScene.userData setObject:@"fetch" forKey:@"gameMode"];
    NSLog(@"set game mode %@", [gameOverScene.userData objectForKey:@"gameMode"]);
    [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
    [self.view presentScene:gameOverScene transition:reveal];
}

@end
