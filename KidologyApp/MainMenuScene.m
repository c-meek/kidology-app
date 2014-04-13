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
#import "SettingsMenuScene.h"
#import "MenuViewController.h"


@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // add game and menu buttons to screen
        [self addBackground];
        [self addBabyGameButton];
        [self addTargetGameButton];
        [self addFetchGameButton];
        [self addTherapistMenuButton];
        [self addSettingsMenuButton];
        
        // check user name and add user name label to corner
        [self addUserInfo];
    }
    return self;
}

// check user name and therapist email before allowing to play a game
- (void)didMoveToView:(SKView *)view
{
    [self checkNameAndEmail];
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
    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        _targetGameButton.hidden = true;
        _targetGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
        [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        _fetchGameButton.hidden = true;
        _fetchGameButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        _therapistMenuButton.hidden = true;
        _therapistMenuButtonPressed.hidden = false;
    }
    else if ([node.name isEqualToString:@"settingsMenuButton"] ||
             [node.name isEqualToString:@"settingsMenuButtonPressed"])
    {
        _settingsMenuButton.hidden = true;
        _settingsMenuButtonPressed.hidden = false;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];

    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"babyGameButton"] ||
        [node.name isEqualToString:@"babyGameButtonPressed"])
    {
        // Create and configure the "baby game" scene.
        SKScene * babyGame = [[BabyMenuScene alloc] initWithSize:self.size];
        babyGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:babyGame transition:reveal];

    }
    else if ([node.name isEqualToString:@"targetGameButton"] ||
             [node.name isEqualToString:@"targetGameButtonPressed"])
    {
        // Create and configure the "game menu" scene.
        SKScene * targetGame = [[TargetPracticeMenuScene alloc] initWithSize:self.size];
        targetGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:targetGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"fetchGameButton"] ||
             [node.name isEqualToString:@"fetchGameButtonPressed"])
    {
        // Create and configure the fetch game menu scene.
        SKScene * fetchGame = [[FetchScene alloc] initWithSize:self.size];
        fetchGame.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:fetchGame transition:reveal];
    }
    else if ([node.name isEqualToString:@"therapistMenuButton"] ||
             [node.name isEqualToString:@"therapistMenuButtonPressed"])
    {
        // Create and configure the therapist menu scene.
        SKScene * therapistMenu = [[TherapistMenuScene alloc] initWithSize:self.size];
        therapistMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:therapistMenu transition:reveal];
    }
    else if ([node.name isEqualToString:@"settingsMenuButton"] ||
             [node.name isEqualToString:@"settingsMenuButtonPressed"])
    {
        // Create and configure the "settings menu" scene.
        SKScene * settingsMenu = [[SettingsMenuScene alloc] initWithSize:self.size];
        settingsMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:settingsMenu transition:reveal];
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
        _settingsMenuButton.hidden = false;
        _settingsMenuButtonPressed.hidden = true;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch moves/slides */
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    SKNode *currentNode = [self nodeAtPoint:currentLocation];
    SKNode *previousNode = [self nodeAtPoint:previousLocation];
    
    // Check if one of the buttons was being pressed but isn't any more
    if (currentNode.name == NULL && [self nodeIsButton:previousNode.name])
    {
        NSLog(@"moved off a button");
        _targetGameButton.hidden = false;
        _targetGameButtonPressed.hidden = true;
        _babyGameButton.hidden = false;
        _babyGameButtonPressed.hidden = true;
        _fetchGameButton.hidden = false;
        _fetchGameButtonPressed.hidden = true;
        _therapistMenuButton.hidden = false;
        _therapistMenuButtonPressed.hidden = true;
        _settingsMenuButton.hidden = false;
        _settingsMenuButtonPressed.hidden = true;
    }
    else if ([self nodeIsButton:currentNode.name] && previousNode.name == NULL)
    {
        NSLog(@"moved onto button %@", currentNode.name);
        // for when wasn't touching a button but moved/swiped onto one
        // figure out which button is pressed and change its color
        if ([currentNode.name isEqualToString:@"babyGameButton"] ||
            [currentNode.name isEqualToString:@"babyGameButtonPressed"])
        {
            _babyGameButton.hidden = true;
            _babyGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"targetGameButton"] ||
                 [currentNode.name isEqualToString:@"targetGameButtonPressed"])
        {
            _targetGameButton.hidden = true;
            _targetGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"fetchGameButton"] ||
                 [currentNode.name isEqualToString:@"fetchGameButtonPressed"])
        {
            _fetchGameButton.hidden = true;
            _fetchGameButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"therapistMenuButton"] ||
                 [currentNode.name isEqualToString:@"therapistMenuButtonPressed"])
        {
            _therapistMenuButton.hidden = true;
            _therapistMenuButtonPressed.hidden = false;
        }
        else if ([currentNode.name isEqualToString:@"settingsMenuButton"] ||
                 [currentNode.name isEqualToString:@"settingsMenuButtonPressed"])
        {
            _settingsMenuButton.hidden = true;
            _settingsMenuButtonPressed.hidden = false;
        }
    }
}


