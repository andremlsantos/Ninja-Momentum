//
//  LogUtils.m
//  NinjaMomentum
//
//  Created by Student on 18/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "LogUtils.h"

@implementation LogUtils

@synthesize totalDeaths;
@synthesize totalTime;
@synthesize totalRetries;

+ (id)sharedManager {
    static LogUtils *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        totalDeaths = 0;
        totalTime = [NSDate date];
        totalRetries = 0;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

+(void)writeAtEndOfFile:(NSString *)appendedStr withFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:path,
                          documentsDirectory];
    
    NSString *writedStr = [[NSString alloc]initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    writedStr = [writedStr stringByAppendingFormat:appendedStr];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
    }
    
    //save content to the documents directory
    [writedStr writeToFile:fileName
                atomically:YES
                  encoding:NSStringEncodingConversionAllowLossy
                     error:nil];
}

@end
