//
//  FileBrowser.m
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/7/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "FileBrowser.h"

@implementation FileBrowser
-(id)initWithSize:(CGSize)size
{
    [self listFileAtPath:@"/var/mobile/Applications/50A20629-6CE5-4033-AD18-05AB2F07F83B/Documents/logs/"];
    return self;
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

@end
