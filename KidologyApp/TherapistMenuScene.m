//
//  TherapistMenuScene.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/7/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TherapistMenuScene.h"

@implementation TherapistMenuScene

-(id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        [self addBackground];
        [self addBrowseButton];
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
    if ([node.name isEqualToString:@"browseButton"] ||
        [node.name isEqualToString:@"browseButtonLabel"])
    {
        _browseButton.color = [SKColor yellowColor];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Check if one of the buttons was pressed and load that scene
    if ([node.name isEqualToString:@"browseButton"] ||
        [node.name isEqualToString:@"browseButtonLabel"])
    {
        [self listFileAtPath:@"/var/mobile/Applications/50A20629-6CE5-4033-AD18-05AB2F07F83B/Documents/Inbox/"];
        _browseButton.color = [SKColor redColor];
    }

    
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSLog(@"found %d files", [directoryContent count]);
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}


-(void)addBackground
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"therapistScreen"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.xScale = .38;
    bgImage.yScale = .38;
    [self addChild:bgImage];
}

-(void)addBrowseButton
{
    // add browse button to scene
    _browseButton = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(200, 40)];
    _browseButton.position = CGPointMake(CGRectGetMidX(self.frame) + 225,
                                                CGRectGetMidY(self.frame) - 200);
    _browseButton.name = @"browseButton";
    NSString *browseButtonText = [NSString stringWithFormat:@"Browse Files"];
    SKLabelNode *browseButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    browseButtonLabel.name = @"browseButtonLabel";
    browseButtonLabel.text = browseButtonText;
    browseButtonLabel.fontSize = 24;
    browseButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 225, CGRectGetMidY(self.frame)-210);
    [self addChild:_browseButton];
    [self addChild:browseButtonLabel];
}

@end
