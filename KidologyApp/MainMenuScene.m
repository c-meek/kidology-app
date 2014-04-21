//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
//  Sounds for this app were obtained at soundbible.com
//
//      License information for sounds in this file:
//          "background" noise -- Creative Commons Attribution 0 http://www.freesound.org/people/swiftoid/sounds/182500/

// this class is the main menu scene (view)
// it contains buttons to link to the various games
// as well as to email game logs to the therapist

#import "MainMenuScene.h"
#import "BabyMenuScene.h"
#import "TargetPracticeMenuScene.h"
#import "FetchScene.h"
#import "UtilityClass.h"
#import "ZipArchive.h"
#import <MessageUI/MFMailComposeViewController.h>


@implementation MainMenuScene

// initializer method (NOTE: size in initializer methods refers to screen size in pixels)
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // add background and buttons to screen
        [self addBackground];
        [self addBabyGameButton];
        [self addTargetGameButton];
        [self addFetchGameButton];
        [self addTherapistMenuButton];
        // load user settings for therapist upload
        [self loadSettingsInfo];
        // check user name and add user name label to corner
        [self addUserInfo];
        // add this class to the notification center (see method comments below)
        [self addToNotificationCenter];
        
        // add a background music player
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"birds" withExtension:@"mp3"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
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
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // figure out which button (if any) was pressed and update its image to pressed
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        _babyGameButton.hidden = true;
        _babyGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        _targetGameButton.hidden = true;
        _targetGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
        [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        _fetchGameButton.hidden = true;
        _fetchGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        _therapistMenuButton.hidden = true;
        _therapistMenuButtonPressed.hidden = false;
    }
}

// called when a touch ends
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // get the current touch
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    // figure out which button was released (if any), change its image to released and present that scene
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        // remove the older games table view browser if present
        [_tbv removeFromSuperview];

        // reset the button
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // create and configure the baby game menu scene
        SKScene * babyGame = [[BabyMenuScene alloc] initWithSize:self.size];
        babyGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // stop the background music and play a transition sound
        [_backgroundMusicPlayer stop];
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];

        // present the scene
        [self.view presentScene:babyGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        // remove the older games table view browser if present
        [_tbv removeFromSuperview];

        // reset the button
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // create and configure the target game menu scene.
        SKScene * targetGame = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // stop the background music and play a transition sound
        [_backgroundMusicPlayer stop];
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"vroom.mp3" waitForCompletion:NO]];

        // Present the scene
        [self.view presentScene:targetGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        // remove the older games table view browser if present
        [_tbv removeFromSuperview];

        // reset the button
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // create and configure the fetch game menu scene
        SKScene * fetchGame = [[FetchScene alloc] initWithSize:self.size];
        fetchGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // stop the background music but don't play a transition sound (will overlap with dog barking)
        [_backgroundMusicPlayer stop];

        // present the scene
        [self.view presentScene:fetchGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        // remove the older games table view browser if present
        [_tbv removeFromSuperview];

        // reset the button
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
        
        // check if any required settings are missing
        if ([UtilityClass checkSettings])
            return;

        // stop the background music and play a transition sound
        [_backgroundMusicPlayer stop];
        if (_enableSound)
            [self runAction:[SKAction playSoundFileNamed:@"jump.mp3" waitForCompletion:NO]];
        
        // display a popup that requests user action (see method comments below)
        [self displayAlertView];
    }
    else
    {
        // if touch ended somewhere not on any button
        
        // remove the older games table view browser (if present)
        [_tbv removeFromSuperview];

        // reset all the buttons to untouched state (required for touchesMoved)
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
    }
}

