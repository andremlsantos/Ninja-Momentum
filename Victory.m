//
//  Victory.m
//  NinjaMomentum
//
//  Created by andre on 23/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Victory.h"

@implementation Victory

- (void) _return
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
