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

@implementation TargetPracticeScene

NSMutableArray *touchLog;

-(id)initWithSize:(CGSize)size game_mode:(int)game_mode
{
    if (self = [super initWithSize:size]) {
//        NSLog(@"Size: %@", NSStringFromCGSize(size));
        if (game_mode == 1) {
            _gameMode = CENTER;
        }
        if (game_mode == 2) {
            _gameMode = RANDOM;
        }
        NSLog(@"Game_mode: %d", game_mode);

        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //initialize panel
        self.anchorPanel = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeMake(200, self.size.height)];
        self.anchorPanel.position = CGPointMake(0, self.size.height/2);
        [self addChild:self.anchorPanel];
        //initialize target
        self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        //set the total number of targets for this session
        self.totalTargets = 3;
        self.correctTouches = 0;
        // initialize the anchor to "not being touched" state
        self.anchored = NOT_TOUCHING;
        //set properties of target
        [self displayTarget];
        //add target to screen
        [self addChild:self.target];
        
        self.time = 0; //tien was here
    }
    return self;
}

-(void)displayTarget
{
    if (_gameMode == CENTER)
    {
        //set target to middle of screen
        self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.target.xScale = .67;
        self.target.yScale = .67;
    }
    else if (_gameMode == RANDOM)
    {
        //set the target to appear at random locations
//        int x_pos = (rand() % (int)self.size.width)*.8;
    self.target.xScale = .67;
    self.target.yScale = .67;
    int x_pos = ((rand() % (int)self.size.width)/2)-(_target.size.width/2);
    int pos_neg = (rand() % 1);
    if (pos_neg == 0)
    {
        x_pos = self.frame.size.width/2 + x_pos;
    }
    else
    {
        x_pos = self.frame.size.width/2 - x_pos;
    }
    int y_pos = ((rand() % (int)self.size.height)/2)-(_target.size.height/2);
    pos_neg = (rand() % 1);
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
    NSLog(@"x is %f", self.target.position.x);
    NSLog(@"y is %f", self.target.position.y);
}

-(Boolean)isAnchorTouch:(CGPoint)touchLocation
{
    Boolean result;
//    NSLog(@"touch at (%f, %f).", touchLocation.x, touchLocation.y);
    if (touchLocation.x <= 100)
    {
        LogEntry currentTouch = {PANEL, self.time, CGPointMake(touchLocation.x, touchLocation.y), CGPointMake(self.target.position.x, self.target.position.y), self.target.size.width / 2};
        [touchLog addObject:[NSValue value:&currentTouch withObjCType:@encode(LogEntry)]];
        NSLog(@"anchor panel is being touched.");
        result = true;
    }
    else
    {
        NSLog(@"anchor panel is not being touched.");
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
    LogEntry currentTouch;
    
    if(leftHandSide <= rightHandSide) // If the touch is on the target
    {
        currentTouch.time = self.time;
        currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        currentTouch.targetRadius = radius;
        if (_anchored == TOUCHING) // the anchor is currently being touched
        {
            currentTouch.type = TARGET;
            _correctTouches++;
            //make a "delete" target action
            SKAction *deleteTarget = [SKAction runBlock:^{
                self.target.position = CGPointMake(-100,-100);
            }];
            //make a wait action
            SKAction *wait = [SKAction waitForDuration:3];
            //make a "add" target action
            SKAction *addTarget = [SKAction runBlock:^{
                [self displayTarget];
            }];
            //check to see if the total number of targets have been touched, then show the ending screen
            if(self.totalTargets <= self.correctTouches)
            {
                SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
                SKScene * gameOverScene = [[TargetPracticeGameOver alloc] initWithSize:self.size targets:self.totalTargets];
                // TODO: add the passing of the array like this:
                [gameOverScene.userData setObject:touchLog forKey:@"touchLog"];
                [self.view presentScene:gameOverScene transition: reveal];
            }
            //combine all the actions into a sequence
            SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
            //run the actions in sequential order
            [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        }
        else // the anchor is not currently being touched
        {
            currentTouch.type = UNANCHORED_TARGET;
        }
        [touchLog addObject:[NSValue value:&currentTouch withObjCType:@encode(LogEntry)]]; // log the touch
    }
    else
    {
        currentTouch.type = WHITESPACE;
        currentTouch.time = self.time;
        currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        currentTouch.targetRadius = self.target.size.width / 2;
        [touchLog addObject:[NSValue value:&currentTouch withObjCType:@encode(LogEntry)]];
    }
//    NSLog(@"Correct touches: %d | Total touches: %d", _correctTouches, _totalTouches);
    
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    NSLog(@"%@", touchLog);

}

-(void)trackerLabel
{
    SKLabelNode * trackerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    trackerLabel.fontSize = 20;
    NSString * text = [NSString stringWithFormat:@"%d/%d", _correctTouches, _totalTargets];
    trackerLabel.text = text;
    trackerLabel.fontColor = [SKColor grayColor];
    trackerLabel.horizontalAlignmentMode = 0; // text is center-aligned
    trackerLabel.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2+220);
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
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.fontColor = [SKColor grayColor];
    timeLabel.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height/2+265);

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

@end
