//
//  TargetPracticeScene.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 2/9/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TargetPracticeScene : SKScene
    @property (nonatomic) SKSpriteNode * target;
    @property (nonatomic) int totalTouches;
    @property (nonatomic) int correctTouches;
@end
