//
//  BabyTargetPracticeScene.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "BabyTargetPracticeScene.h"

@implementation BabyTargetPracticeScene

-(id)initWithSize:(CGSize)size
{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Huge_Checkered_Background_[4096x3072]"];
    [self addChild:bgImage];
    return self;
}
@end
