//
//  MyScene.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MainMenuScene.h"
#import "BabyMenuScene.h"
#import "TargetPracticeMenuScene.h"
#import "FetchScene.h"
#import "TherapistMenuScene.h"
// #import "SettingsMenuScene.h"
#import "MenuViewController.h"


@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //add background
        [self addBackground];
        //add baby game button
        [self addBabyGameButton];
        //add target game button
        [self addTargetGameButton];
        //add fetch game button
        [self addFetchGameButton];
        //add therapist menu button
        [self addTherapistMenuButton];
        // add user info label to corner
        [self addUserInfo];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // if one of the buttons is pressed, change its color
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        _babyGameButton.hidden = true;
        _babyGameButtonPressed.hidden = false;
        //_gameMenuButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        _targetGameButton.hidden = true;
        _targetGameButtonPressed.hidden = false;
        //_gameMenuButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
        [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        _fetchGameButton.hidden = true;
        _fetchGameButtonPressed.hidden = false;
        //_gameMenuButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        _therapistMenuButton.hidden = true;
        _therapistMenuButtonPressed.hidden = false;
        //_gameMenuButton.color = [SKColor yellowColor];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        // Create and configure the "baby game" scene.
        SKScene * babyGame = [[BabyMenuScene alloc] initWithSize:self.size];
        babyGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:babyGame];

    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        // Create and configure the "game menu" scene.
        SKScene * targetGame = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetGame];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        // Create and configure the "game menu" scene.
        SKScene * fetchGame = [[FetchScene alloc] initWithSize:self.size];
        fetchGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:fetchGame];
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        // Create and configure the "game menu" scene.
        SKScene * therapistMenu = [[TherapistMenuScene alloc] initWithSize:self.size];
        therapistMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:therapistMenu];
    }

    else
    {
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
    }

}

-(void)addBabyGameButton
{
    // baby game button icon
    _babyGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButton.png"];
    _babyGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                           CGRectGetMidY(self.frame) + 185);
    _babyGameButton.xScale = .38;
    _babyGameButton.yScale = .38;
    _babyGameButton.name = @"babyGameButton";
    [self addChild:_babyGameButton];
    
    // pressed baby game button icon
    _babyGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"babyGameButtonPressed.png"];
    _babyGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                                  CGRectGetMidY(self.frame) + 185);
    _babyGameButtonPressed.xScale = .38;
    _babyGameButtonPressed.yScale = .38;
    _babyGameButtonPressed.name = @"babyGameButtonPressed";
    _babyGameButtonPressed.hidden = true;
    [self addChild:_babyGameButtonPressed];

}

-(void)addTargetGameButton
{
    _targetGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButton.png"];
    _targetGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                             CGRectGetMidY(self.frame) + 105);
    _targetGameButton.xScale = .38;
    _targetGameButton.yScale = .38;
    _targetGameButton.name = @"targetGameButton";
    [self addChild:_targetGameButton];
    
    // pressed target game button icon
    _targetGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"targetGameButtonPressed.png"];
    _targetGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 190,
                                                    CGRectGetMidY(self.frame) + 105);
    _targetGameButtonPressed.xScale = .38;
    _targetGameButtonPressed.yScale = .38;
    _targetGameButtonPressed.name = @"targetGameButtonPressed";
    _targetGameButtonPressed.hidden = true;
    [self addChild:_targetGameButtonPressed];
}

-(void)addFetchGameButton
{
    _fetchGameButton = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButton.png"];
    _fetchGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                            CGRectGetMidY(self.frame) + 20);
    _fetchGameButton.xScale = .38;
    _fetchGameButton.yScale = .38;
    _fetchGameButton.name = @"fetchGameButton";
    [self addChild:_fetchGameButton];
    
    // pressed fetch game button icon
    _fetchGameButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"fetchGameButtonPressed.png"];
    _fetchGameButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) - 200,
                                                   CGRectGetMidY(self.frame) + 20);
    _fetchGameButtonPressed.xScale = .38;
    _fetchGameButtonPressed.yScale = .38;
    _fetchGameButtonPressed.name = @"fetchGameButtonPressed";
    _fetchGameButtonPressed.hidden = true;
    [self addChild:_fetchGameButtonPressed];
}

-(void)addTherapistMenuButton
{
    // therapist button
    _therapistMenuButton = [[SKSpriteNode alloc]  initWithImageNamed:@"therapistMenuButton.png"];
    _therapistMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 280,
                                                CGRectGetMidY(self.frame) - 180);
    _therapistMenuButton.xScale = .38;
    _therapistMenuButton.yScale = .38;
    _therapistMenuButton.name = @"therapistMenuButton";
    [self addChild:_therapistMenuButton];
    
    // pressed therapist menu button icon
    _therapistMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"therapistMenuButtonPressed.png"];
    _therapistMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 280,
                                                       CGRectGetMidY(self.frame) - 180);
    _therapistMenuButtonPressed.xScale = .38;
    _therapistMenuButtonPressed.yScale = .38;
    _therapistMenuButtonPressed.name = @"therapistMenuButtonPressed";
    _therapistMenuButtonPressed.hidden = true;
    [self addChild:_therapistMenuButtonPressed];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
}

-(void)addUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    NSString *therapistEmail = [defaults objectForKey:@"therapistEmail"];
    
    // alert when empty/incomplete name fields
    NSString *message = @"";
  
    if (firstName == NULL || firstName.length == 0 ||
        lastName  == NULL || lastName.length  == 0)
    {
        message = @"Your name is missing in the application settings.  Without a name, your therapist could get confused! Please go to the Settings app and enter your name.";
    }
    else if (therapistEmail  == NULL || therapistEmail.length  == 0)
    {
        message = @"You have not provided an e-mail address for your therapist.  Without an e-mail address, you cannot send them your progress reports! Please go to the Settings app and enter your therapist's email.";
    }
    if (message.length > 0)
    {
        UIAlertView *mustUpdateNameAlert=
            [[UIAlertView alloc]initWithTitle:@"ERROR:"message:message
                        delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [mustUpdateNameAlert show];
        
        // in the old days you could redirect to the settings app, but no more...
        //
        return;
    }

    NSString *lastInitial = [lastName substringToIndex:1];
    lastInitial = [lastInitial stringByAppendingString:@"."];
    NSString *wholeName = [firstName stringByAppendingString:lastInitial];
    NSString *usernameLabelText = [@"Playing as " stringByAppendingString:wholeName];
    SKLabelNode *usernameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    usernameLabel.name = @"usernameLabel";
    usernameLabel.text = usernameLabelText;
    usernameLabel.fontSize = 20;
    usernameLabel.fontColor = [SKColor blackColor];
    usernameLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 200,
                                         CGRectGetMidY(self.frame)+ 250);
    [self addChild:usernameLabel];

}

@end
