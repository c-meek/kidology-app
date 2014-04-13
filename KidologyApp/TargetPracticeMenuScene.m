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
    
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backLabel"])
    {
        _backButton.hidden = true;
        _pressedBackButton.hidden = false;
    }
    
    //Added another variable for Target Pratice call.
    else if ([node.name isEqualToString:@"centerLabel"] ||
             [node.name isEqualToString:@"centerButton"])
    {
        _centerModeButton.color = [SKColor yellowColor];
    }
    
    else if ([node.name isEqualToString:@"randomLabel"] ||
             [node.name isEqualToString:@"randomButton"])
    {
        _randomModeButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"customModeLabel"] ||
             [node.name isEqualToString:@"customModeButton"])
    {
        _customModeButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"gestureModeLabel"] ||
             [node.name isEqualToString:@"gestureModeButton"])
    {
        _gestureModeButton.color = [SKColor yellowColor];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backLabel"])
        {
            SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
            backToMain.scaleMode = SKSceneScaleModeAspectFill;
            [_tbv removeFromSuperview];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:backToMain transition:reveal];
        }
    //Added another variable for Target Practice call.
    else if ([node.name isEqualToString:@"centerLabel"] ||
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
    
    else if ([node.name isEqualToString:@"randomLabel"] ||
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
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:3 numTargets:3]; //added numTagets...
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
        _pressedBackButton.hidden = true;
        _backButton.hidden = false;
        _centerModeButton.color = [SKColor redColor];
        _gestureModeButton.color = [SKColor redColor];
        _customModeButton.color = [SKColor redColor];
        _randomModeButton.color = [SKColor redColor];
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
        if (!([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
            ([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
        {
            _pressedBackButton.hidden = false;
            _backButton.hidden = true;
        }
        else if (([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
                 !([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
        {
            _pressedBackButton.hidden = true;
            _backButton.hidden = false;
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
    
    _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
    _pressedBackButton.position = CGPointMake(100, self.frame.size.height/2+235);
    _pressedBackButton.name = @"backButton";
    _pressedBackButton.hidden = true;
    _pressedBackButton.xScale = .5;
    _pressedBackButton.yScale = .5;
    [self addChild:_pressedBackButton];
}

-(void)addCenterModeButton
{
    _centerModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
    _centerModeButton.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
    _centerModeButton.name = @"centerButton";
    [self addChild:_centerModeButton];
    
    _centerModeButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
    _centerModeButtonLabel.fontSize = 35;
    _centerModeButtonLabel.fontColor = [SKColor whiteColor];
    _centerModeButtonLabel.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
    _centerModeButtonLabel.name = @"centerLabel";
    _centerModeButtonLabel.text = @"Center";
    _centerModeButtonLabel.verticalAlignmentMode =1;
    [self addChild:_centerModeButtonLabel];
}

-(void)addRandomModeButton
{
    _randomModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
    _randomModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
    _randomModeButton.name = @"randomButton";
    [self addChild:_randomModeButton];
    
    _randomModeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
    _randomModeButtonLabel.fontSize = 35;
    _randomModeButtonLabel.fontColor = [SKColor whiteColor];
    _randomModeButtonLabel.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
    _randomModeButtonLabel.name = @"randomLabel";
    _randomModeButtonLabel.text = @"Random";
    _randomModeButtonLabel.verticalAlignmentMode = 1;
    [self addChild:_randomModeButtonLabel];
}

-(void)addCustomModeButton
{
    _customModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
    _customModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2 - 200);
    _customModeButton.name = @"customModeButton";
    [self addChild:_customModeButton];
    
    _customModeLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
    _customModeLabel.fontSize = 35;
    _customModeLabel.fontColor = [SKColor whiteColor];
    _customModeLabel.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-200);
    _customModeLabel.name = @"customModeLabel";
    _customModeLabel.text = @"Custom";
    _customModeLabel.verticalAlignmentMode = 1;
    [self addChild:_customModeLabel];
}

-(void)addGestureModeButton
{
    _gestureModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
    _gestureModeButton.position = CGPointMake(self.frame.size.width/4*2, self.frame.size.height/2-250);
    _gestureModeButton.name = @"gestureModeButton";
    [self addChild:_gestureModeButton];
    
    _gestureModeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
    _gestureModeButtonLabel.fontSize = 35;
    _gestureModeButtonLabel.fontColor = [SKColor whiteColor];
    _gestureModeButtonLabel.position = CGPointMake(self.frame.size.width/4*2,
                                                   self.frame.size.height/2-250);
    _gestureModeButtonLabel.name = @"gestureModeLabel";
    _gestureModeButtonLabel.text = @"Gesture";
    _gestureModeButtonLabel.verticalAlignmentMode = 1;
    [self addChild:_gestureModeButtonLabel];
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
