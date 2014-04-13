//
//  TargetPracticeGameOver.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeGameOver.h"
#import "TargetPracticeScene.h"
#import "LogEntry.h"
#import "MainMenuScene.h"
#import "TargetPracticeMenuScene.h"
#import "CustomTargetPracticeScene.h"

@implementation TargetPracticeGameOver

NSString *gameName;

-(id)initWithSize:(CGSize)size targets:(int)targets
{
    if (self = [super initWithSize:size])
    {
        gameName = nil;
        [self addBackground];
        [self addMessage:targets];
        [self addPlayAgainButton];
        [self addBackToTargetGameMenuButton];
        [self addBackToMainMenuButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"playAgainButton"] || [node.name isEqualToString:@"playAgainLabel"])
    {
        _playAgainButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"backToTargetGameMenuButton"] ||
             [node.name isEqualToString:@"backToTargetGameMenuLabel"])
    {
        _backToTargetGameMenuButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"backToMainMenuButton"] ||
             [node.name isEqualToString:@"backToMainMenuLabel"])
    {
        _backToMainMenuButton.color = [SKColor yellowColor];
    }
    
    NSMutableArray *log;
    SKScene *scene = [self.view scene];
    log = [scene.userData objectForKey:@"touchLog"];

    
    NSString * output = [[NSString alloc] init];
    output = [output stringByAppendingString:@"Type,Time,Touch Location X, Touch Location Y, Target Location X, Target Location Y, Target Radius\n"];
    for (int i=0;i<log.count;i++)
    {
        LogEntry *entry = log[i];
        //NSLog(@"%d,%f,%f", entry.type, entry.targetLocation.x,entry.targetLocation.y);
        //NSString * type = typeArray[entry.type];
             //NSString * type = @"a";
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%@,%f,%f,%f,%f,%f,%f\n", entry.type, entry.time, entry.touchLocation.x, entry.touchLocation.y, entry.targetLocation.x, entry.targetLocation.y, entry.targetRadius]];
        // get the documents directory
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"logs"];
        // make the folder if it doesn't already exist
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:folderPath contents:nil attributes:nil];

        // make a file name from the player name and the current date/time (dd/mm/yy hh:mm:ss timezone)
        NSString *nameString = [NSString stringWithFormat:@"%@_%@_",[[NSUserDefaults standardUserDefaults] stringForKey:@"firstName"] , [[NSUserDefaults standardUserDefaults] stringForKey:@"lastName"]];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterMediumStyle];
        // take out spaces
        dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
        // replace colons with hyphens
        dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        // replace slashes with hyphens
        dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSString *gameModeString = [scene.userData objectForKey: @"gameMode"];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@%@-%@.csv", folderPath, nameString, dateString, gameModeString];
        NSLog(@"%@", fileName);
        //NSLog(@"%@", output);
        
        [output writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:NULL];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"playAgainButton"] ||
        [node.name isEqualToString:@"playAgainLabel"])
    {
        // Create and configure the "main menu" scene.
        NSString *gameMode = [self.userData objectForKey:@"gameMode"];
        int mode = 0;
        if ([gameMode isEqualToString: @"center"])
        {
            mode = 1;
        }
        else if ([gameMode isEqualToString: @"random"])
        {
            mode = 2;
        }
        else if ([gameMode isEqualToString: @"gesture"])
        {
            mode = 3;
        }
        else if ([gameMode isEqualToString: @"custom"])
        {
            mode = 4;
        }
        
        if (mode != 4)
        {
            SKScene * targetPracticeScene = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:mode numTargets:3];
            targetPracticeScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:targetPracticeScene transition:reveal];
        }
        else if (mode == 4)
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
            SKScene * customTargetPracticeScene = [[CustomTargetPracticeScene alloc] initWithSize:self.size
                                                                                    ];
            customTargetPracticeScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:customTargetPracticeScene transition:reveal];
        }
    }
    else if ([node.name isEqualToString:@"backToTargetGameMenuButton"] ||
             [node.name isEqualToString:@"backToTargetGameMenuLabel"])
    {
        NSLog(@"going back to target game menu");
        // Create and configure the "main menu" scene.
        SKScene * targetPraticeMenuScene = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetPraticeMenuScene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:targetPraticeMenuScene transition:reveal];
    }
    else if ([node.name isEqualToString:@"backToMainMenuButton"] ||
             [node.name isEqualToString:@"backToMainMenuLabel"])
    {
        // Create and configure the "main menu" scene.
        SKScene * mainMenuScene = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenuScene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:mainMenuScene transition:reveal];
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
        