// ------------------------------------------------------------------------------------
//                             ADD BACKGROUND AND BUTTONS
// ------------------------------------------------------------------------------------

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
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
    _therapistMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                CGRectGetMidY(self.frame) - 40);
    _therapistMenuButton.xScale = .38;
    _therapistMenuButton.yScale = .38;
    _therapistMenuButton.name = @"therapistMenuButton";
    [self addChild:_therapistMenuButton];
    
    // pressed therapist menu button icon
    _therapistMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"therapistMenuButtonPressed.png"];
    _therapistMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                       CGRectGetMidY(self.frame) - 40);
    _therapistMenuButtonPressed.xScale = .38;
    _therapistMenuButtonPressed.yScale = .38;
    _therapistMenuButtonPressed.name = @"therapistMenuButtonPressed";
    _therapistMenuButtonPressed.hidden = true;
    [self addChild:_therapistMenuButtonPressed];
}

-(void)addSettingsMenuButton
{
    // settings menu button
    _settingsMenuButton = [[SKSpriteNode alloc]  initWithImageNamed:@"settingsMenuButton.png"];
    _settingsMenuButton.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                CGRectGetMidY(self.frame) - 180);
    _settingsMenuButton.xScale = .38;
    _settingsMenuButton.yScale = .38;
    _settingsMenuButton.name = @"settingsMenuButton";
    [self addChild:_settingsMenuButton];
    
    // pressed settings menu button icon
    _settingsMenuButtonPressed = [[SKSpriteNode alloc] initWithImageNamed:@"settingsMenuButtonPressed.png"];
    _settingsMenuButtonPressed.position = CGPointMake(CGRectGetMidX(self.frame) + 275,
                                                       CGRectGetMidY(self.frame) - 180);
    _settingsMenuButtonPressed.xScale = .38;
    _settingsMenuButtonPressed.yScale = .38;
    _settingsMenuButtonPressed.name = @"settingsMenuButtonPressed";
    _settingsMenuButtonPressed.hidden = true;
    [self addChild:_settingsMenuButtonPressed];
}

//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//}



-(void)addUserInfo
{
    // get user's first and last names + therapist email from settings bundle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [[defaults objectForKey:@"firstName"] stringByAppendingString:@" "];
    NSString *lastName = [defaults objectForKey:@"lastName"];
    
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

// ------------------------------------------------------------------------------------
//                             DATA CHECKING LOGIC
// ------------------------------------------------------------------------------------

-(void)checkNameAndEmail
{
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
        UIAlertView *mustUpdateNameAlert = [[UIAlertView alloc]initWithTitle:@"ERROR:"
                                                                     message:message
                                                                    delegate:self
                                                           cancelButtonTitle:@"Close"
                                                           otherButtonTitles:nil];
        [mustUpdateNameAlert show];
    }
}

// present settings menu scene when alert view closed
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // in the old days you could redirect to the settings app, but no more...
        // instead, redirect to our settings menu scene
        // Create and configure the "settings menu" scene.
        SKScene * settingsMenu = [[SettingsMenuScene alloc] initWithSize:self.size];
        settingsMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
        [self.view presentScene:settingsMenu transition:reveal];
    }
}

-(bool)nodeIsButton:(NSString *)previousNodeName
{
    return [previousNodeName isEqualToString:@"babyGameButton"] ||
        [previousNodeName isEqualToString:@"babyGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"targetGameButton"] ||
        [previousNodeName isEqualToString:@"targetGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"fetchGameButton"] ||
        [previousNodeName isEqualToString:@"fetchGameButtonPressed"] ||
        [previousNodeName isEqualToString:@"therapistMenuButton"] ||
        [previousNodeName isEqualToString:@"therapistMenuButtonPressed"] ||
        [previousNodeName isEqualToString:@"settingsMenuButton"] ||
        [previousNodeName isEqualToString:@"settingsMenuButtonPressed"];
}

@end
