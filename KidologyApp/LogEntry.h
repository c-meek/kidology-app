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
@property (nonatomic) float time;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) CGPoint targetLocation;
@property (nonatomic) float targetRadius;
-(id)initWithType:(NSString*)type time:(float)time touchLocation:(CGPoint)touchLocation targetLocation:(CGPoint)targetLocation targetRadius:(float)targetRadius;
@end
