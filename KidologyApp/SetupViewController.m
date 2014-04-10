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
    NSLog(@"In therapistInfo with %@", sender.text);
    therapistEmail = sender.text;
}
- (IBAction)firstNameInfo:(UITextField *)sender
{
    NSLog(@"In firstNameInfo with %@", sender.text);

    firstName = sender.text;
}
- (IBAction)lastNameInfo:(UITextField *)sender
{
    NSLog(@"In lastNameInfo with %@", sender.text);

    lastName = sender.text;
}
- (IBAction)affectedHand:(UISwitch *)sender {
//    if ([defaults objectForKey:@"affectedHand"] != NULL)
//    {
//        affectedHand = [defaults objectForKey:@"affectedHand"];
//        if ([affectedHand isEqual: @"right"])
//        {
//            [sender setOn:YES animated:YES];
//        }
//        // otherwise, switch will default to the left position
//    }

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
    
    NSLog(@"updating settings fields!");
    //[self.navigationController popToRootViewControllerAnimated:YES];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:affectedHand forKey:@"affectedHand"];
    [defaults setObject:therapistEmail forKey:@"therapistEmail"];
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastName"];

    [defaults synchronize];
    [self performSegueWithIdentifier:@"unwindToMenuViewController" sender:self];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
