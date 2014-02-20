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

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
//        NSLog(@"Size: %@", NSStringFromCGSize(size));
        touchLog = [[NSMutableArray alloc] initWithCapacity:1];
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //initialize anchor panel
         self.anchorPanel = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeMake(200, self.frame.size.height)];
        _anchorPanel.position = CGPointMake(0, CGRectGetMidY(self.frame));
        [self addChild:_anchorPanel];
        //initialize target
        self.target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        //set the total number of targets for this session
        self.totalTargets = 3;
        //set properties of target
        [self displayTarget];
        //add target to screen
        [self addChild:self.target];
        // initialize the target counter
        _targetsLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _targetsLabel.fontSize = 20;
        _targetsLabel.verticalAlignmentMode = 2;
        _targetsLabel.horizontalAlignmentMode = 1;
        _targetsLabel.fontColor = [SKColor grayColor];
        _targetsLabel.position = CGPointMake(CGRectGetMidX(self.frame)+230, CGRectGetMidY(self.frame)+220);
        _targetsLabel.text = [NSString stringWithFormat:@"Touched: %i/%i", _correctTouches, _totalTargets];
        [self addChild:_targetsLabel];
        
        self.time = 0; //tien was here
    }
    return self;
}

-(void)displayTarget
{
//    if (_gameMode == CENTER)
//    {
//        //set target to middle of screen
        self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.target.xScale = .67;
        self.target.yScale = .67;
//    }
//    else if (_gameMode == RANDOM)
//    {
        //set the target to appear at random locations
//        int x_pos = (rand() % (int)self.size.width)*.8;
//    int x_pos = ((rand() % (int)self.size.width)/2)-(_target.size.width/2);
//    int pos_neg = (rand() % 1);
//    if (pos_neg == 0)
//    {
//        x_pos = self.frame.size.width/2 + x_pos;
//    }
//    else
//    {
//        x_pos = self.frame.size.width/2 - x_pos;
//    }
//    int y_pos = ((rand() % (int)self.size.height)/2)-(_target.size.height/2);
//    pos_neg = (rand() % 1);
//    if (pos_neg == 0)
//    {
//        y_pos = self.frame.size.height/2 + y_pos;
//    }
//    else
//    {
//        y_pos = self.frame.size.height/2 - y_pos;
//    }
//
//        self.target.position = CGPointMake(x_pos, y_pos);
//    }
//    NSLog(@"x is %f", self.target.position.x);
//    NSLog(@"y is %f", self.target.position.y);
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
    
    for (UITouch *touch in [touches allObjects]) {
        /* Called when a touch begins */
        CGPoint positionInScene = [touch locationInNode:self];
        //test whether the target has been touched
       if (! [self isAnchorTouch:positionInScene]) // If the touch isn't going to be logged in the isAnchorTouch function,
       {
            [self targetTouch:positionInScene]; // log it inside the targetTouch function and evaluate accordingly.
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
    
    if(leftHandSide <= rightHandSide)
    {
        currentTouch.type = CORRECT;
        currentTouch.time = self.time;
        currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        currentTouch.targetRadius = radius;
        [touchLog addObject:[NSValue value:&currentTouch withObjCType:@encode(LogEntry)]];
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
            // [newScene.userData setObject:[currentScene.userData objectForKey:@"score"] forKey:@"score"];
            [self.view presentScene:gameOverScene transition: reveal];
        }
        //combine all the actions into a sequence
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        //run the actions in sequential order
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        // reflect the touched target by updating the label
        [_targetsLabel removeFromParent];
        _targetsLabel.text = [NSString stringWithFormat:@"Touched: %i/%i", _correctTouches, _totalTargets];
        [self addChild:_targetsLabel];

    }
    else
    {
        currentTouch.type = INCORRECT;
        currentTouch.time = self.time;
        currentTouch.touchLocation = CGPointMake(touchLocation.x, touchLocation.y);
        currentTouch.targetLocation = CGPointMake(self.target.position.x, self.target.position.y);
        currentTouch.targetRadius = self.target.size.width / 2;
        [touchLog addObject:[NSValue value:&currentTouch withObjCType:@encode(LogEntry)]];
    }
//    NSLog(@"Correct touches: %d | Total touches: %d", _correctTouches, _totalTouches);
    
}



-(void)update:(CFTimeInterval)currentTime {
    //TODO: put something in here that checks if anchor is being touched - if not trigger some sort of timer to alert the user after 4 seconds (?)
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    NSLog(@"%@", touchLog);

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
    timeLabel.horizontalAlignmentMode = 1;
    timeLabel.fontColor = [SKColor grayColor];
    timeLabel.position = CGPointMake(CGRectGetMidX(self.frame)+230, CGRectGetMidY(self.frame)+250);
    
    float r_time = roundf(self.time *100)/100.0;
    NSString *s_time = [NSString stringWithFormat: @"Time: %.1f", r_time];
    timeLabel.text = s_time;
    [self addChild: timeLabel];

//    NSLog(@"Time: %f | string: %f", r_time, CGRectGetMidX(self.frame));
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.075];
    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
    
}

@end