// called when a touch moves/slides
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    SKNode *currentNode = [self nodeAtPoint:currentLocation];
    SKNode *previousNode = [self nodeAtPoint:previousLocation];
    
    // Check if one of the buttons was being pressed but isn't any more
    if (currentNode.name == NULL && [self nodeIsButton:previousNode.name])
    {
        // reset all the buttons to untouched state
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
    }
    else if ([self nodeIsButton:currentNode.name] && previousNode.name == NULL)
    {
        // for when wasn't touching a button but moved/swiped onto one
        
        // figure out which button is now pressed and update its image
        if ([currentNode.name isEqualToString:@"babyGameButton"] ||
            [currentNode.name isEqualToString:@"babyGameButtonPressed"])
        {
            _babyGameButton.hidden = true;
            _babyGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"targetGameButton"] ||
                 [currentNode.name isEqualToString:@"targetGameButtonPressed"])
        {
            _targetGameButton.hidden = true;
            _targetGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"fetchGameButton"] ||
                 [currentNode.name isEqualToString:@"fetchGameButtonPressed"])
        {
            _fetchGameButton.hidden = true;
            _fetchGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"therapistMenuButton"] ||
                 [currentNode.name isEqualToString:@"therapistMenuButtonPressed"])
        {
            _therapistMenuButton.hidden = true;
            _therapistMenuButtonPressed.hidden = false;
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Add Buttons, Labels and Background to Scene
//-------------------------------------------------------------------------------------------------------------------------------------

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .5;
    bgImage.yScale = .5;
    [self addChild:bgImage];
}

-(void)addBabyGameButton
{
    // unpressed baby game button icon
    _babyGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButton.png"];
    _babyGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 250,
                                           CGRectGetMidY(self.frame) + 250);
    _babyGameButton.xScale = .5;
    _babyGameButton.yScale = .5;
    _babyGameButton.name = @"babyGameButton";
    [self addChild:_babyGameButton];
    
    // pressed baby game button icon
    _babyGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButtonPressed.png"];
    _babyGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 250,
                                                  CGRectGetMidY(self.frame) + 250);
    _babyGameButtonPressed.xScale = .5;
    _babyGameButtonPressed.yScale = .5;
    _babyGameButtonPressed.name = @"babyGameButtonPressed";
    _babyGameButtonPressed.hidden = true;
    [self addChild:_babyGameButtonPressed];

}

-(void)addTargetGameButton
{
    // unpressed target game button icon
    _targetGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButton.png"];
    _targetGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                             CGRectGetMidY(self.frame) + 105);
    _targetGameButton.xScale = .5;
    _targetGameButton.yScale = .5;
    _targetGameButton.name = @"targetGameButton";
    [self addChild:_targetGameButton];
    
    // pressed target game button icon
    _targetGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButtonPressed.png"];
    _targetGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                                    CGRectGetMidY(self.frame) + 105);
    _targetGameButtonPressed.xScale = .5;
    _targetGameButtonPressed.yScale = .5;
    _targetGameButtonPressed.name = @"targetGameButtonPressed";
    _targetGameButtonPressed.hidden = true;
    [self addChild:_targetGameButtonPressed];
}

-(void)addFetchGameButton
{
    // unpressed fetch game button icon
    _fetchGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButton.png"];
    _fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                            CGRectGetMidY(self.frame) + 20);
    _fetchGameButton.xScale = .5;
    _fetchGameButton.yScale = .5;
    _fetchGameButton.name = @"fetchGameButton";
    [self addChild:_fetchGameButton];
    
    // pressed fetch game button icon
    _fetchGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButtonPressed.png"];
    _fetchGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                                   CGRectGetMidY(self.frame) + 20);
    _fetchGameButtonPressed.xScale = .5;
    _fetchGameButtonPressed.yScale = .5;
    _fetchGameButtonPressed.name = @"fetchGameButtonPressed";
    _fetchGameButtonPressed.hidden = true;
    [self addChild:_fetchGameButtonPressed];
}

-(void)addTherapistMenuButton
{
    // unpressed therapist button
    _therapistMenuButton = [[SKSpriteNode alloc]  initWithImageNamed:@"therapistMenuButton.png"];
    _therapistMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                CGRectGetMidY(self.frame) - 180);
    _therapistMenuButton.xScale = .5;
    _therapistMenuButton.yScale = .5;
    _therapistMenuButton.name = @"therapistMenuButton";
    [self addChild:_therapistMenuButton];
    
    // pressed therapist menu button icon
    _therapistMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"therapistMenuButtonPressed.png"];
    _therapistMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                       CGRectGetMidY(self.frame) - 180);
    _therapistMenuButtonPressed.xScale = .5;
    _therapistMenuButtonPressed.yScale = .5;
    _therapistMenuButtonPressed.name = @"therapistMenuButtonPressed";
    _therapistMenuButtonPressed.hidden = true;
    [self addChild:_therapistMenuButtonPressed];
}

