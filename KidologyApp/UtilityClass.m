//
//  UtilityClass.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/13/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "UtilityClass.h"

@implementation UtilityClass

+(BOOL)checkSettings
{
    bool missingField = false;
    // get user's first and last names + therapist email from settings bundle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *therapistEmail = [defaults objectForKey:@"therapistEmail"];
    NSLog(@"delay before conversion %@", [defaults objectForKey:@"delayBetweenTargets"]);
    NSLog(@"numtargets before conversion %@", [defaults objectForKey:@"numberOfTargets"]);
    
    // trim any leading or trailing whitespace
    firstName = [firstName stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    lastName = [lastName stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    therapistEmail = [therapistEmail stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"creating message");
    // alert when one of these fields is empty/incomplete
    NSString *message = @"";
    NSLog(@"created message %@", message);

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

@end
