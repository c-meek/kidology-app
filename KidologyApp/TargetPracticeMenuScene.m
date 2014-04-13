//
//  TargetPracticeMenuScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeMenuScene.h"
#import "TargetPracticeScene.h"
#import "MainMenuScene.h"
#import "CustomTargetPracticeScene.h"

NSString *gameName;
@implementation TargetPracticeMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        gameName = nil;

        [self addBackground];
        [self addInstructionLabel];
        [self addSelectModeLabel];
        [self addBackButton];
        [self addCenterModeButton];
        [self addRandomModeButton];
        [self addCustomModeButton];
        [self addGestureModeButton];
        [self addTarget];
        [self addHandAnimation];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonPressed"])
    {
        _backButton.hidden = true;
        _backButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"centerButtonPressed"] || [node.name isEqualToString:@"centerButton"])
    {
        _centerModeButton.hidden = true;
        _centerModeButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"randomButtonPressed"] || [node.name isEqualToString:@"randomButton"])
    {
        _randomModeButton.hidden = true;
        _randomModeButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"customModeButtonPressed"] || [node.name isEqualToString:@"customModeButton"])
    {
        _customModeButton.hidden = true;
        _customModeButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"gestureModeButtonPressed"] || [node.name isEqualToString:@"gestureModeButton"])
    {
        _gestureModeButton.hidden = true;
        _gestureModeButtonPressed.hidden = false;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backButtonPressed"])
        {
            SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
            backToMain.scaleMode = SKSceneScaleModeAspectFill;
            [_tbv removeFromSuperview];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:backToMain transition:reveal];
        }
    //Added another variable for Target Practice call.
    else if ([node.name isEqualToString:@"centerButtonPressed"] ||
             [node.name isEqualToString:@"centerButton"])
    {
        NSLog(@"hit center button");
        // Create and configure the center "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:1 numTargets:3]; //added numTagets...
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [_tbv removeFromSuperview];
        [self.view presentScene:targetPractice transition:reveal];
    }
    
    else if ([node.name isEqualToString:@"randomButtonPressed"] ||
        [node.name isEqualToString:@"randomButton"])
    {
        // Create and configure the random "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:2 numTargets:3]; //added numTagets...
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice transition:reveal];
    }
    else if ([node.name isEqualToString:@"gestureModeLabel"] ||
             [node.name isEqualToString:@"gestureModeButton"])
    {
        // Create and configure the random "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:4 numTargets:3]; //added numTagets...
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice transition:reveal];
    }

    else if ([node.name isEqualToString:@"customModeLabel"] || [node.name isEqualToString:@"customModeButton"])
    {
        if(nil == gameName && [_tbv superview] == nil)
        {
//            UIViewController *vc = self.view.window.rootViewController;
//            [vc performSegueWithIdentifier:@"toGameList" sender:self];
//            _customModeButton.color = [SKColor greenColor];
            [self addGameFilesToArray];
            _tbv = [[UITableView alloc] initWithFrame:CGRectMake(250, 200, self.frame.size.height/2, self.frame.size.width/2)];
            _tbv.delegate = self;
            _tbv.dataSource = self;
            [self.view addSubview:_tbv];
        }
        else
        {
            [_tbv removeFromSuperview];
        }
    }
    else
    {
        _backButton.hidden = false;
        _backButtonPressed.hidden = true;
        _centerModeButton.hidden = false;
        _centerModeButtonPressed.hidden = true;
        _randomModeButton.hidden = false;
        _randomModeButtonPressed.hidden = true;
        _customModeButton.hidden = false;
        _customModeButtonPressed.hidden = true;
        _gestureModeButton.hidden = false;
        _gestureModeButtonPressed.hidden = true;
        [_tbv removeFromSuperview];
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
        if (!([_backButton isEqual:previousNode] || [_backButtonPressed isEqual:previousNode]) &&
            ([_backButton isEqual:currentNode] || [_backButtonPressed isEqual:currentNode]))
        {
            _backButtonPressed.hidden = false;
            _backButton.hidden = true;
        }
        else if (([_backButton isEqual:previousNode] || [_backButtonPressed isEqual:previousNode]) &&
                 !([_backButton isEqual:currentNode] || [_backButtonPressed isEqual:currentNode]))
        {
            _backButtonPressed.hidden = true;
            _backButton.hidden = false;
        }
        else if (!([_centerModeButton isEqual:previousNode] || [_centerModeButtonPressed isEqual:previousNode]) &&
                 ([_centerModeButton isEqual:currentNode] || [_centerModeButtonPressed isEqual:currentNode]))
        {
            _centerModeButtonPressed.hidden = false;
            _centerModeButton.hidden = true;
        }
        else if (([_centerModeButton isEqual:previousNode] || [_centerModeButtonPressed isEqual:previousNode]) &&
                 !([_centerModeButton isEqual:currentNode] || [_centerModeButtonPressed  isEqual:currentNode]))
        {
            _centerModeButtonPressed .hidden = true;
            _centerModeButton.hidden = false;
        }
        else if (!([_randomModeButton isEqual:previousNode] || [_randomModeButtonPressed isEqual:previousNode]) &&
                 ([_randomModeButton isEqual:currentNode] || [_randomModeButtonPressed isEqual:currentNode]))
        {
            _randomModeButtonPressed.hidden = false;
            _randomModeButton.hidden = true;
        }
        else if (([_randomModeButton isEqual:previousNode] || [_randomModeButtonPressed isEqual:previousNode]) &&
                 !([_randomModeButton isEqual:currentNode] || [_randomModeButtonPressed  isEqual:currentNode]))
        {
            _randomModeButtonPressed .hidden = true;
            _randomModeButton.hidden = false;
        }
        else if (!([_customModeButton isEqual:previousNode] || [_customModeButtonPressed isEqual:previousNode]) &&
                 ([_customModeButton isEqual:currentNode] || [_customModeButtonPressed isEqual:currentNode]))
        {
            _customModeButtonPressed.hidden = false;
            _customModeButton.hidden = true;
        }
        else if (([_customModeButton isEqual:previousNode] || [_customModeButtonPressed isEqual:previousNode]) &&
                 !([_customModeButton isEqual:currentNode] || [_customModeButtonPressed  isEqual:currentNode]))
        {
            _customModeButtonPressed.hidden = true;
            _customModeButton.hidden = false;
        }
        else if (!([_gestureModeButton isEqual:previousNode] || [_gestureModeButtonPressed isEqual:previousNode]) &&
                 ([_gestureModeButton isEqual:currentNode] || [_gestureModeButtonPressed isEqual:currentNode]))
        {
            _gestureModeButtonPressed.hidden = false;
            _gestureModeButton.hidden = true;
        }
        else if (([_gestureModeButton isEqual:previousNode] || [_gestureModeButtonPressed isEqual:previousNode]) &&
                 !([_gestureModeButton isEqual:currentNode] || [_gestureModeButtonPressed  isEqual:currentNode]))
        {
            _gestureModeButtonPressed .hidden = true;
            _gestureModeButton.hidden = false;
        }


    }
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}

