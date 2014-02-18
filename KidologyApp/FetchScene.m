//
//  FetchGame.m
//  KidologyApp
//
//  Created by klimczak, andrew edward on 2/13/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "FetchScene.h"
#import "MainMenuScene.h"

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
        
        [self displayBackButton];
        
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

-(void)displayBackButton
{
    //add button
    _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(100, 40)];
    _backButton.position = CGPointMake(self.frame.size.width - 55, self.frame.size.height/2+250);
    _backButton.name = @"backButton";
    [self addChild:_backButton];
    //add label
    NSString * labelText = [NSString stringWithFormat:@"Back"];
    _backButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _backButtonLabel.name = @"backButtonLabel";
    _backButtonLabel.text = labelText;
    _backButtonLabel.fontSize = 24;
    _backButtonLabel.position = CGPointMake(self.frame.size.width-55, self.frame.size.height/2 + 240);
    [self addChild:_backButtonLabel];
    NSLog(@"here");
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches)
    {
        //get a specific touch
        CGPoint location = [touch locationInNode:self];
        //find the node that is touched
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        //handle the situations of which nodes are touched
        if([_ball isEqual:touchedNode])
        {
            [self ballTouch];
        }
        else if([_dog isEqual:touchedNode])
        {
            [self dogTouch];
        }
        else if([_backButton isEqual:touchedNode] || [_backButtonLabel isEqual:touchedNode])
        {
            [self goToMainScreen];
        }
    }
}

-(void)ballTouch
{
    //move ball offscreen
    [self moveBallOffScreen];
    //move dog offscreen
    [self moveDogOffScreen];
    //move both onscreen
    [self moveBackDogAndBall];
}

-(void)dogTouch
{
    //TODO play dog sound
}

-(void)moveBallOffScreen
{
    //TODO play ball sound
    //scale ball to smaller size
    SKAction * scale = [SKAction scaleBy:.005 duration:1.0];
    //move ball offscreen
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-200, self.frame.size.height/2+100) duration:1];
    
    SKAction * moveSequence = [SKAction sequence:@[actionMove]];
    [_ball runAction:scale];
    [_ball runAction:moveSequence];
}

-(void)moveDogOffScreen
{
    //wait for ball to move offscreen
    SKAction *wait = [SKAction waitForDuration:1.5];
    //TODO play dog sound
    //move dog offscreen
    SKAction *move = [SKAction moveTo:CGPointMake(-500, _dog.size.height) duration:.5];
    
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
    SKAction * ballReappear = [SKAction runBlock:^{ [self displayBall]; }];
    
    SKAction * sequ = [SKAction sequence:@[wait, moveDog, wait2, ballReappear]];
    [_dog runAction:sequ];
    //replace ball
    [self displayBall];
}

-(void)goToMainScreen
{
    //create the scene
    SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
    mainMenu.scaleMode = SKSceneScaleModeAspectFill;
    //present the scene
    [self.view presentScene:mainMenu];
}

@end
