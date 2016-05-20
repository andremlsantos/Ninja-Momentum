//
//  AudioUtils.h
//  NinjaMomentum
//
//  Created by Student on 20/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef AudioUtils_h
#define AudioUtils_h

@interface AudioUtils : NSObject {
    
}
+ (id)sharedManager;
+ (void)playSlowMotion;
+ (void)playKnifeStab;
+ (void)playThrowKnife;
+ (void)stopEverything;
+ (void) stopEffects;
+ (void) playLevel1Bg;
+ (void) playLevel2Bg;
+ (void) playLevel3Bg;



@end

#endif /* AudioUtils_h */