// adds user first name and first letter of last name to top of scene (e.g. Brutus B. for Brutus Buckeye)
-(void)addUserInfo
{
    // first name and last name have already been initialized by loadSettingsInfo (see method comments below)
    NSString *lastInitial = @"";
    if (_lastName.length > 0)
    {
        lastInitial = [_lastName substringToIndex:1];
        lastInitial = [lastInitial stringByAppendingString:@"."];
    }
    NSString *wholeName = [[_firstName stringByAppendingString:@" "]
                           stringByAppendingString:lastInitial];
    
    // create a label node for the first name and last name initial and add it to the scene
    NSString *usernameLabelText = [[@"Playing as " stringByAppendingString:@" "]
                                   stringByAppendingString:wholeName];
    SKLabelNode *usernameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    usernameLabel.name = @"usernameLabel";
    usernameLabel.text = usernameLabelText;
    usernameLabel.fontSize = 20;
    usernameLabel.fontColor = [SKColor blackColor];
    usernameLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 200,
                                         CGRectGetMidY(self.frame)+ 250);
    [self addChild:usernameLabel];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                              Simple Utility Functions
//-------------------------------------------------------------------------------------------------------------------------------------

// checks if the given node name is one of the buttons
-(bool)nodeIsButton:(NSString *)previousNodeName
{
    return [previousNodeName isEqualToString:@"babyGameButton"] ||
    [previousNodeName isEqualToString:@"babyGameButtonPressed"] ||
    [previousNodeName isEqualToString:@"targetGameButton"] ||
    [previousNodeName isEqualToString:@"targetGameButtonPressed"] ||
    [previousNodeName isEqualToString:@"fetchGameButton"] ||
    [previousNodeName isEqualToString:@"fetchGameButtonPressed"] ||
    [previousNodeName isEqualToString:@"therapistMenuButton"] ||
    [previousNodeName isEqualToString:@"therapistMenuButtonPressed"];
}

// reads in the first name, last name, therapist email and enable sound fields from the settings app
// and updates class variables accordingly
-(void)loadSettingsInfo
{
    //get user's settings from the app settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    // update class variables
    _firstName = [defaults objectForKey:@"firstName"];
    _lastName = [defaults objectForKey:@"lastName"];
    _therapistEmail = [defaults objectForKey:@"therapistEmail"];
    _enableSound = [[defaults objectForKey:@"enableSound"] boolValue];
}

// add all .zip files in the logs directory to the zip files array
-(void)addZipFilesToArray
{
    // initialize the zip files array
    _zipFilesArray = [[NSMutableArray alloc]init];
    
    // find the logs directory path (if it exists)
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"logs"];
    
    // make the logs directory if it doesn't already exist
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    NSString *extension = @"zip";
    // iterate over all the files in the logs directory
    for(NSString *file in files)
    {
        // only add files with .zip extension to zip files array
        if([[file pathExtension] isEqualToString:extension])
        {
            [_zipFilesArray addObject:file];
        }
    }
}

// delete all .csv log files in the logs directory
-(void)deleteLogFiles:(NSString *)logDirectoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // iterate over all files in the log files array
    for (NSString *file in _logFiles)
    {
        // remove each file in log files from the logs directory
        NSError *error;
        NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", logDirectoryPath, file];
        BOOL success = [fileManager removeItemAtPath:fullFilePath error:&error];
        if(!success)
            NSLog(@"unable to delete file %@ because %@", fullFilePath, [error description]);
        else
            NSLog(@"sucessfully deleted file %@", fullFilePath);
    }
    // clear the log files array
    [_logFiles removeAllObjects];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                    Application Lifecycle Stuff (becoming active/inactive)
//-------------------------------------------------------------------------------------------------------------------------------------

// add this scene to the notification center to be notified when app becomes active
-(void)addToNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

// remove this scene from the notification center for app becoming active notifications
// (this is a bug fix for app crashing issue)
-(void)removeFromNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

