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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"settingsScreen.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// advances thru input fields when user hits return in text field
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
    if (firstName == NULL || firstName.length == 0||
        lastName == NULL  || lastName.length == 0 ||
        therapistEmail == NULL || therapistEmail.length == 0)
    {
        errorMessage = @"Missing a required field!";
    }
    else
    {
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


- (IBAction)returnToMenuViewController:(id)sender {
    NSString *errorMessage = [self checkFields];
    if (errorMessage.length != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:errorMessage
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        //        [alert release];
        return;
    }
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:affectedHand forKey:@"affectedHand"];
    [defaults setObject:therapistEmail forKey:@"therapistEmail"];
    [defaults setObject:firstName forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastName"];
    
    [defaults synchronize];
    [self performSegueWithIdentifier:@"returnToMenuViewController" sender:self];
    //[self performSegueWithIdentifier:@"UnwindFromSecondView" sender:self];
}

@end
