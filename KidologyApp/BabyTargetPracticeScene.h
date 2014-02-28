//
//  BabyTargetPracticeScene.h
//  KidologyApp
//
//  Created by ngo, tien dong on 2/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BabyTargetPracticeScene : SKScene
@property (nonatomic) SKSpriteNode * target;
@property (nonatomic) int totalTouches;
-(id)initWithSize:(CGSize)size color:(NSString *)color;

@end
