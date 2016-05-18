//
//  LogUtils.h
//  NinjaMomentum
//
//  Created by Student on 18/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef LogUtils_h
#define LogUtils_h

@interface LogUtils : NSObject {
    int totalDeaths;
    NSDate* totalTime;
    int totalRetries;
}

@property (nonatomic, assign) int totalDeaths;
@property (nonatomic, retain) NSDate* totalTime;
@property (nonatomic, assign) int totalRetries;

+ (id)sharedManager;
+ (void)writeAtEndOfFile:(NSString *)appendedStr withFilePath:(NSString *)path;

@end

#endif /* LogUtils_h */
