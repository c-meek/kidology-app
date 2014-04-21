//
//  TargetPracticeMenuScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this is the target practice menu scene for choosing which type of target game to play

#import "TargetPracticeMenuScene.h"
#import "TargetPracticeScene.h"
#import "MainMenuScene.h"
#import "CustomTargetPracticeScene.h"
#import "NewGestureTargetScene.h"
#import "UtilityClass.h"

NSString *gameName;
@implementation TargetPracticeMenuScene

// initialize the scene by adding in the background and buttons
-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        gameName = nil;
        [self addBackground];
        [self addSelectModeLabel];
        [self addBackButton];
        [self addCenterModeButton];
        [self addRandomModeButton];
        [self addCustomModeButton];
        [self addGestureModeButton];
        [self addLogo];
        [self addToNotificationCenter];
        _enableSound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"] boolValue];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Touch Handling Logic
//-------------------------------------------------------------------------------------------------------------------------------------

// called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // get the current touch
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    
    // figure out which button (if any) was pressed and update its image to pressed
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

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    // figure out which button was released (if any), change its image to released and present that scene
    if ([node.name isEqualToString:@"backButton"] ||
        [node.name isEqualToString:@"backButtonPressed"])
        {
            // reset button icon
            _backButtonPressed.hidden = true;
            _backButton.hidden = false;
            
            // Create and configure the main menu scene
            SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
            backToMain.scaleMode = SKSceneScaleModeAspectFill;
            // remove the custom game table view browser if present
            [_tbv removeFromSuperview];
            // Present the scene.
            if (_enableSound)
                [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];
            [self.view presentScene:backToMain transition:reveal];
        }
    else if ([node.name isEqualToString:@"centerButtonPressed"] ||
             [node.name isEqualToString:@"centerButton"])
    {
        // Create and configure the center target practice scene
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:0];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        // remove the custom game table view browser if present
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice transition:reveal];
    }
    
    else if ([node.name isEqualToString:@"randomButtonPressed"] ||
        [node.name isEqualToString:@"randomButton"])
    {
        // Create and configure the random "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:1];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        // remove the custom game table view browser if present
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice transition:reveal];
    }
    else if ([node.name isEqualToString:@"gestureModeButtonPressed"] ||
             [node.name isEqualToString:@"gestureModeButton"])
    {
        // Create and configure the gesture practice scene
        // (note the size var must be different for this scene so gestures work correctly)
        SKScene *gesturePractice = [[NewGestureTargetScene alloc] initWithSize:self.size];
        gesturePractice.scaleMode = SKSceneScaleModeAspectFill;
        
        // remove the custom game table view browser if present
        [_tbv removeFromSuperview];
        
        // Present the scene
        [self.view presentScene:gesturePractice transition:reveal];
    }

    else if ([node.name isEqualToString:@"customModeButtonPressed"] ||
             [node.name isEqualToString:@"customModeButton"])
    {
        // check if the custom game table view browser is already displayed
        if(nil == gameName && [_tbv superview] == nil)
        {
            // if not, read in the game files to the game files array and display the table view
            [self addGameFilesToArray];
            _tbv = [[UITableView alloc] initWithFrame:CGRectMake(250, 200, self.frame.size.height/2, self.frame.size.width/2)];
            _tbv.delegate = self;
            _tbv.dataSource = self;
            [self.view addSubview:_tbv];
            _customModeButton.hidden = false;
            _customModeButtonPressed.hidden = true;
        }
        else
        {
            // if it is already displayed, then remove it from the view
            _customModeButton.hidden = false;
            _customModeButtonPressed.hidden = true;
            [_tbv removeFromSuperview];
        }
    }
    else
    {
        // if touch ended somewhere not on any button
        // reset all the buttons to untouched state (for touches moved)
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

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iterate over all moved touches
    for (UITouch *touch in [touches allObjects]) {
    	CGPoint currentLocation  = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        SKSpriteNode * currentNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
        SKSpriteNode * previousNode = (SKSpriteNode *)[self nodeAtPoint:previousLocation];
        
        // update how each button is presented (pressed vs unpressed) according to where
        // current touch is and where previous touch was
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
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

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
    selectModeLabel.fontColor = [SKColor darkTextColor];
    selectModeLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 210);
    selectModeLabel.text = @"Select Your Game Mode:";
    [self addChild:selectModeLabel];
}

