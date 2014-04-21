//
//  UtilityClass.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/13/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this class is a simple utitlity class (as the name implies) and is used by other
// classes to perform repeated tasks like check if all required settings fields have
// been provided or to pick a sound to play from the list of sounds


#import "UtilityClass.h"

@implementation UtilityClass

// read in the settings from the settings app and determine if all required fields
// (e.g. first name, last name, and therapist email) have been entered
+(BOOL)checkSettings
{
    bool missingField = false;
    // get user's first and last names + therapist email from settings bundle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *therapistEmail = [defaults objectForKey:@"therapistEmail"];
    
    // trim any leading or trailing whitespace
    firstName = [firstName stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    lastName = [lastName stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    therapistEmail = [therapistEmail stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    // alert when one of these fields is empty/incomplete
    NSString *message = @"";

    if (firstName == NULL || firstName.length == 0 ||
        lastName  == NULL || lastName.length  == 0)
    {
        message = @"You have not provided a first and/or last name!";
    }
    else if (therapistEmail  == NULL || therapistEmail.length  == 0)
    {
        message = @"You have not provided an e-mail address for your therapist.";
    }
    if (message.length > 0)
    {
        missingField = true;
        UIAlertView *mustUpdateNameAlert = [[UIAlertView alloc]initWithTitle:@"ERROR:"
                                                                     message:message
                                                                    delegate:self
                                                           cancelButtonTitle:@"Close"
                                                           otherButtonTitles:nil];
        [mustUpdateNameAlert show];
    }
    return  missingField;
}

// randomly choose a sound to play from the list of sound files
+(NSString *)getSoundFile
{
    NSString *soundFile = @"";
    int r = arc4random_uniform(8);
    switch (r) {
        case 0:
            soundFile = @"metal_clang.mp3";
            break;
        case 1:
            soundFile = @"pop.mp3";
            break;
        case 2:
            soundFile = @"fire.mp3";
            break;
        case 3:
            soundFile = @"pling.mp3";
            break;
        case 4:
            soundFile = @"pop2.mp3";
            break;
        case 5:
            soundFile = @"pop3.mp3";
            break;
        case 6:
            soundFile = @"whip.mp3";
            break;
        default: // case 7:
            soundFile = @"pew.mp3";
            break;
    }
    
    return soundFile;
}


@end
