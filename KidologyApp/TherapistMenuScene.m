//
//  TherapistMenuScene.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/7/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TherapistMenuScene.h"
#import "SetupViewController.h"
#import "ZipArchive.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "MainMenuScene.h"

@implementation TherapistMenuScene
-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        [self addBackground];
        [self addUploadButton];
        [self addBackButton];
        [self loadSettingsInfo];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // if one of the buttons is pressed, change its color
    if ([node.name isEqualToString:@"uploadButton"] ||
        [node.name isEqualToString:@"uploadButtonLabel"])
    {
        _uploadButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"backButton"] ||
             [node.name isEqualToString:@"pressedBackButton"])
    {
        _backButton.hidden = true;
        _pressedBackButton.hidden = false;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"uploadButton"] ||
        [node.name isEqualToString:@"uploadButtonLabel"])
    {
        NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]   stringByAppendingPathComponent:@"logs"];
        [self listFileAtPath:folderPath];
        NSString *zipFile = [self zipFilesAtPath:folderPath];
        [self emailZipFile:zipFile];
//        [self listFileAtPath:folderPath];
        _uploadButton.color = [SKColor redColor];
    }
    else if ([node.name isEqualToString:@"backButton"] ||
             [node.name isEqualToString:@"backButtonLabel"])
    {
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:mainMenu];
    }
    else
    {
        _pressedBackButton.hidden = true;
        _backButton.hidden = false;
    }
}

-(NSString *)zipFilesAtPath:(NSString *)path
{
    BOOL isDir = NO;
    NSArray *subpaths;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir)
    {
        subpaths = [fileManager subpathsAtPath:path];
    }
    NSString *archivePath = [path stringByAppendingString:@"/test.zip"];
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    NSLog(@"num paths found is %d", [subpaths count]);
    int i = 0;
    for(NSString *subpath in subpaths)
    {
        NSLog(@"subpath %d is %@", i, subpath);
        i++;
        // ignore previously zipped files
        NSArray *nameAndExtension = [subpath componentsSeparatedByString:@"."];
        NSString *extension = nameAndExtension[[nameAndExtension count]-1];
        NSString *longPath = [path stringByAppendingPathComponent:subpath];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:subpath];      
        }
    }
    NSLog(@"compressing...");
    BOOL successCompressing = [archiver CloseZipFile2];
    if (successCompressing)
    {
        NSLog(@"successful compression! ");
        return archivePath;
    }
    else
    {
        NSLog(@"UNSUCCESSFUL compression! ");
        return @"";
    }
}

-(void)emailZipFile:(NSString *)zipFilePath
{
    NSLog(@"zip file path is %@", zipFilePath);
    NSArray *parts = [zipFilePath componentsSeparatedByString:@"/"];
    NSString *zipFile = parts[[parts count]-1];
    NSLog(@"NOW zip file name is %@", zipFile);

    NSArray *recipients = @[_therapistEmail];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    // want to be able to use
    // if ([composer canSendMail]) ... to check if user has e-mail account setup yet
    
    // populate the fields
    [composer setToRecipients:recipients];
    [composer setSubject:@"testing out app2"];
    [composer setMessageBody:@"Hello, here are my game files from today" isHTML:NO];
    NSData *zipData = [NSData dataWithContentsOfFile:zipFilePath];
    [composer addAttachmentData:zipData mimeType:@"application/zip" fileName:zipFile];
    composer.navigationBar.barStyle = UIBarStyleBlack;
    [self.view.window.rootViewController presentModalViewController:composer animated:YES];
    [composer release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Email Successfully Sent!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];

            break;
        }
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
            break;
    }
    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
}


-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSString *file = [directoryContent objectAtIndex:count];
        NSLog(@"File %d: %@", (count + 1), file);
    }
    NSLog(@"found %d files", count);

    return directoryContent;
}


-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"therapistScreen"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
}

-(void)addUploadButton
{
    // add browse button to scene
    _uploadButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor]
                                                   size:CGSizeMake(200, 40)];
    _uploadButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                CGRectGetMidY(self.frame) - 200);
    _uploadButton.name = @"uploadButton";
    NSString *uploadButtonText = [NSString stringWithFormat:@"Upload Games"];
    SKLabelNode *uploadButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    uploadButtonLabel.name = @"uploadButtonLabel";
    uploadButtonLabel.text = uploadButtonText;
    uploadButtonLabel.fontSize = 24;
    uploadButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                             CGRectGetMidY(self.frame)-200);
    [self addChild:_uploadButton];
    [self addChild:uploadButtonLabel];
}

-(void)addBackButton
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

-(void)loadSettingsInfo
{
    //get user's first and last name and therapist's email address from the app settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _firstName = [defaults objectForKey:@"firstName"];
    _lastName = [defaults objectForKey:@"lastName"];
    _therapistEmail = [defaults objectForKey:@"therapistEmail"];
}

@end
