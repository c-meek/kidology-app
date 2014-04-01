//
//  CustomTargetPracticeScene.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 3/19/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "CustomTargetPracticeScene.h"
#import "TargetPracticeGameOver.h"
#import "TargetPracticeMenuScene.h"
#import "LogEntry.h"
extern NSString *gameName;
@implementation CustomTargetPracticeScene
NSMutableArray *touchLog;
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        NSLog(@"%@", gameName);
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        [self addBackground];
        //read input from custom text file
        [self readInput];
        //assign total number of targets
        _totalTargets = [_commandArray count] - 1;
        //assign delay duration between touched targets
        _delayDuration = [_commandArray[0] floatValue];
        //initialize targetIterator to start reading from the correct part of array
        _targetIterator = 1;
        //initialize target with image
        _target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        //display the first target
        [self displayTarget];
        [self addChild:_target];
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;
        [self initializeAnchor];
        _time = 0;
    }
    return self;
}

-(void)displayTarget
{
    //get the target information
    NSString *targetInfoString = _commandArray[_targetIterator];
    //array of size 3 where [0] = X position [1] = Y position [2] = scale of target
    NSArray *targetInfoArray = [targetInfoString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //set position based and scale on the values
    _target.xScale = [targetInfoArray[2] floatValue];
    _target.yScale = [targetInfoArray[2] floatValue];
    _target.position = CGPointMake([targetInfoArray[0] floatValue], [targetInfoArray[1] floatValue]);
}

-(void)readInput
{
    NSString *shortenedGameName = [gameName substringToIndex:[gameName length] - 4];
    NSLog(@"%@", shortenedGameName);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:shortenedGameName ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        NSLog(@"erorr %@", error.localizedDescription);
    }
    _commandArray = [fileContents componentsSeparatedByString:@"\n"];


}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(Boolean)isAnchorTouch:(CGPoint)touchLocation
{
    Boolean result;
    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    SKNode *node = [self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"pressedAnchor"] || [node.name isEqualToString:@"anchor"])
    {
        LogEntry *currentTouch = [[LogEntry alloc] initWithType:@"Panel" time:self.time touchLocation:CGPointMake(touchLocation.x, touchLocation.y) targetLocation:CGPointMake(self.target.position.x, self.target.position.y) targetRadius:(self.target.size.width/2)];
        [touchLog addObject:currentTouch];
        //        NSLog(@"anchor panel is being touched.");
        result = true;
    }
    else
    {
        //        NSLog(@"anchor panel is not being touched.");
        result = false;
    }
    return result;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //test whether the target has been touched
    for (UITouch *touch in [touches allObjects]) {
        /* Called when a touch begins */
        CGPoint positionInScene = [touch locationInNode:self];
        //test whether the target has been touched
        if ([self isAnchorTouch:positionInScene] == false) // If the touch isn't on the anchor,
        {
            [self targetTouch:positionInScene]; // log it inside the targetTouch function and evaluate accordingly.
        }
        else{ // If it is on the anchor,
            _anchored = TOUCHING; // make note of that.
            _anchor.hidden = TRUE;
            _pressedAnchor.hidden = FALSE;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    for (UITouch *touch in [touches allObjects]) {
        CGPoint positionInScene = [touch locationInNode:self];
        if ([self isAnchorTouch:positionInScene] == true) // If a touch on the anchor is ending,
        {
            _anchored = NOT_TOUCHING; // make note of that.
            _anchor.hidden = FALSE;         // Tien was here and the next line
            _pressedAnchor.hidden = TRUE;
        }
        else
        {
            _anchor.hidden = FALSE;
            _pressedAnchor.hidden = TRUE;
        }
    }
}

-(void)targetTouch:(CGPoint)touchLocation
{
    _totalTouches++;
    //    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    double xDifference = touchLocation.x - self.target.position.x;
    double yDifference = touchLocation.y - self.target.position.y;
    double radius = self.target.size.width / 2;
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    LogEntry * currentTouch;
    
    if(leftHandSide <= rightHandSide) // If the touch is on the target
    {
        if (_anchored == TOUCHING) // the anchor is currently being touched
        {
            currentTouch = [[LogEntry alloc] initWithType:@"Target" time:self.time touchLocation:CGPointMake(touchLocation.x, touchLocation.y) targetLocation:CGPointMake(self.target.position.x, self.target.position.y) targetRadius:radius];
            //currentTouch.type = TARGET;
            _correctTouches++;
            //make a "delete" target action
            SKAction *deleteTarget = [SKAction runBlock:^{
                self.target.position = CGPointMake(-100,-100);
            }];
            //make a wait action
            SKAction *wait = [SKAction waitForDuration:_delayDuration];
            //make a "add" target action
            SKAction *addTarget = [SKAction runBlock:^{
                [self displayTarget];
            }];
            //check to see if the total number of targets have been touched, then show the ending screen
            if(self.totalTargets <= self.correctTouches)
            {
                SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
                SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targets:self.totalTargets];
                // pass the game type and touch log to the "game over" scene
                NSString *mode = @"custom";
                [gameOverScene.userData setObject:mode forKey:@"gameMode"];
                [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
                [self.view presentScene:gameOverScene transition: reveal];
            }
            //combine all the actions into a sequence
            SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
            //increment the targetIterator
            _targetIterator = _targetIterator + 1;
            //run the actions in sequential order
            [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
            [touchLog addObject:currentTouch]; // log the touch

        }
        else // the anchor is not currently being touched
        {
            currentTouch = [[LogEntry alloc] initWithType:@"Unanchored target" time:self.time touchLocation:CGPointMake(touchLocation.x, touchLocation.y) targetLocation:CGPointMake(self.target.position.x, self.target.position.y) targetRadius:radius];
            //currentTouch.type = UNANCHORED_TARGET;
            [touchLog addObject:currentTouch]; // log the touch
        }
    }
    else
    {
        currentTouch = [[LogEntry alloc] initWithType:@"Whitespace" time:self.time touchLocation:CGPointMake(touchLocation.x, touchLocation.y) targetLocation:CGPointMake(self.target.position.x, self.target.position.y) targetRadius:(self.target.size.width / 2)];
        [touchLog addObject:currentTouch];
    }

    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
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

-(void)initializeAnchor
{
    NSString *hand = @"right";
    //initialize green anchor
    _pressedAnchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_green_left"];
    _pressedAnchor.xScale = .3;
    _pressedAnchor.yScale = .3;
    _pressedAnchor.hidden = TRUE;
    
    //initialize red anchor
    _anchor = [SKSpriteNode spriteNodeWithImageNamed:@"anchor_red_left"];
    _anchor.xScale = .3;
    _anchor.yScale = .3;
    
    if([hand isEqualToString:@"left"]) //if left hand
    {
        _pressedAnchor.position = CGPointMake(75, self.frame.size.height/2-150);
        
        _anchor.position = CGPointMake(75, self.frame.size.height/2-150);
        
    }
    else    //if right hand (not left hand)
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
