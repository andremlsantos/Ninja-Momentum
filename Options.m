//
//  Options.m
//  NinjaMomentum
//
//  Created by andre on 21/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Options.h"

@implementation Options

- (void) reset
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (void) unblock
{
    NSString *unbloquedLevels = @"YES";
    [[NSUserDefaults standardUserDefaults] setObject:unbloquedLevels forKey:@"unbloquedLevels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) _return
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];

}

@end
