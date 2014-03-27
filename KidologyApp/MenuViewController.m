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
    [self loadScene];
	// Do any additional setup after loading the view.
    if (! [[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"setupSegue" sender:self];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadScene
{
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    SKScene * mainMenu = [MainMenuScene sceneWithSize:skView.bounds.size];
    mainMenu.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene: mainMenu];
}
- (IBAction)unwindToHideSettingsModal:(UIStoryboardSegue *)unwindSegue
{
    //NSLog(@"UNWILD");
}
@end
