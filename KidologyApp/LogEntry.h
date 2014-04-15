//
//  LogEntry.h
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogEntry : NSObject
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *distanceFromCenter;
@property (nonatomic) BOOL anchorPressed;
@property (nonatomic) BOOL targetOnScreen;
@property (nonatomic) float time;
@property (nonatomic) float targetRadius;
@property (nonatomic) int targetsHit;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) CGPoint targetLocation;
-(id)initWithType:(NSString*)type time:(float)time anchorPressed:(bool)anchorPressed targetsHit:(int)targetsHit
    distanceFromCenter:(NSString *)distanceFromCenter touchLocation:(CGPoint)touchLocation
    targetLocation:(CGPoint)targetLocation targetRadius:(float)targetRadius targetOnScreen:(BOOL)targetOnScreen;
-(NSString *)toString;
@end
