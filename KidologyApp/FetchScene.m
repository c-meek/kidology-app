//
//  FetchGame.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/13/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "FetchScene.h"

@implementation FetchScene
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        //setup scene
        self.backgroundColor = [SKColor colorWithRed:0.078 green:.314 blue:0.0 alpha:1.0];
        
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"tennis"];
        self.dog = [SKSpriteNode spriteNodeWithImageNamed:@"dog"];
        [self displayDog];
        [self addChild:self.dog];
        [self displayBall];
        [self addChild:self.ball];

        self.totalTargets = 5;
        
    }
    return self;
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)ballTouch:(CGPoint)touchLocation
{
    
}

-(void)update:(CFTimeInterval)currentTime
{
    
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    
}

@end
