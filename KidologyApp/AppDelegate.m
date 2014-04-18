//
//  AppDelegate.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//


// this class is called by the system when application is transitioning between states
// (e.g. active to inactive) or is communicating with another app (e.g. email)


#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MainMenuScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate


// called when e-mail attachment opened with the app
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // call the root controllers handle open url method (doesn't really do anything but is necessary)
    MenuViewController *rootController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    if (url != nil && [url isFileURL]) {
        [rootController handleOpenURL:url];
    }
    // display an alert showing that the game file has been saved and how to access it
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Game"
                                                    message:@"Custom Game Saved.\n Open in Target Practice -> Custom Games"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    return YES;
}

// called when the application launches
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize the audio play library
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    // initialize the NSUserDefaults dictionary to read from the Settings app
    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                               URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs =
    [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    return YES;
}

// called when the application is about to become inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // deactivate the audio play library (app will crash otherwise...)
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // deactivate the audio play library (app will crash otherwise...)
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // reactivate the audio play library
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    // reactivate the audio play library
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
