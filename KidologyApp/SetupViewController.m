//
//  SetupViewController.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "SetupViewController.h"
NSUserDefaults *defaults;
NSString *affectedHand;
NSString *therapistEmail;
NSString *firstName;
NSString *lastName;


#import "MainMenuScene.h"

@implementation SetupViewController : ViewController
- (IBAction)therapistInfo:(UITextField *)sender
{
    therapistEmail = sender.text;
}
- (IBAction)firstNameInfo:(UITextField *)sender
{
    firstName = sender.text;
}
- (IBAction)lastNameInfo:(UITextField *)sender
{
    lastName = sender.text;
}
- (IBAction)affectedHand:(UISwitch *)sender {

    if([sender isOn])
    {
        affectedHand = @"right";
    }
    else
    {
        affectedHand = @"left";
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
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:affectedHand forKey:@"affectedHand"];
    [defaults setObject:therapistEmail forKey:@"therapistEmail"];
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastName"];

    [defaults synchronize];
    [self performSegueWithIdentifier:@"unwindToMenuViewController" sender:self];
}

// advances thru input fields when user hits return in text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.firstName) {
        [self.lastName becomeFirstResponder];
    } else if(textField == self.lastName) {
        [self.lastName resignFirstResponder];
    } else if(textField == self.therapistEmail) {
        [self.therapistEmail resignFirstResponder];
    }
    return NO;
}

@end