-(void)addSelectModeLabel
{
    SKLabelNode *selectModeLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    selectModeLabel.fontSize = 35;
    selectModeLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    selectModeLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 210);
    selectModeLabel.text = @"Select Your Game Mode:";
    [self addChild:selectModeLabel];
}

-(void)addInstructionLabel
{
    SKLabelNode *instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionLabel.fontSize = 40;
    instructionLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+150);
    instructionLabel.text = @"Instructions:";
    [self addChild:instructionLabel];
    
    SKLabelNode *instructionContentLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructionContentLabel.fontSize = 20;
    instructionContentLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    instructionContentLabel.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+110);
    instructionContentLabel.horizontalAlignmentMode = 1;
    instructionContentLabel.text = @"Touch the center of the target when it appears.";
    [self addChild:instructionContentLabel];
}

-(void)addBackButton
{
    _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
    _backButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _backButton.name = @"backButton";
    _backButton.xScale = .5;
    _backButton.yScale = .5;
    [self addChild:_backButton];
    
    _backButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _backButtonPressed.position = CGPointMake(100, self.frame.size.height/2+235);
    _backButtonPressed.name = @"backButtonPressed";
    _backButtonPressed.hidden = true;
    _backButtonPressed.xScale = .5;
    _backButtonPressed.yScale = .5;
    [self addChild:_backButtonPressed];
}

