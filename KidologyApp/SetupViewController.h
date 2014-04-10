//
//  SetupViewController.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/4/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "ViewController.h"

@interface SetupViewController : ViewController
@property(strong, nonatomic) IBOutlet UITextField *firstName;
@property(strong, nonatomic) IBOutlet UITextField *lastName;
@property(strong, nonatomic) IBOutlet UITextField *therapistEmail;
@property(strong, nonatomic) IBOutlet UISwitch *affectedHand;
@property(strong, nonatomic) IBOutlet UIButton *submit;


@end
