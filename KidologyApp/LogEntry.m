//
//  LogEntry.m
//  KidologyApp
//
//  Created by meek, christopher glenn on 3/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

// this class is another utility class to aid in the logging process
// a log entry instatiation captures all of the information pertaining to a single touch

#import "LogEntry.h"

@implementation LogEntry
-(id)initWithType:(NSString*)type time:(float)time anchorPressed:(bool)anchorPressed targetsHit:(int)targetsHit
    distanceFromCenter:(NSString *)distanceFromCenter touchLocation:(CGPoint)touchLocation targetLocation:(CGPoint)targetLocation
     targetRadius:(float)targetRadius targetOnScreen:(BOOL)targetOnScreen
{
    _type = type;
    _time = time;
    _targetsHit = targetsHit;
    _distanceFromCenter = distanceFromCenter;
    _anchorPressed = anchorPressed;
    _touchLocation = touchLocation;
    _targetLocation = targetLocation;
    _targetRadius = targetRadius;
    _targetOnScreen = targetOnScreen;
    return self;
}

// a to string method to writing a log entry to the log file
-(NSString*)toString
{
    NSString *anchorStatus = @"NO";
    if (_anchorPressed)
        anchorStatus = @"YES";
    NSString *targetStatus = @"NO";
    if(_targetOnScreen)
        targetStatus = @"YES";
    return [NSString stringWithFormat:@"%@,%@,%d,%f,%@,%f,%f,%@,%f,%f,%f\n", _type, anchorStatus, _targetsHit,
             _time,_distanceFromCenter, _touchLocation.x, _touchLocation.y, targetStatus, _targetLocation.x, _targetLocation.y, _targetRadius];
}

@end