// called when this view is presented
- (void)didMoveToView:(SKView *)view
{
    // check user name and therapist email before allowing to play a game
    [self loadSettingsInfo];
    [UtilityClass checkSettings];
}

// called when about to navigate away from this view
-(void)willMoveFromView:(SKView *)view
{
    // remove this class from the notification center
    [self removeFromNotificationCenter];
}

// called when the app becomes active again
-(void)appBecameActive:(NSNotification *)notification
{
    // remove the current text label showing first name and last name initial
    [[self childNodeWithName:@"usernameLabel"] removeFromParent];
    // create a new text label with the updated first name and last name initial
    [self loadSettingsInfo];
    [self addUserInfo];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                           Email Therapist Logic and Popups
//-------------------------------------------------------------------------------------------------------------------------------------

// display a popup with options to zip + send recent game log files or send previously zipped game log files
-(void)displayAlertView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Send Log Files To Therapist"
                                                             delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"Send Recent Games"];
    [actionSheet addButtonWithTitle:@"Send Older Games"];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

// called when one of the two buttons in the UIActionSheet ("Send Recent Games" or "Send Older Games")
// is clicked and performs the appropriate actions
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // figure out which button was clicked ("Send Recent Games" = 0 and "Send Older Games" = 1)
    if (buttonIndex == 0)
    {
        // user wants to send recent games
        
        // get the log files directory path
        NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]   stringByAppendingPathComponent:@"logs"];
        
        // try to zip the log files there
        NSString *zipFile = [self zipFilesAtPath:folderPath];
        //   zipFile = "No files to compress" when no log files to zip
        //           = "" if there was an error when zipping the files
        //           = zip file name otherwise
        
        // if there are no files to compress, then alert the user and don't open up email
        if ([zipFile isEqualToString:@"No files to compress"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"No recent game files.\n Maybe they were already moved to Older Games?"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else if (zipFile.length == 0)
        {
            // if there was an error during compression, then alert the user and don't open up email
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"An error occured while compressing recent games"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            // open up email and attach the zip file
            [self emailZipFile:zipFile];
        }
    }
    else if (buttonIndex == 1)
    {
        // user wants to send already zipped games
        
        // check if the zipped games table view browser is already displayed
        if ([_tbv superview] == nil)
        {
            // add in all zip files in the logs directory to the zip files array
            [self addZipFilesToArray];
            
            // add a table view listing all of these files to the view
            _tbv = [[UITableView alloc] initWithFrame:CGRectMake(250, 200, self.frame.size.height/2, self.frame.size.width/2)];
            _tbv.delegate = self;
            _tbv.dataSource = self;
            [self.view addSubview:_tbv];
        }
        else
        {
            // don't really need to do anything, don't think this case is possible but w/e
        }
    }
}

// zips all .csv files in the logs directory (if any) into one zip file
-(NSString *)zipFilesAtPath:(NSString *)directoryPath
{
    // clear array of log files (if any) and reinitialize
    [_logFiles removeAllObjects];
    _logFiles = [[NSMutableArray alloc] init];
    
    // format the zip file name
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM-dd-yyyy_HH-mm"];
    NSString *currentDate = [DateFormatter stringFromDate:[NSDate date]];
    NSString *zipFileName = [NSString stringWithFormat:@"%@_%@_%@.zip", _firstName, _lastName, currentDate];
    
    // prepare to open up logs directory
    BOOL isDir = NO;
    BOOL noFilesToCompress = false;
    NSArray *fileNames;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir)
    {
        // get the names of all the files in the logs directory (.csv and .zip)
        fileNames = [fileManager subpathsAtPath:directoryPath];
        
        // add all log files (.csv) to logFiles array
        for (NSString *fileName in fileNames)
        {
            NSArray *nameAndExtension = [fileName componentsSeparatedByString:@"."];
            NSString *extension = nameAndExtension[[nameAndExtension count]-1];
            NSString *fullPath = [directoryPath stringByAppendingPathComponent:fileName];
            if (![extension isEqualToString:@"csv"])
            {
                // ignore non .csv files (e.g. already zipped files .zip)
                continue;
            }
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
            {
                // add .csv file names to the log files array
                [_logFiles addObject:fileName];
            }
        }
    }
    else
    {
        // if the logs directory hasn't been created yet (e.g. no logs have been made yet)
        noFilesToCompress = true;
    }

    // alert if there are no log files and return early (calling method shows the alert)
    if (noFilesToCompress || [_logFiles count] == 0)
    {
        return @"No files to compress";
    }
    
    // get the full path to the zip file
    NSString *archivePath = [NSString stringWithFormat:@"%@/%@", directoryPath, zipFileName];

    // create the utility to zip the files together
    ZipArchive *archiver = [[ZipArchive alloc] init];
    
    // create an empty zip file
    [archiver CreateZipFile2:archivePath];
    
    // add each log file to the zip file
    for(NSString *fileName in _logFiles)
    {
        // get the full file path and add it to the zip file
        NSString *longPath = [directoryPath stringByAppendingPathComponent:fileName];
        [archiver addFileToZip:longPath newname:fileName];
    }
    
    // compress the zip file and check its exit flag
    BOOL successCompressing = [archiver CloseZipFile2];
    if (successCompressing)
    {
        // files successfully compressed, delete old .csv logs
        [self deleteLogFiles:directoryPath];
        // return the full path to the zip file
        return archivePath;
    }
    else
    {
        // compression failed for some reason...
        return @"";
    }
}

