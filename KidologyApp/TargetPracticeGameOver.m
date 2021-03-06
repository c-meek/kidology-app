//
//  TargetPracticeGameOver.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
//  Sounds for this app were obtained at soundbible.com
//
//      License information for sounds in this file:
//          "tada" noise -- Creative Commons Attribution 3.0 (http://soundbible.com/1003-Ta-Da.html)
//          "gong" noise -- Creative Commons Attribution 0 (http://www.freesound.org/people/SaftJesus/sounds/151532/)

// this class is the scene displayed after a game is over (for all current game types)

#import "TargetPracticeGameOver.h"
#import "TargetPracticeScene.h"
#import "LogEntry.h"
#import "MainMenuScene.h"
#import "CustomTargetPracticeScene.h"
#import "NewGestureTargetScene.h"
#import "FetchScene.h"
#import "BabyMenuScene.h"

@implementation TargetPracticeGameOver

NSString *gameName;

-(id)initWithSize:(CGSize)size targetsHit:(int)targetsHit totalTargets:(int)totalTargets
{
    if (self = [super initWithSize:size])
    {
        self.targetsHit = targetsHit;
        self.totalTargets = totalTargets;
        gameName = nil;
        [self addBackground];
        [self addSignBoard];
        [self addMessage];
        [self addPlayAgainButton];
        [self addBackToMainMenuButton];
        
        // play a sound depending on how many of the targets were hit
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
        if (_enableSound)
        {
            if (targetsHit == totalTargets)
            {
                [self runAction:[SKAction playSoundFileNamed:@"tada.mp3" waitForCompletion:NO]];
            }
            else
            {
                [self runAction:[SKAction playSoundFileNamed:@"gong.mp3" waitForCompletion:NO]];
            }
        }
    }
    return self;
}

