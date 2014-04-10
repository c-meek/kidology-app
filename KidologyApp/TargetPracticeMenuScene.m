//
//  TargetPracticeMenuScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/20/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeMenuScene.h"
#import "TargetPracticeScene.h"
#import "MainMenuScene.h"
#import "CustomTargetPracticeScene.h"

NSString *gameName;
@implementation TargetPracticeMenuScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        gameName = nil;
        //Background here!!!
        [self addBackground]; 
        //Instructions...
        SKLabelNode *instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructionLabel.fontSize = 40;
        instructionLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+150);
        instructionLabel.text = @"Instructions:";
        [self addChild:instructionLabel];
        
        SKLabelNode *instructionContentLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        instructionContentLabel.fontSize = 20;
        instructionContentLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
        instructionContentLabel.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+110);
        instructionContentLabel.horizontalAlignmentMode = 1;
        instructionContentLabel.text = @"Touch the center of the target when it appears.";
        [self addChild:instructionContentLabel];

        // "Select Your Game Mode:"
        SKLabelNode *selectModeLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        selectModeLabel.fontSize = 35;
        selectModeLabel.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
        selectModeLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 210);
        selectModeLabel.text = @"Select Your Game Mode:";
        [self addChild:selectModeLabel];
        
        //Back Button!
        _backButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button"];
        _backButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
        _backButton.name = @"backButton";
        _backButton.xScale = .5;
        _backButton.yScale = .5;
        [self addChild:_backButton];
        
        //Pressed Back Button!
        _pressedBackButton = [[SKSpriteNode alloc] initWithImageNamed:@"Back_Button_Pressed"];
        _pressedBackButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height/2+235);
        _pressedBackButton.name = @"backButton";
        _pressedBackButton.hidden = true;
        _pressedBackButton.xScale = .5;
        _pressedBackButton.yScale = .5;
        [self addChild:_pressedBackButton];

        //Center Button!
        _centerModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _centerModeButton.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
        _centerModeButton.name = @"centerButton";
        [self addChild:_centerModeButton];
        
        _centerModeButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _centerModeButtonLabel.fontSize = 35;
        _centerModeButtonLabel.fontColor = [SKColor whiteColor];
        _centerModeButtonLabel.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/2-250);
        _centerModeButtonLabel.name = @"centerLabel";
        _centerModeButtonLabel.text = @"Center";
        _centerModeButtonLabel.verticalAlignmentMode =1;
        [self addChild:_centerModeButtonLabel];
        
        //Random Button!
        _randomModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _randomModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
        _randomModeButton.name = @"randomButton";
        [self addChild:_randomModeButton];
        
        _randomModeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _randomModeButtonLabel.fontSize = 35;
        _randomModeButtonLabel.fontColor = [SKColor whiteColor];
        _randomModeButtonLabel.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-250);
        _randomModeButtonLabel.name = @"randomLabel";
        _randomModeButtonLabel.text = @"Random";
        _randomModeButtonLabel.verticalAlignmentMode = 1;
        [self addChild:_randomModeButtonLabel];
        
        //custom mode button
        _customModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _customModeButton.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2 - 200);
        _customModeButton.name = @"customModeButton";
        [self addChild:_customModeButton];
        
        _customModeLabel = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _customModeLabel.fontSize = 35;
        _customModeLabel.fontColor = [SKColor whiteColor];
        _customModeLabel.position = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2-200);
        _customModeLabel.name = @"customModeLabel";
        _customModeLabel.text = @"Custom";
        _customModeLabel.verticalAlignmentMode = 1;
        [self addChild:_customModeLabel];
        
        //Action Button!
        _actionModeButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(140, 40)];
        _actionModeButton.position = CGPointMake(self.frame.size.width/4*2, self.frame.size.height/2-250);
        _actionModeButton.name = @"actionButton";
        [self addChild:_actionModeButton];
        
        _actionModeButtonLabel =[SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
        _actionModeButtonLabel.fontSize = 35;
        _actionModeButtonLabel.fontColor = [SKColor whiteColor];
        _actionModeButtonLabel.position = CGPointMake(self.frame.size.width/4*2, self.frame.size.height/2-250);
        _actionModeButtonLabel.name = @"actionLabel";
        _actionModeButtonLabel.text = @"Actions";
        _actionModeButtonLabel.verticalAlignmentMode = 1;
        [self addChild:_actionModeButtonLabel];
        

        _target = [SKSpriteNode spriteNodeWithImageNamed:@"green_target"];
        _target.position = (CGPointMake(self.frame.size.width/2-50, self.frame.size.height/2-82));
        _target.xScale = .4;
        _target.yScale = .15;
        [self addChild:_target];
        
        _hand = [SKSpriteNode spriteNodeWithImageNamed:@"hand"];
        _hand.position = (CGPointMake(self.frame.size.width/2+150+(self.hand.size.width/2), self.frame.size.height/2-62+(self.hand.size.height/2)));
        [self addChild:_hand];
        SKAction * moveHandOver = [SKAction moveTo:(CGPointMake(self.frame.size.width/2-50+(self.hand.size.width/2), self.frame.size.height/2-72+(self.hand.size.height/2))) duration:2];
        SKAction * pressButton = [SKAction moveTo:(CGPointMake(self.frame.size.width/2-50+(self.hand.size.width/2), self.frame.size.height/2-82+(self.hand.size.height/2))) duration:.5];
        SKAction *wait = [SKAction waitForDuration:3];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        [_hand runAction: [SKAction sequence:@[moveHandOver, pressButton, wait, actionMoveDone]]];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backLabel"])
    {
        _backButton.hidden = true;
        _pressedBackButton.hidden = false;
    }
    
    //Added another variable for Target Pratice call.
    else if ([node.name isEqualToString:@"centerLabel"] ||
             [node.name isEqualToString:@"centerButton"])
    {
        _centerModeButton.color = [SKColor yellowColor];
    }
    
    else if ([node.name isEqualToString:@"randomLabel"] ||
             [node.name isEqualToString:@"randomButton"])
    {
        _actionModeButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"customModeLabel"] ||
             [node.name isEqualToString:@"customModeButton"])
    {
        _customModeButton.color = [SKColor yellowColor];
    }
    else if ([node.name isEqualToString:@"actionModeLabel"] ||
             [node.name isEqualToString:@"actionModeButton"])
    {
        _actionModeButton.color = [SKColor yellowColor];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"backLabel"])
        {
            SKScene *backToMain = [[MainMenuScene alloc] initWithSize:self.size];
            backToMain.scaleMode = SKSceneScaleModeAspectFill;
            [_tbv removeFromSuperview];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:.5];
            [self.view presentScene:backToMain transition:reveal];
        }
    //Added another variable for Target Practice call.
    else if ([node.name isEqualToString:@"centerLabel"] ||
        [node.name isEqualToString:@"centerButton"])
    {
        // Create and configure the center "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:1];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [_tbv removeFromSuperview];
        [self.view presentScene:targetPractice];
    }
    
    else if ([node.name isEqualToString:@"randomLabel"] ||
        [node.name isEqualToString:@"randomButton"])
    {
        // Create and configure the random "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:2];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice];
    }
    else if ([node.name isEqualToString:@"actionLabel"] ||
             [node.name isEqualToString:@"actionButton"])
    {
        // Create and configure the random "target practice" scene.
        SKScene * targetPractice = [[TargetPracticeScene alloc] initWithSize:self.size game_mode:4];
        targetPractice.scaleMode = SKSceneScaleModeAspectFill;
        [_tbv removeFromSuperview];
        // Present the scene.
        [self.view presentScene:targetPractice];
    }

    else if ([node.name isEqualToString:@"customModeLabel"] || [node.name isEqualToString:@"customModeButton"])
    {
        if(nil == gameName && [_tbv superview] == nil)
        {
//            UIViewController *vc = self.view.window.rootViewController;
//            [vc performSegueWithIdentifier:@"toGameList" sender:self];
//            _customModeButton.color = [SKColor greenColor];
            [self addGameFilesToArray];
            _tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 87, self.frame.size.height, self.frame.size.width)];
            _tbv.delegate = self;
            _tbv.dataSource = self;
            [self.view addSubview:_tbv];
        }
        else
        {
            [_tbv removeFromSuperview];
        }
    }
    else
    {

        _pressedBackButton.hidden = true;
        _backButton.hidden = false;
        _centerModeButton.color = [SKColor redColor];
        _actionModeButton.color = [SKColor redColor];
        _customModeLabel.color = [SKColor redColor];
    }

}
-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .4;
    [self addChild:bgImage];
}



-(void)addGameFilesToArray
{
    _gameArray = [[NSMutableArray alloc]init];
    NSString *extension = @"csv";
    //NSString *resPath = [[NSBundle mainBundle] resourcePath];
    
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Inbox"];
    // make the folder if it doesn't already exist
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    
    
    NSString *file;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    for(file in files)
    {
        if([[file pathExtension] isEqualToString:extension])
        {
            [_gameArray addObject:file];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.gameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    gameName = [self.gameArray objectAtIndex:indexPath.row];
    [_tbv removeFromSuperview];
    SKScene *customTarget = [[CustomTargetPracticeScene alloc] initWithSize:self.size];
    customTarget.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:customTarget];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"SELECT A GAME";
}

@end
