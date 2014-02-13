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

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
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
    //set target to middle of screen
    self.target.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.target.xScale = .67;
    self.target.yScale = .67;
    NSLog(@"x is %f", self.target.position.x);
    NSLog(@"y is %f", self.target.position.y);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    //test whether the target has been touched
    [self targetTouch:positionInScene];
    //    for (UITouch *touch in touches)
    //    {
    //        CGPoint location = [touch locationInNode:self];
    //
    
    
    //        [sprite runAction:[SKAction repeatActionForever:action]];
    
    //        [self addChild:sprite];
    //    }
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
    
    if(leftHandSide <= rightHandSide)
    {
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
    NSLog(@"Correct touches: %d | Total touches: %d", _correctTouches, _totalTouches);
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];

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

    NSLog(@"Time: %f | string: %f", r_time, CGRectGetMidX(self.frame));
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionMoveTime = [SKAction moveTo:timeLabel.position duration:.075];
    [timeLabel runAction:[SKAction sequence:@[actionMoveTime, actionMoveDone]]];
    
}

@end
