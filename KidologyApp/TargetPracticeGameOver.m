//
//  TargetPracticeGameOver.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeGameOver.h"
#import "TargetPracticeScene.h"
#import "LogEntry.h"
#import "MainMenuScene.h"

@implementation TargetPracticeGameOver

-(id)initWithSize:(CGSize)size targets:(int)targets
{
    if (self = [super initWithSize:size])
    {
        [self addBackground];
        self.userData = [NSMutableDictionary dictionary];
        self.backgroundColor = [SKColor grayColor];
        NSString * messageText = [NSString stringWithFormat:@"Complete! You touched %d targets.", targets];
        SKLabelNode * message = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        message.text = messageText;
        message.fontSize = 30;
        message.fontColor = [SKColor colorWithRed:1 green:.6 blue:0 alpha:1];
        message.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:message];
        
        _backButton = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(400, 40)];
        _backButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
        _backButton.name = @"backButton";
        [self addChild:_backButton];
        
        NSString * returnText = [NSString stringWithFormat:@"Return To Game Menu"];
        _returnMessage = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _returnMessage.text = returnText;
        _returnMessage.name = @"returnTextLabel";
        _returnMessage.fontSize = 20;
        _returnMessage.fontColor = [SKColor whiteColor];
        _returnMessage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
        [self addChild:_returnMessage];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"returnTextLabel"])
    {
        _backButton.color = [SKColor yellowColor];
    }
    NSMutableArray *log;
    SKScene *scene = [self.view scene];
    log = [scene.userData objectForKey:@"touchLog"];
    //NSLog(@"%@", log[1]);
    

    
        
    NSString * output = [[NSString alloc] init];
    output = [output stringByAppendingString:@"Type,Time,Touch Location X, Touch Location Y, Target Location X, Target Location Y, Target Radius\n"];
    for (int i=0;i<log.count;i++)
    {
        LogEntry *entry = log[i];
        //NSLog(@"%d,%f,%f", entry.type, entry.targetLocation.x,entry.targetLocation.y);
        //NSString * type = typeArray[entry.type];
             //NSString * type = @"a";
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%@,%f,%f,%f,%f,%f,%f\n", entry.type, entry.time, entry.touchLocation.x, entry.touchLocation.y, entry.targetLocation.x, entry.targetLocation.y, entry.targetRadius]];
        // get the documents directory
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"logs"];
        // make the folder if it doesn't already exist
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:folderPath contents:nil attributes:nil];

        // make a file name from the current date (dd/mm/yy hh:mm:ss timezone)
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        // take out spaces
        dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
        // replace colons with hyphens
        dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        // replace slashes with hyphens
        dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSString *gameModeString = [scene.userData objectForKey: @"gameMode"];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@-%@.csv", folderPath, dateString, gameModeString];
        //NSLog(@"%@", fileName);
        //NSLog(@"%@", output);
        
        [output writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:NULL];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    // Check which button was pressed
    if ([node.name isEqualToString:@"backButton"] || [node.name isEqualToString:@"returnTextLabel"])
    {

        // Create and configure the "main menu" scene.
        SKScene * mainMenu = [[MainMenuScene alloc] initWithSize:self.size];
        mainMenu.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:mainMenu];
        
    }
    else
    {
        _backButton.color = [SKColor redColor];
    }
}

-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"targetPracticeBackground"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .4;
    bgImage.yScale = .7;
    [self addChild:bgImage];
}
@end
