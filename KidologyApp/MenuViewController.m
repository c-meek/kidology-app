//
//  MenuViewController.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this class is used by the storyboard to route the user to the correct views
// for example, route to the setup view if the user hasn't setup their name and therapist email yet

#import "MenuViewController.h"
#import "MainMenuScene.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

bool isFirstLogin = true;

// default initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called when this view is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    // read in the user settings from the settings app, pick up any changes
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    // check if any required fields are missing
    NSString *firstName = [defaults objectForKey:@"firstName"];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *therapistEmail = [defaults objectForKey:@"therapistEmail"];
    
    // if missing a required field, segue to setup view to fill in these fields
    if ((firstName == NULL || firstName.length == 0) &&
        (lastName  == NULL || lastName.length  == 0) &&
        (therapistEmail  == NULL || therapistEmail.length  == 0))
    {
        [self performSegueWithIdentifier:@"setupSegue" sender:self];
    }
    else
    {
        // otherwise, route to the main menu scene
        [self loadScene];
    }
}

// autogenerated method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// action connected to segue in storyboard for when returned from setup view
- (IBAction)returnedFromSettings:(UIStoryboardSegue *)segue {
    [self loadScene];
}

// present the main menu scene
- (void)loadScene
{
    SKView * skView = (SKView *)self.view;
    // Create and configure the main menu scene
    SKScene * mainMenu = [MainMenuScene sceneWithSize:skView.bounds.size];
    mainMenu.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene: mainMenu];
}

// called when a .csv file is opened in email 
- (void)handleOpenURL:(NSURL *)url {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
