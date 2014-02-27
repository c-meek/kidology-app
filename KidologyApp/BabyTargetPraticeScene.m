//
//  BabyTargetPratice.m
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "BabyTargetPraticeScene.h"

@implementation BabyTargetPratice

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        -(id)initWithSize:(CGSize)size game_mode:(int)game_mode
        {
            SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Huge_Checkered_Background_[4096x3072]"];
            [self addChild:bgImage];
        }
}
@end