// called when the view is first displayed
-(void)didMoveToView:(SKView *)view
{
    // write to the log file
    [self doLogging];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // see which button was pressed and update its images
    if ([node.name isEqualToString:@"playAgainButton"] ||
        [node.name isEqualToString:@"playAgainButtonPressed"])
    {
        _playAgainButton.hidden = true;
        _playAgainButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"backToMainMenuButton"] ||
             [node.name isEqualToString:@"backToMainMenuButtonPressed"])
    {
        _backToMainMenuButton.hidden = true;
        _backToMainMenuButtonPressed.hidden = false;
    }
}

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    // Check which button was pressed (if any)
    if ([node.name isEqualToString:@"playAgainButton"] ||
        [node.name isEqualToString:@"playAgainButtonPressed"])
    {
        // reset the button
        _playAgainButton.hidden = false;
        _playAgainButtonPressed.hidden = true;
        
        // Create and configure the target practice scene
        NSString *gameMode = [self.userData objectForKey:@"gameMode"];

        NSLog(@"game mode is %@", gameMode);
        // determine which game type to return to based on which game just finished
        if ([gameMode isEqualToString: @"center"] ||
            [gameMode isEqualToString: @"random"])
        {
            int mode = 0;
            if ([gameMode isEqualToString: @"random"])
                mode = 1;
            SKScene * targetPracticeScene = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:mode];
            targetPracticeScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // play a transition sound and present the target practice scene
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            [self.view presentScene:targetPracticeScene transition:reveal];
        }
        else if ([gameMode isEqualToString: @"custom"])
        {
            // custom game mode, display the custom game browser
            if(nil == gameName && [_tbv superview] == nil)
            {
                [self addGameFilesToArray];
                _tbv = [[UITableView alloc] initWithFrame:CGRectMake(230, 200, self.frame.size.height/2+70, self.frame.size.width/2+50)];
                _tbv.delegate = self;
                _tbv.dataSource = self;
                [self.view addSubview:_tbv];
            }
            else
            {
                [_tbv removeFromSuperview];
            }
        }
        else if ([gameMode isEqualToString:@"gesture"])
        {
            // create and present the gesture practice scene
            SKScene *gesturePractice = [[NewGestureTargetScene alloc] initWithSize:self.size];
            gesturePractice.scaleMode = SKSceneScaleModeAspectFill;
            
            // play a transition sound and present the target practice scene
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            [self.view presentScene:gesturePractice transition:reveal];
        }
        else if ([gameMode isEqualToString:@"fetch"])
        {
            // create and present the fetch scene
            SKScene * fetchScene = [[FetchScene alloc] initWithSize:self.size];
            fetchScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:fetchScene transition:reveal];
        }
        else if ([gameMode isEqualToString:@"baby"])
        {
            SKScene * babyMenuScene = [[BabyMenuScene alloc] initWithSize:self.size];
            babyMenuScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // play a transition sound and present the baby menu scene
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            [self.view presentScene:babyMenuScene transition:reveal];
        }
 
    }
    else if ([node.name isEqualToString:@"backToMainMenuButton"] ||
             [node.name isEqualToString:@"backToMainMenuButtonPressed"])
    {
        // reset the button
        _backToMainMenuButton.hidden = false;
        _backToMainMenuButtonPressed.hidden = true;
        
        // Create and configure the "main menu" scene.
        SKScene * mainMenuScene = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenuScene.scaleMode = SKSceneScaleModeAspectFill;
        
        // play a transition sound and present the main menu scene
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
        [self.view presentScene:mainMenuScene transition:reveal];
    }
    else
    {
        [_tbv removeFromSuperview];
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        SKSpriteNode * currentNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
        SKSpriteNode * previousNode = (SKSpriteNode *)[self nodeAtPoint:previousLocation];
        
        // If a touch was off the back to main menu button but has moved onto it
        if (!([_backToMainMenuButton isEqual:previousNode] || [_backToMainMenuButtonPressed isEqual:previousNode]) &&
            ([_backToMainMenuButton isEqual:currentNode] || [_backToMainMenuButtonPressed isEqual:currentNode]))
        {
            _backToMainMenuButtonPressed.hidden = false;
            _backToMainMenuButton.hidden = true;
        }
        else if (([_backToMainMenuButton isEqual:previousNode] || [_backToMainMenuButtonPressed isEqual:previousNode]) &&
                 !([_backToMainMenuButton isEqual:currentNode] || [_backToMainMenuButtonPressed isEqual:currentNode]))
        {
            // if a touch was on the back to main menu button but moved off it
            _backToMainMenuButtonPressed.hidden = true;
            _backToMainMenuButton.hidden = false;
        }
        else if (!([_playAgainButton isEqual:previousNode] || [_playAgainButtonPressed isEqual:previousNode]) &&
            ([_playAgainButton isEqual:currentNode] || [_playAgainButtonPressed isEqual:currentNode]))
        {
            // if a touch was off the play again button but moved onto it
            _playAgainButtonPressed.hidden = false;
            _playAgainButton.hidden = true;
        }
        else if (([_playAgainButton isEqual:previousNode] || [_playAgainButtonPressed isEqual:previousNode]) &&
                 !([_playAgainButton isEqual:currentNode] || [_playAgainButtonPressed isEqual:currentNode]))
        {
            // if a touch was on the play again button but moved off it
            _playAgainButtonPressed.hidden = true;
            _playAgainButton.hidden = false;
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .5;
    bgImage.yScale = .5;
    [self addChild:bgImage];
}

-(void)addSignBoard
{
    SKSpriteNode *sign = [SKSpriteNode spriteNodeWithImageNamed:@"Signpost"];
    sign.position = CGPointMake(self.size.width/2, self.size.height/2);
    sign.xScale = 0.85;
    sign.yScale = 0.75;
    [self addChild:sign];
}

-(void)addMessage
{
    self.userData = [NSMutableDictionary dictionary];
    NSString * messageText = [NSString stringWithFormat:@"You hit %d of %d targets!", self.targetsHit, self.totalTargets];
    SKLabelNode * message = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    message.text = messageText;
    message.fontSize = 28;
    message.fontColor =  [SKColor colorWithRed:102/255.0 green:58/255.0 blue:28/255.0 alpha:1];
    message.position = CGPointMake(self.size.width/2, self.size.height/2 + 60);
    [self addChild:message];
}

-(void)addPlayAgainButton
{
    _playAgainButton = [[SKSpriteNode alloc] initWithImageNamed:@"Play_Again!"];
    _playAgainButton.position = CGPointMake(self.size.width/2, self.size.height/2 - 15);
    _playAgainButton.name = @"playAgainButton";
    _playAgainButton.xScale = .35;
    _playAgainButton.yScale = .35;
    [self addChild:_playAgainButton];
    
    _playAgainButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Play_Again!_Pressed"];
    _playAgainButtonPressed.position = CGPointMake(self.size.width/2, self.size.height/2 - 15);
    _playAgainButtonPressed.name = @"playAgainButtonPressed";
    _playAgainButtonPressed.hidden = true;
    _playAgainButtonPressed.xScale = .35;
    _playAgainButtonPressed.yScale = .35;
    [self addChild:_playAgainButtonPressed];
}

-(void)addBackToMainMenuButton
{
    _backToMainMenuButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_to_Main_Menu.png"];
    _backToMainMenuButton.position = CGPointMake(self.size.width/2, self.size.height/2 - 85);
    _backToMainMenuButton.name = @"backToMainMenuButton";
    _backToMainMenuButton.xScale = .35;
    _backToMainMenuButton.yScale = .35;
    [self addChild:_backToMainMenuButton];
    
    _backToMainMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Back_to_Main_Menu_Pressed.png"];
    _backToMainMenuButtonPressed.position = CGPointMake(self.size.width/2, self.size.height/2 - 85);
    _backToMainMenuButtonPressed.name = @"backToMainMenuButtonPressed";
    _backToMainMenuButtonPressed.hidden = true;
    _backToMainMenuButtonPressed.xScale = .35;
    _backToMainMenuButtonPressed.yScale = .35;
    [self addChild:_backToMainMenuButtonPressed];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Simple Utility Methods
//-------------------------------------------------------------------------------------------------------------------------------------

// this method reads in from the custom games files directory and adds them to the game files array
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

// this method writes all of the log entries from the touch log into a log file
-(void)doLogging
{
    NSString *gameMode = [self.userData objectForKey:@"gameMode"];
    if ([gameMode isEqualToString:@"gesture"])
    {
        // not logging gestures yet
        return;
    }
    SKScene *scene = [self.view scene];
    NSMutableArray *log = [scene.userData objectForKey:@"touchLog"];
    
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"logs"];
    // make the folder if it doesn't already exist
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    [[NSFileManager defaultManager] createFileAtPath:folderPath contents:nil attributes:nil];
    
    // make a file name from the player name and the current date/time (dd/mm/yy hh:mm:ss timezone)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *nameString = [NSString stringWithFormat:@"%@_%@_",firstName , lastName];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM-dd-yyyy_HH-mm-ss"];
    NSString *currentDate = [DateFormatter stringFromDate:[NSDate date]];
    NSString *gameModeString = [scene.userData objectForKey: @"gameMode"];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@%@-%@.csv", folderPath, nameString, currentDate, gameModeString];
    
    NSString *output = @"Player,Date,Game,Targets Hit, Total Targets\n";
    output = [output stringByAppendingString:[NSString stringWithFormat:@"%@ %@,%@,%@,%d,%d\n\n",firstName,lastName,currentDate,[self.userData objectForKey:@"gameMode"],self.targetsHit,self.totalTargets]];
    output = [output stringByAppendingString:@"Type,Anchor Pressed,Targets Hit,Time,Distance From Target Center,Touch Location X, Touch Location Y, Target Is On Screen, Target Location X, Target Location Y, Target Radius\n"];
    for (int i=0;i<log.count;i++)
    {
        LogEntry *entry = log[i];
        output = [output stringByAppendingString:[entry toString]];
    }
    [output writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:NULL];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                            UITableView Stuff (for listing zipped game files)
//-------------------------------------------------------------------------------------------------------------------------------------

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
