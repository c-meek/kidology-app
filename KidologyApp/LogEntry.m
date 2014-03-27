//
//  LogEntry.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "LogEntry.h"

@implementation LogEntry
-(id)initWithType:(NSString*)type time:(float)time touchLocation:(CGPoint)touchLocation targetLocation:(CGPoint)targetLocation targetRadius:(float)targetRadius
{
    _type = type;
    _time = time;
    _touchLocation = touchLocation;
    _targetLocation = targetLocation;
    _targetRadius = targetRadius;
    
    return self;
}

-(NSString*)printInfo
{
    return [NSString stringWithFormat:@"%@,%f,%f,%f,%f,%f,%f\n", _type, _time, _touchLocation.x, _touchLocation.y, _targetLocation.x, _targetLocation.y, _targetRadius];
}
@end
