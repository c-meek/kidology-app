//
//  SetupViewController.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "SetupViewController.h"
NSUserDefaults *defaults;
NSString *affectedHand = @"left";
NSString *therapistEmail;
@implementation SetupViewController : ViewController
- (IBAction)therapistInfo:(UITextField *)sender
{
    therapistEmail = sender.text;
}
- (IBAction)affectedHand:(UISwitch *)sender {
    
    if([sender isOn])
    {
        affectedHand = @"right";
        NSLog(@"right");
    }
    else
    {
        affectedHand = @"left";
        NSLog(@"left");
    }
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToMain:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:affectedHand forKey:@"affectedHand"];
    [defaults setObject:therapistEmail forKey:@"therapistEmail"];
    [defaults synchronize];
}

@end
