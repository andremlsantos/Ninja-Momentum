//
//  Credits.m
//  NinjaMomentum
//
//  Created by andre on 23/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits
{
    
}

- (void) _return
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
