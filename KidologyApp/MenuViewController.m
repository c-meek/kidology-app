//
//  MenuViewController.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MenuViewController.h"
#import "MainMenuScene.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

bool isFirstLogin = true;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *therapistEmail = [defaults objectForKey:@"therapistEmail"];
    if (firstName == NULL || firstName.length == 0 ||
        lastName  == NULL || lastName.length  == 0 ||
        therapistEmail  == NULL || therapistEmail.length  == 0)
    {
        [self performSegueWithIdentifier:@"setupSegue" sender:self];
    }
    else
        [self loadScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadScene
{
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    SKScene * mainMenu = [MainMenuScene sceneWithSize:skView.bounds.size];
    mainMenu.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene: mainMenu];
}
- (IBAction)unwindToHideSettingsModal:(UIStoryboardSegue *)unwindSegue
{
    [self loadScene];
}
@end
