//
//  TargetPracticeGameOver.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/10/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "TargetPracticeGameOver.h"

@implementation TargetPracticeGameOver

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor grayColor];
        NSString *textBuffer = [NSString stringWithFormat:@"Complete! You touched %d targets in %d seconds.", _numberTouched, _timeTaken];
        _message.text = textBuffer;
        [self addChild:_message];
        
    }
    return self;
}

@end
