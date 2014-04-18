//
//  SetupViewController.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this class is called during the app launch/activate sequence when the user has empty
// first name, last name and therapist email fields in the settings app

#import "SetupViewController.h"
#import "MainMenuScene.h"
NSUserDefaults *defaults;
NSString *affectedHand;
NSString *therapistEmail;
NSString *firstName;
NSString *lastName;



@implementation SetupViewController : ViewController

// actions for the storyboard buttons
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

// default initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called when view is displaued
- (void)viewDidLoad
{
    [super viewDidLoad];
    // set the background image to be our custom image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"settingsScreen.png"]];
}

// autogenerated method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// advance thru input fields when user hits return in text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.firstName) {
        [self.lastName becomeFirstResponder];
    } else if(textField == self.lastName) {
        [self.therapistEmail becomeFirstResponder];
    } else if(textField == self.therapistEmail) {
        [self.therapistEmail resignFirstResponder];
    }
    return NO;
}

// check input fields before proceeding to main menu
- (NSString *)checkFields
{
    NSString *errorMessage = @"";
    
    // check for empty text field
    if (firstName == NULL || firstName.length == 0||
        lastName == NULL  || lastName.length == 0 ||
        therapistEmail == NULL || therapistEmail.length == 0)
    {
        errorMessage = @"Missing a required field!";
    }
    else
    {
        // check email format
        NSError *error = NULL;
        // pattern regex courtesy of: https://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address
        NSString *pattern = @"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:pattern
                                      options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:therapistEmail
                                      options:0
                                      range:NSMakeRange(0, [therapistEmail length])];
        if (numberOfMatches == 0)
        {
            errorMessage = @"Invalid email format";
        }
    }
    return errorMessage;
}

// action connected to save button in storyboard
- (IBAction)returnToMenuViewController:(id)sender {
    // check the input fields
    NSString *errorMessage = [self checkFields];
    if (errorMessage.length != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:errorMessage
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    // if the input fields are all OK, save the settings to the settings app
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:affectedHand forKey:@"affectedHand"];
    [defaults setObject:therapistEmail forKey:@"therapistEmail"];
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastName"];
    [defaults synchronize];
    
    // then segue back to the main controller (which will present the main menu scene)
    [self performSegueWithIdentifier:@"returnToMenuViewController" sender:self];
}

@end