-(void)addCenterModeButton
{
    _centerModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Center"];
    _centerModeButton.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
    _centerModeButton.name = @"centerButton";
    _centerModeButton.xScale = .4;
    _centerModeButton.yScale = .4;
    [self addChild:_centerModeButton];
    
    _centerModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Center_Pressed"];
    _centerModeButtonPressed.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
    _centerModeButtonPressed.name = @"centerButtonPressed";
    _centerModeButtonPressed.xScale = .4;
    _centerModeButtonPressed.yScale = .4;
    _centerModeButtonPressed.hidden = true;
    [self addChild:_centerModeButtonPressed];
}

-(void)addRandomModeButton
{
    _randomModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Random"];
    _randomModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
    _randomModeButton.name = @"randomButton";
    _randomModeButton.xScale = .4;
    _randomModeButton.yScale = .4;
    [self addChild:_randomModeButton];
    
    _randomModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Random_Pressed"];
    _randomModeButtonPressed.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
    _randomModeButtonPressed.name = @"randomButtonPressed";
    _randomModeButtonPressed.xScale = .4;
    _randomModeButtonPressed.yScale = .4;
    _randomModeButtonPressed.hidden = true;
    [self addChild:_randomModeButtonPressed];
}

-(void)addCustomModeButton
{
    _customModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Custom"];
    _customModeButton.position = CGPointMake(self.frame.size.width/4*2, self.frame.size.height/2 - 250);
    _customModeButton.name = @"customModeButton";
    _customModeButton.xScale = .45;
    _customModeButton.yScale = .45;
    [self addChild:_customModeButton];
    
    _customModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Custom_Pressed"];
    _customModeButtonPressed.position = CGPointMake(self.frame.size.width/4*2, self.frame.size.height/2 - 250);
    _customModeButtonPressed.name = @"customModeButtonPressed";
    _customModeButtonPressed.xScale = .45;
    _customModeButtonPressed.yScale = .45;
    _customModeButtonPressed.hidden = true;
    [self addChild:_customModeButtonPressed];
}

-(void)addGestureModeButton
{
    _gestureModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Actions"];
    _gestureModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-200);
    _gestureModeButton.name = @"gestureModeButton";
    _gestureModeButton.xScale = .4;
    _gestureModeButton.yScale = .4;
    [self addChild:_gestureModeButton];
    
    _gestureModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Actions_Pressed"];
    _gestureModeButtonPressed.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-200);
    _gestureModeButtonPressed.name = @"gestureModeButton";
    _gestureModeButtonPressed.xScale = .4;
    _gestureModeButtonPressed.yScale = .4;
    _gestureModeButtonPressed.hidden = true;
    [self addChild:_gestureModeButtonPressed];
}

-(void)addTarget
{
    
    _target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
    _target.position = (CGPointMake(self.frame.size.width/2-50, self.frame.size.height/2-82));
    _target.xScale = .4;
    _target.yScale = .15;
    [self addChild:_target];
}

-(void)addHandAnimation
{
    _hand = [SKSpriteNode spriteNodeWithImageNamed:@"hand"];
    _hand.position = (CGPointMake(self.frame.size.width/2+150+(self.hand.size.width/2), self.frame.size.height/2-62+(self.hand.size.height/2)));
    [self addChild:_hand];
    SKAction * moveHandOver = [SKAction moveTo:(CGPointMake(self.frame.size.width/2-50+(self.hand.size.width/2), self.frame.size.height/2-72+(self.hand.size.height/2))) duration:2];
    SKAction * pressButton = [SKAction moveTo:(CGPointMake(self.frame.size.width/2-50+(self.hand.size.width/2), self.frame.size.height/2-82+(self.hand.size.height/2))) duration:.5];
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [_hand runAction: [SKAction sequence:@[moveHandOver, pressButton, wait, actionMoveDone]]];
}

-(void)addGameFilesToArray
{
    _gameArray = [[NSMutableArray alloc]init];
    NSString *extension = @"csv";
    //NSString *resPath = [[NSBundle mainBundle] resourcePath];
    
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Inbox"];
    // make the folder if it doesn't already exist
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    
    
    NSString *file;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    for(file in files)
    {
        if([[file pathExtension] isEqualToString:extension])
        {
            [_gameArray addObject:file];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.gameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    gameName = [self.gameArray objectAtIndex:indexPath.row];
    [_tbv removeFromSuperview];
    SKScene *customTarget = [[CustomTargetPracticeScene alloc] initWithSize:self.size];
    customTarget.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    [self.view presentScene:customTarget transition:reveal];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"SELECT A GAME";
}

@end
