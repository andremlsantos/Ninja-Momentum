//
//  AudioUtils.m
//  NinjaMomentum
//
//  Created by Student on 18/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "AudioUtils.h"

@implementation AudioUtils

OALSimpleAudio *audio;

+ (id)sharedManager {
    static AudioUtils *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        audio = [OALSimpleAudio sharedInstance];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

+ (void)playSlowMotion{
    [audio playEffect:@"slow_motion.mp3" volume:0.5 pitch:1.0 pan:0.0 loop:false];
}
+ (void)playKnifeStab{
    [audio playEffect:@"knife_stab.mp3"];
}
+ (void)playThrowKnife{
    [audio playEffect:@"throw_knife.wav"];
}

+ (void)playDeathSoundEffect{
    [audio playEffect:@"death.mp3"];
}

+ (void) playLevelCompleteSoundEffect{
    [audio playEffect:@"level_complete.mp3"];
}

+ (void)stopEverything{
    [audio stopEverything];
}
+ (void) stopEffects{
    [audio stopAllEffects];
}
+ (void) playLevel1Bg{
    [audio playBg:@"Level1.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel2Bg{
    [audio playBg:@"Level2.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel3Bg{
    [audio playBg:@"Level3.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel4Bg{
    [audio playBg:@"Level4.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel5Bg{
    [audio playBg:@"Level5.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel6Bg{
    [audio playBg:@"Level6.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel7Bg{
    [audio playBg:@"Level7.mp3" volume:0.1f pan:0.0f loop:true];
}
+ (void) playLevel8Bg{
    [audio playBg:@"Level8.mp3" volume:0.1f pan:0.0f loop:true];
}



@end