// open up a mail composer view with the given zip file attached and text fields autopopulated
-(void)emailZipFile:(NSString *)zipFilePath
{
    // extract the zip file name from the full path
    NSArray *parts = [zipFilePath componentsSeparatedByString:@"/"];
    NSString *zipFile = parts[[parts count]-1];

    // create a mail composer view and autopopulate the fields
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    // usually can use "if ([composer canSendMail])" to check if user has e-mail account setup yet
    // but for w/e reason I am getting errors with this (no longer supported in iOS7?)
    
    // populate the fields
    NSArray *recipients = @[_therapistEmail];
    [composer setToRecipients:recipients];
    [composer setSubject:@"re: My game logs from KidologyApp"];
    NSString *messageBody = @"Hello,\n Here are my game log files from today.";
    [composer setMessageBody:messageBody isHTML:NO];
    
    // attach zip file to message
    NSData *zipData = [NSData dataWithContentsOfFile:zipFilePath];
    [composer addAttachmentData:zipData mimeType:@"application/zip" fileName:zipFile];
    composer.navigationBar.barStyle = UIBarStyleBlack;
    
    // present the compose mail view
    [self.view.window.rootViewController presentModalViewController:composer animated:YES];
    [composer release];
}

// Dismisses the email composition interface when users tap Cancel or Send
// Proceeds to create a popup to inform the user of the success (or failure) of the operation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with sending the email (e.g. sending cancelled, sent to outbox, etc.)
    NSString *message = @"";
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            message = @"Log files zipped and moved to Older Games";
            break;
        }
        case MFMailComposeResultSaved:
        {
            message = @"Email Succesfully Saved To Drafts!\n Please send it soon!";
            break;
        }
        case MFMailComposeResultSent:
        {
            message = @"Email Succesfully Sent To Outbox!\n Go to Mail to make sure it sends!";
        }
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            message = @"Sending Failed - Unknown Error :-(\n  Log Files zipped and moved to Older Games";
            break;
        }
    }
    
    // display a popup saying what happened (good or bad)
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------
//                                            UITableView Stuff (for listing zipped game files)
//-------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// tells the table view how many rows to init with
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _zipFilesArray.count;
    
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
    cell.textLabel.text = [self.zipFilesArray objectAtIndex:indexPath.row];
    
    return cell;
}

// called when user selects a row in the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *zipFileName = [self.zipFilesArray objectAtIndex:indexPath.row];
    [_tbv removeFromSuperview];
    // get the log files directory path1
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]   stringByAppendingPathComponent:@"logs"];
    NSString *fullPathToZipFile = [NSString stringWithFormat:@"%@/%@", folderPath, zipFileName];
    [self emailZipFile:fullPathToZipFile];
}

// creates a title for the table view
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"SELECT A ZIP FILE";
}


@end