-(void)addLogo
{
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
    logo.xScale = .5*.8;
    logo.yScale = .5*.8;
    logo.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:logo];
    
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
    _centerModeButton.position = CGPointMake(self.frame.size.width/8, self.frame.size.height/2-250);
    _centerModeButton.name = @"centerButton";
    _centerModeButton.xScale = .4;
    _centerModeButton.yScale = .4;
    [self addChild:_centerModeButton];
    
    _centerModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Center_Pressed"];
    _centerModeButtonPressed.position = CGPointMake(self.frame.size.width/8, self.frame.size.height/2-250);
    _centerModeButtonPressed.name = @"centerButtonPressed";
    _centerModeButtonPressed.xScale = .4;
    _centerModeButtonPressed.yScale = .4;
    _centerModeButtonPressed.hidden = true;
    [self addChild:_centerModeButtonPressed];
}

-(void)addRandomModeButton
{
    _randomModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Random"];
    _randomModeButton.position = CGPointMake(self.frame.size.width/8*3, self.frame.size.height/2-250);
    _randomModeButton.name = @"randomButton";
    _randomModeButton.xScale = .4;
    _randomModeButton.yScale = .4;
    [self addChild:_randomModeButton];
    
    _randomModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Random_Pressed"];
    _randomModeButtonPressed.position = CGPointMake(self.frame.size.width/8*3, self.frame.size.height/2-250);
    _randomModeButtonPressed.name = @"randomButtonPressed";
    _randomModeButtonPressed.xScale = .4;
    _randomModeButtonPressed.yScale = .4;
    _randomModeButtonPressed.hidden = true;
    [self addChild:_randomModeButtonPressed];
}

-(void)addCustomModeButton
{
    _customModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Custom"];
    _customModeButton.position = CGPointMake(self.frame.size.width/8*5, self.frame.size.height/2 - 250);
    _customModeButton.name = @"customModeButton";
    _customModeButton.xScale = .42;
    _customModeButton.yScale = .42;
    [self addChild:_customModeButton];
    
    _customModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Custom_Pressed"];
    _customModeButtonPressed.position = CGPointMake(self.frame.size.width/8*5, self.frame.size.height/2 - 250);
    _customModeButtonPressed.name = @"customModeButtonPressed";
    _customModeButtonPressed.xScale = .42;
    _customModeButtonPressed.yScale = .42;
    _customModeButtonPressed.hidden = true;
    [self addChild:_customModeButtonPressed];
}

-(void)addGestureModeButton
{
    _gestureModeButton = [[SKSpriteNode alloc] initWithImageNamed:@"Actions"];
    _gestureModeButton.position = CGPointMake(self.frame.size.width/8*7, self.frame.size.height/2-250);
    _gestureModeButton.name = @"gestureModeButton";
    _gestureModeButton.xScale = .4;
    _gestureModeButton.yScale = .4;
    [self addChild:_gestureModeButton];
    
    _gestureModeButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"Actions_Pressed"];
    _gestureModeButtonPressed.position = CGPointMake(self.frame.size.width/8*7, self.frame.size.height/2-250);
    _gestureModeButtonPressed.name = @"gestureModeButton";
    _gestureModeButtonPressed.xScale = .4;
    _gestureModeButtonPressed.yScale = .4;
    _gestureModeButtonPressed.hidden = true;
    [self addChild:_gestureModeButtonPressed];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Application Lifecycle Stuff (entering and leaving background)
//-------------------------------------------------------------------------------------------------------------------------------------

// called when this scene is about to be removed (transition to another scene)
-(void)willMoveFromView:(SKView *)view
{
    // remove this scene from the notification center (needed to fix memory management and notification bug)
    [self removeFromNotificationCenter];
}

// add this scene to the notification center to be notified when app enters background
-(void)addToNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appMovedtoBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

// remove this scene from the notification center (bug fix: app was crashing on leaving background when tableview present)
-(void)removeFromNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

// method called when app enters background while this scene is present
-(void)appMovedtoBackground:(NSNotification *)notification
{
    // remove the tableview if present
    if (_tbv != nil)
    {
        [_tbv removeFromSuperview];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                            UITableView Stuff (for listing custom game files)
//-------------------------------------------------------------------------------------------------------------------------------------

// procedure to read in game files from the Inbox directory (where files loaded from email are stored) into an array
-(void)addGameFilesToArray
{
    _gameArray = [[NSMutableArray alloc]init];
    NSString *extension = @"csv";
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Inbox"];
    
    // make the folder if it doesn't already exist
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    // iterate over all the .csv files in the Inbox directory and add them to the array
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    for(NSString *file in files)
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

// tells the table view how many rows to init with
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gameArray.count;
    
}

// populates the table view rows
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

// called when user selects a row in the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    gameName = [self.gameArray objectAtIndex:indexPath.row];
    [_tbv removeFromSuperview];
    SKScene *customTarget = [[CustomTargetPracticeScene alloc] initWithSize:self.size];
    customTarget.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
    [self.view presentScene:customTarget transition:reveal];
}

// creates a title for the table view
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"SELECT A GAME";
}

@end
