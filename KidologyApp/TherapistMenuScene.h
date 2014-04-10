//
//  TherapistMenuScene.h
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/7/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <MessageUI/MessageUI.h>

@interface TherapistMenuScene : SKScene <MFMailComposeViewControllerDelegate> 
@property (nonatomic) SKSpriteNode *uploadButton;
@property (nonatomic) SKSpriteNode *backButton;
@property (nonatomic) SKSpriteNode *pressedBackButton;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *therapistEmail;



@end
