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

@implementation BabyTargetPracticeScene

-(id)initWithSize:(CGSize)size color:(NSString *)color
{
    if (self = [super initWithSize:size])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        _delayBetweenTargets = [[defaults objectForKey:@"delayBetweenTargets"] integerValue];
        _targetSize = [[defaults objectForKey:@"defaultTargetSize"] floatValue];
        NSLog(@"target size is %f", _targetSize);

        self.targetsHit = 0;
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Huge_Checkered_Background_[4096x3072]"];
        [self addChild:bgImage];
        
        _target = [SKSpriteNode spriteNodeWithImageNamed:color];
        _target.xScale = _targetSize;
        _target.yScale = _targetSize;
        _target.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_target];
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
        
        // go back to the main menu
        SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
        backToMain.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:backToMain transition:reveal];
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
    timeLabel.fontColor = [SKColor colorWithRed:0.96 green:0.79 blue:0.39 alpha:1];
    timeLabel.verticalAlignmentMode = 2;
    timeLabel.horizontalAlignmentMode = 0; // text is center-aligned
    timeLabel.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height/2+265);
    
 
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
    double leftHandSide = (pow(xDifference, 2) + pow(yDifference, 2));
    double rightHandSide = pow(radius, 2);
    
    if(leftHandSide <= rightHandSide) // If the touch is on the target
    {
        self.targetsHit ++;
        SKAction *deleteTarget = [SKAction runBlock:^{
            // play a popping noise as the target is dismissed
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
            if (enableSound)
            {
                [self runAction:[SKAction playSoundFileNamed:@"pop.mp3" waitForCompletion:NO]];
            }
            // dismiss the target
            [self hideTarget];
        }];
        //make a wait action
                SKAction *wait = [SKAction waitForDuration:_delayBetweenTargets];
        SKAction *addTarget = [SKAction runBlock:^{
            [self displayTarget];
        }];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        if (enableSound)
        {
            [self runAction:[SKAction playSoundFileNamed:@"dog_bark.mp3" waitForCompletion:NO]];
        }
        
        SKAction *showAnotherTarget = [SKAction sequence:@[deleteTarget,wait,addTarget]];
        [self runAction:[SKAction repeatAction:showAnotherTarget count:1]];
        _totalTouches++;
        
        if (enableSound)
        {
            //select a random number [0...4] to choose a random sound to play
            int r = arc4random() % 4;
            switch (r) {
                case 0:
                    [self runAction:[SKAction playSoundFileNamed:@"dog_bark.mp3" waitForCompletion:NO]];
                    break;
                case 1:
                    [self runAction:[SKAction playSoundFileNamed:@"rooster.mp3" waitForCompletion:NO]];
                    break;
                case 2:
                    [self runAction:[SKAction playSoundFileNamed:@"horse.mp3" waitForCompletion:NO]];
                    break;
                case 3:
                    [self runAction:[SKAction playSoundFileNamed:@"bubbles.mp3" waitForCompletion:NO]];
                    break;
                default:
                    [self runAction:[SKAction playSoundFileNamed:@"horse.mp3" waitForCompletion:NO]];
                    break;
            }
          
        }
        
//        if (_totalTouches > 5) {
//            SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
//            mainMenu.scaleMode = SKSceneScaleModeAspectFill;
//            
//            // Present the scene.
//            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
//            [self.view presentScene:mainMenu transition:reveal];
//        }
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

@end