//        // If a touch was off the back button but has moved onto it
//        if (!([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
//            ([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
//        {
//            _pressedBackButton.hidden = false;
//            _backButton.hidden = true;
//        }
//        else if (([_backButton isEqual:previousNode] || [_pressedBackButton isEqual:previousNode]) &&
//                 !([_backButton isEqual:currentNode] || [_pressedBackButton isEqual:currentNode]))
//        {
//            _pressedBackButton.hidden = true;
//            _backButton.hidden = false;
//        }
    }
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .7;
    [self addChild:bgImage];
}

-(void)addMessage:(int)numOfTargets
{
    self.userData = [NSMutableDictionary dictionary];
    self.backgroundColor = [SKColor grayColor];
    NSString * messageText = [NSString stringWithFormat:@"Complete! You hit all %d targets!", numOfTargets];
    SKLabelNode * message = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    message.text = messageText;
    message.fontSize = 30;
    message.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
    message.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:message];
}

-(void)addPlayAgainButton
{
    _playAgainButton = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(400, 40)];
    _playAgainButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    _playAgainButton.name = @"playAgainButton";
    [self addChild:_playAgainButton];
    
    NSString *playAgainText = [NSString stringWithFormat:@"Play Again"];
    SKLabelNode *playAgainLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    playAgainLabel.text = playAgainText;
    playAgainLabel.name = @"playAgainLabel";
    playAgainLabel.fontSize = 20;
    playAgainLabel.fontColor = [SKColor whiteColor];
    playAgainLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    [self addChild:playAgainLabel];
}

-(void)addBackToTargetGameMenuButton
{
    _backToTargetGameMenuButton = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(400, 40)];
    _backToTargetGameMenuButton.position = CGPointMake(CGRectGetMidX(self.frame),
                                                      CGRectGetMidY(self.frame) - 150);
    _backToTargetGameMenuButton.name = @"backToTargetGameMenuButton";
    [self addChild:_backToTargetGameMenuButton];
    
    NSString *backToTargetGameMenuText = [NSString stringWithFormat:@"Back To Target Game Menu"];
    SKLabelNode *backToTargetGameMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backToTargetGameMenuLabel.text = backToTargetGameMenuText;
    backToTargetGameMenuLabel.name = @"backToTargetGameMenuLabel";
    backToTargetGameMenuLabel.fontSize = 20;
    backToTargetGameMenuLabel.fontColor = [SKColor whiteColor];
    backToTargetGameMenuLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                     CGRectGetMidY(self.frame) - 150);
    [self addChild:backToTargetGameMenuLabel];
}

-(void)addBackToMainMenuButton
{
    _backToMainMenuButton = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(400, 40)];
    _backToMainMenuButton.position = CGPointMake(CGRectGetMidX(self.frame),
                                                 CGRectGetMidY(self.frame) - 250);
    _backToMainMenuButton.name = @"backToMainMenuButton";
    [self addChild:_backToMainMenuButton];
    
    NSString *backToMainMenuText = [NSString stringWithFormat:@"Back To Main Game Menu"];
    SKLabelNode *backToMainMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backToMainMenuLabel.text = backToMainMenuText;
    backToMainMenuLabel.name = @"backToMainMenuLabel";
    backToMainMenuLabel.fontSize = 20;
    backToMainMenuLabel.fontColor = [SKColor whiteColor];
    backToMainMenuLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMidY(self.frame) - 250);
    [self addChild:backToMainMenuLabel];
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
