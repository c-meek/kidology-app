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
        self.backgroundColor = [SKColor colorWithRed:0.2 green:.6 blue:0.0 alpha:1.0];
        
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"tennis"];
        self.dog = [SKSpriteNode spriteNodeWithImageNamed:@"dog"];
        [self displayDog];
        [self addChild:self.dog];
        [self displayBall];
        [self addChild:self.ball];
        [self addInstruction];
        [self displayBackButton];
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
    //Back Button!
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    //Pressed Back Button!
    _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _pressedBackButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
    _pressedBackButton.name = @"backButton";
    _pressedBackButton.hidden = true;
    _pressedBackButton.xScale = .5;
    _pressedBackButton.yScale = .5;
    [self addChild:_pressedBackButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"pressedBackButton"])
        {
            _backButton.hidden = true;
            _pressedBackButton.hidden = false;
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
        if([_ball isEqual:touchedNode])
        {
            [self ballTouch];
        }
        else if([_dog isEqual:touchedNode])
        {
            [self dogTouch];
        }
        else if([_backButton isEqual:touchedNode] || [_pressedBackButton isEqual:touchedNode])
        {
            [self goToMainScreen];
        }
        else
        {
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
        }
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
    //TODO play dog sound
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
    SKAction *wait = [SKAction waitForDuration:1.5];
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
    
    SKAction * sequ = [SKAction sequence:@[wait, moveDog, wait2, ballReappear]];
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

@end
