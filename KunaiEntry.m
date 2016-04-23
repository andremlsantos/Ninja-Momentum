//
//  KunaiEntry.m
//  NinjaMomentum
//
//  Created by Gonçalo Delgado on 23/04/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "KunaiEntry.h"

@implementation KunaiEntry
-(void) ninjato {
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/Ninjato"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) granade {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/Granade"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
-(void) gHook {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/GrapplingHook"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
-(void) kunai {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/Kunai"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
@end
